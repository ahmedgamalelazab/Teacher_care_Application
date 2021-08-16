/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */

const student_router = require('express').Router();

const {teacher_student_register} = require('../../controller/users/teacher_student_auth');



student_router.route('/v1/teacher/student/register').post(teacher_student_register);




module.exports = student_router;