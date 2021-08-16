const parentRouting = require('express').Router();

const {parent_login}  = require('../../controller/users/parent_auth');



parentRouting.route('/v1/student/parent/login').post(parent_login);



module.exports = parentRouting;