const userRouter = require('express').Router();
const {login} = require('../../controller/users/user_auth');




userRouter.route('/v1/user/login').post(login);



module.exports = userRouter;