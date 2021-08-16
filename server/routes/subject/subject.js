const subjectRouter = require('express').Router();

const {fetchAllSystemSubjects}  = require('../../controller/subjects/subjects');

subjectRouter.route('/v1/subject/fetch').get(fetchAllSystemSubjects);


module.exports = subjectRouter;