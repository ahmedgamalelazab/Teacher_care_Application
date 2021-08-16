const systemTeacherDataRouting = require('express').Router();
const {systemTeacherGetMeRequest} = require('../../controller/systemUserData/teacher');
const {user_auth_middle_ware}  = require('../../middleware/auth');



systemTeacherDataRouting.route('/v1/systemTeacherData/teacher/').get(user_auth_middle_ware,systemTeacherGetMeRequest);





module.exports = systemTeacherDataRouting;