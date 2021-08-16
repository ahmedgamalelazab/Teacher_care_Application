// coding the student report so in this file this will be the last touch 
//because this will be the last touch so ... this will be the last thing will touch for now and later 
//we will implement the remain futures .. such as : putting a profile picture and so on 

//dependencies

const Student = require('../../models/users/Student');

const Teacher = require('../../models/users/teacher');

const Exam = require('../../models/teacher_student_utils/Exam');

const Room = require('../../models/teacher_student_utils/Room');

const Student_Report = require('../../models/teacher_student_utils/Student_report');

const User = require('../../models/users/User');

//this route the student parent will use it and the teacher 
module.exports.parent_get_my_child_exams_report = async (req, res, next)=>{

    // parent will log in 
    // parent will go and click on his child picture or tile 
    // parent will find a lot of buttons on of them get my kid report 
    // then the screen will contain the student id so with this id i can get every thing about his child
    const {parent_student_child_id} = req.body;

    try {

        let student_reports = await Student_Report.query().withGraphJoined({
            student:true,
            exam:true,
            room:true,
            teacher:true,
        })
        .where({
            "student_id":parent_student_child_id
        })

        //teacher_name fetching ....
        const [teacher_data] = await Teacher.query().where({
            id:student_reports[0].teacher_id,
        })

        const [teacher_user_data] = await User.query().where({
            id:teacher_data.user_id
        });

        const teacher_name = `${teacher_user_data.user_first_name} ${teacher_user_data.user_last_name}`;

        //student_data
        const [student_data] = await Student.query().where({
            id:student_reports[0].student_id,
        })

        const [student_user_data] = await User.query().where({
            id:student_data.user_id
        });

        const student_name = `${student_user_data.user_first_name} ${student_user_data.user_last_name}`;
         
        //the report should arrive to parent with this data :
        //teacher_name : [✅],
        //student_name: [✅],
        //exam_name: [✅],
        //room_name:[✅],
        //student_full_marks : [✅]

        let parent_public_report = [];

        student_reports.forEach((report)=>{

            parent_public_report.push({
                exam_name:report.exam.exam_name,
                room_name:report.room.room_name,
                student_full_marks:report.exam_total_marks,
                teacher_name,
                student_name
            });


        })



        return res.status(200).json({
            success:true,
            data:parent_public_report
        })
        
    } catch (error) {
      console.log(error);
      return res.status(500).json({
          success:false,
          data:'network error or server crash !'
      })
    }

}
