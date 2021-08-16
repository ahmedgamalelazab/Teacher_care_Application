const userRouters = require('express').Router();
const {register} = require('../../controller/users/moderator_teacher_auth');




userRouters.route('/v1/moderator/teacher/register').post(register);




module.exports = userRouters;