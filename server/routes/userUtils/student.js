//all student utils will be written here 

const {student_exam_questions , student_exam_questions_answers_report } = require('../../controller/userUtils/Student');

const student_router = require('express').Router();


student_router.route('/v1/student/exam/questions/answers').post(student_exam_questions);


student_router.route('/v1/student/exam/questions/answers/report').post(student_exam_questions_answers_report);





module.exports = student_router;





