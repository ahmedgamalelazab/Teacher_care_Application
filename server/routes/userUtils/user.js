const UserRouteUtils = require("express").Router();

const {
  update_user_profile_after_Login,
  upload_user_image,
  upload_user_cover_image,
  patchUserBio,
  fetchUserControlScreenData,
} = require("../../controller/userUtils/user");

const { user_auth_middle_ware } = require("../../middleware/auth");

//before the upload process we will check for the user with a simple middleware and this middleware will split the code into branches
UserRouteUtils.route("/v1/user_utils/upload/profileImages/").post(
  user_auth_middle_ware,
  upload_user_image
);

UserRouteUtils.route("/v1/user_utils/upload/coverImages/").post(
  user_auth_middle_ware,
  upload_user_cover_image
);

UserRouteUtils.route("/v1/user_utils/user/updateProfileAfterLogin/").get(
  user_auth_middle_ware,
  update_user_profile_after_Login
);

UserRouteUtils.route("/v1/user_utils/user/patchUserBio/").patch(
  user_auth_middle_ware,
  patchUserBio
);

UserRouteUtils.route("/v1/user_utils/user/controlScreen/data/fetch/").get(
  user_auth_middle_ware,
  fetchUserControlScreenData
);

module.exports = UserRouteUtils;
