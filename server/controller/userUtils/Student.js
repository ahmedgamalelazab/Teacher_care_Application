/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */


//we were need to code the student exam test 

const Student_Answer = require('../../models/teacher_student_utils/Student_answer');
const Exam = require('../../models/teacher_student_utils/Exam');
const Student = require('../../models/users/Student');
const Student_report = require('../../models/teacher_student_utils/Student_report');

module.exports.student_exam_questions = async (req, res, next )=>{

    const {
        question_student_final_answer_list,
        student_id,
        exam_id
    } = req.body;
    
    try {
        await Promise.all([
            question_student_final_answer_list.forEach(async(q_id_answer)=>{
                for(var prop in q_id_answer){
                    console.log(prop);
                    console.log(q_id_answer[prop]);
                    await Student_Answer.query().insert({
                        question_id:prop,
                        student_final_answer:q_id_answer[prop],
                        student_id:student_id,
                        exam_id:exam_id
                    })
                }
            })
        ])

        const result = await Student_Answer.query().withGraphJoined({
            question:true,
            exam:true,
            student:true,
        });

        //if all are ok 

        return res.status(201).json({
            success:true,
            data:result
        })
        
    } catch (error) {
        console.log(error);
        res.status(500).json({
            success:false,
            data:'network error or server crash !'
        });
    }

    return res.json({
        question_student_final_answer_list,
        student_id,
        exam_id        
    })

}



//this route only works when the student push the submit answers button
module.exports.student_exam_questions_answers_report = async (req, res, next )=>{

    const {
        student_id,
        exam_id
    } = req.body;
    
    try {
        const result = await Student_Answer.query().withGraphJoined({
            exam:true,
            question:true,
        })
        .where({
            "exam.id":exam_id,
            student_id:student_id
        })

        //TODO check the time of the submit and compare it with the time in the response
        
       let student_mini_report = []; 

       await Promise.all([
            result.forEach((student_answer)=>{
                student_mini_report.push({
                    exam_question:student_answer.question.question_text,                    
                    exam_question_degree:student_answer.exam.exam_question_degree,
                    student_final_answer : student_answer.student_final_answer,
                    question_final_answer:student_answer.question.question_answer_final_answer,
                })
            })
       ]);  
        
       //making a robot to fetch student total marks

       let student_final_marks = 0;

       await Promise.all([
        student_mini_report.forEach((report)=>{
           if(report.student_final_answer === report.question_final_answer){
              student_final_marks += report.exam_question_degree;
           }
        })
       ]);

       //fetch teacher id to build the final report
       const [student_data] = await Student.query().where({
           id:student_id,
       })

       const teacher_id = student_data.teacher_id;

       //section of required data to build a student report 
       //exam_id [✅]
       //student_id [✅]
       //room_id [✅]
       //teacher_id [✅]

       //building the report : : : :  :  : :  : : :

       const report_result = await Student_report.query().insert({
            exam_id:result[0].exam_id,
            exam_total_marks:student_final_marks,
            room_id:result[0].exam.room_id,
            student_id:result[0].student_id,
            teacher_id:teacher_id
       });


        return res.status(201).json({
            success:true,
            data:report_result
        })
        
    } catch (error) {
        console.log(error);
        return res.status(500).json({
            success:false,
            data:'network error or server crash !'
        });
    }


}

