const levelRouter = require('express').Router();

const {fetchAllSystemLevels ,fetchAllStudentLevels}  = require('../../controller/levels/level');

levelRouter.route('/v1/levels/fetch').get(fetchAllSystemLevels);

levelRouter.route('/v1/students/level/fetch').get(fetchAllStudentLevels);


module.exports = levelRouter;