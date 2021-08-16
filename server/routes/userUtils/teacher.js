const teacher_route = require('express').Router();

const {
    getAllTeachers ,
    getAllTeachersAddedByModerator,
    getAllTeachersAddedByAdmin ,
    modifyTeacherIsLogged ,
    deleteTeacherAccountUsingSoft ,
    undeleteTeacherAccountUsingSoft
    ,teacher_payed_for_service_true,
    teacher_payed_for_service_false,
    getAllStudentsBelongsToOneTeacher,
    teacher_create_exam,
     teacher_exam_post_question,
     getExamByIdAndRelativeQuestions,
     getAllExamsByRoomId,
     registerStudentToRoom,
     teacher_student_pay_states_true,
     teacher_student_pay_states_false,
     teacherSafeLogOut

} = require('../../controller/userUtils/teacher');



teacher_route.route('/v1/teachers').get(getAllTeachers);

teacher_route.route('/v1/moderator/added/teachers').get(getAllTeachersAddedByModerator);

teacher_route.route('/v1/admin/added/teachers').get(getAllTeachersAddedByAdmin);

teacher_route.route('/v1/teacher/control/:teacher_id').post(modifyTeacherIsLogged);

teacher_route.route('/v1/teacher/control/delete/:teacher_id').post(deleteTeacherAccountUsingSoft);

teacher_route.route('/v1/teacher/control/undelete/:teacher_id').post(undeleteTeacherAccountUsingSoft);

teacher_route.route('/v1/teacher/control/payed_true/:teacher_id').post(teacher_payed_for_service_true);

teacher_route.route('/v1/teacher/control/payed_false/:teacher_id').post(teacher_payed_for_service_false);

teacher_route.route('/v1/teacher/control/getAllStudentsBlongsToOneTeacher/:teacher_id').get(getAllStudentsBelongsToOneTeacher);

teacher_route.route('/v1/teacher/room/control/add_exam_to_room').post(teacher_create_exam);

teacher_route.route('/v1/teacher/room/control/add_exam_to_room/addRelativeQuestions').post(teacher_exam_post_question);

teacher_route.route('/v1/teacher/room/exams/:room_id').get(getAllExamsByRoomId);

teacher_route.route('/v1/teacher/room/exams/relativeQuestions/:exam_id').get(getExamByIdAndRelativeQuestions);

teacher_route.route('/v1/teacher/control/student/register_toRoom').post(registerStudentToRoom);

teacher_route.route('/v1/teacher/control/student/control/month_pay_true/:student_id').post(teacher_student_pay_states_true);

teacher_route.route('/v1/teacher/control/student/control/month_pay_false/:student_id').post(teacher_student_pay_states_false);


teacher_route.route('/v1/teacher/control/logOut/:user_id').get(teacherSafeLogOut);


module.exports = teacher_route;
