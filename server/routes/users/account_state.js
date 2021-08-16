const statesRouter = require('express').Router();

const {getAccountStates , getAccountStatesOne , getAccountStatesById} = require('../../controller/users/account_states');



statesRouter.route('/v1/states').get(getAccountStates);

statesRouter.route('/v1/states/one').get(getAccountStatesOne);

statesRouter.route('/v1/states/:id').get(getAccountStatesById);


module.exports = statesRouter;
