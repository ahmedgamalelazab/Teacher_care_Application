const userRouters = require('express').Router();
const {register} = require('../../controller/users/admin_teacher_auth');




userRouters.route('/v1/admin/teacher/register').post(register);




module.exports = userRouters;