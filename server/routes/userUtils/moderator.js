const {
    getAllModerators ,
    modifyModeratorsIsLoggedState,
    deleteModeratorAccountUsingSoft,
    undeleteModeratorAccountUsingSoft
} = require('../../controller/userUtils/moderator');
const ModeratorsRouter = require('express').Router();




ModeratorsRouter.route('/v1/moderators').get(getAllModerators);

ModeratorsRouter.route('/v1/moderator/control/:moderator_id').post(modifyModeratorsIsLoggedState);

ModeratorsRouter.route('/v1/moderator/control/delete/:moderator_id').post(deleteModeratorAccountUsingSoft);

ModeratorsRouter.route('/v1/moderator/control/undelete/:moderator_id').post(undeleteModeratorAccountUsingSoft);



module.exports = ModeratorsRouter;