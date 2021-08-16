const {register} = require('../../controller/users/moderator_auth');

const moderatorRouter = require('express').Router();





moderatorRouter.route('/v1/moderator/register').post(register);





module.exports = moderatorRouter;