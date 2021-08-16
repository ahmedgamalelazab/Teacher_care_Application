const {parent_get_my_child_exams_report} = require('../../controller/userUtils/globalStudentReportToAll');

const global_utils_router = require('express').Router();


global_utils_router.route('/v1/global_utils/parents/student_report').get(parent_get_my_child_exams_report);



module.exports = global_utils_router;