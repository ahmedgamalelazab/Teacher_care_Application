const jwt = require("jsonwebtoken");

//section of dependencies
const User = require("../models/users/User");

const Admin = require("../models/users/Admin");

const Teacher = require("../models/users/Teacher");

const Student = require("../models/users/Student");

const moderator = require("../models/users/Moderator");

const system_roles = require("../src/system_roles/system_roles");

//helper function will detect the user easy

async function detectUser(user_data_object) {
  try {
    let [user] = await Admin.query().where({
      id: user_data_object.child_id,
    });
    if (!user) {
      [user] = await moderator.query().where({
        id: user_data_object.child_id,
      });
      if (!user) {
        [user] = await Teacher.query().where({
          id: user_data_object.child_id,
        });
        if (!user) {
          [user] = await Student.query().where({
            id: user_data_object.child_id,
          });
          if (!user) {
            return null; // can't detect this , i know this not make sense but this is proper test too
          }
          return {
            user: user,
            role: system_roles.student, //?this is very important for hashing images in the next middleware
          }; //student will be returned from here
        }
        return {
          user: user,
          role: system_roles.teacher, //?this is very important for hashing images in the next middleware
        }; // teacher will be returned from here
      }
      //if there's user that's mean this user is Moderator
      return {
        user: user,
        role: system_roles.moderator, //?this is very important for hashing images in the next middleware
      }; // Moderator will be returned
    }
    //if all the above not make sense so he must be Admin
    return {
      user: user,
      role: system_roles.admin, //?this is very important for hashing images in the next middleware
    }; // admin will be returned
  } catch (error) {
    console.log(error);
  }
}

//helper function that gonna test the child user and fetch the complete data that belongs to the main user parent

async function fetch_user_parent(user, role) {
  try {
    let user_details;
    switch (role) {
      case system_roles.admin:
        [user_details] = await User.query()
          .withGraphJoined({
            admin: true,
          })
          .where({
            "admin.id": user.id,
          });
        return user_details;
      case system_roles.moderator:
        [user_details] = await User.query()
          .withGraphJoined({
            moderator: true,
          })
          .where({
            "moderator.id": user.id,
          });
        return user_details;
      case system_roles.teacher:
        [user_details] = await User.query()
          .withGraphJoined({
            teacher: true,
          })
          .where({
            "teacher.id": user.id,
          });
        return user_details;
      case system_roles.student:
        [user_details] = await User.query()
          .withGraphJoined({
            student: true,
          })
          .where({
            "student.id": user.id,
          });
        return user_details;

      default:
        //error in the code
        return null;
    }
  } catch (error) {
    console.log(error);
  }
}

module.exports.user_auth_middle_ware = async (req, res, next) => {
  try {
    const user_token = req.headers["x-auth-token"]; // dio in the front for flutter will do this job for us 
    if (!user_token) {
      return res.status(401).json({
        success: false,
        data: "you not authorized to use this features , pleas provide the auth token to let u in",
      });
    }
    //try to authorize the user
    let user_data;
    await Promise.all([
      (user_data = jwt.verify(user_token, process.env.USER_SECRET)),
    ]);

    if (!user_data) {
      return res.status(400).json({
        success: false,
        data: "invalid token !",
      });
    }

    //if it's valid token now lets fetch who actually try to upload his image on the server
    const user = await detectUser(user_data);

    //now we have the user now lets go and fetch the parent table with help of this user

    const user_full_detailed = await fetch_user_parent(user.user, user.role);

    //TODO ABSTRACT THE USER_FULL_DETAILED TO SOMETHING THAT UPLOAD ROUTE WILL NEED
    //TODO INJECT IN REQ OBJECT THE ROLE OF THE USER AND SOME DATA TO BUILD A FOLDER WITH HIS NAME

    // i will minimize the response from the data base to something we can send to the next route handler
    // inject into the req object this info
    //# user full name
    //# user id because the folder will marked with the id  of the user
    //# the role of the user to make the next route handler able to dispatch  the data insertion

    console.log(user.role);
    console.log(user_full_detailed);

    if (user.role === system_roles.admin) {
      req.user_role = user.role;
      req.user_name = `${user_full_detailed.user_first_name} ${user_full_detailed.user_last_name}`;
      req.user_bio = user_full_detailed.admin[0].admin_bio;
      req.profile_image = user_full_detailed.admin[0].image_url;
      req.cover_image = user_full_detailed.admin[0].background_image_url;
      req.user_id_child = user_full_detailed.admin[0].id;
      req.user_full_name = `${user_full_detailed.user_first_name}${user_full_detailed.user_last_name}`;
      req.user_id_parent = user_full_detailed.id;
      req.user_account_state = user_full_detailed.user_account_state_id;
      req.user_email = user_full_detailed.user_email;
    } else if (user.role === system_roles.moderator) {
      //TODO implement this moderator to next when it be ready
      req.user_role = user.role;
      req.user_name = `${user_full_detailed.user_first_name} ${user_full_detailed.user_last_name}`;
      req.user_bio = user_full_detailed.moderator[0].moderator_bio;
      req.user_id_child = user_full_detailed.moderator[0].id;
      req.profile_image = user_full_detailed.moderator[0].image_url;
      req.cover_image = user_full_detailed.moderator[0].background_image_url;
      req.user_full_name = `${user_full_detailed.user_first_name}${user_full_detailed.user_last_name}`;
      req.user_id_parent = user_full_detailed.id;
      req.user_account_state = user_full_detailed.user_account_state_id;
      req.user_email = user_full_detailed.user_email;
    } else if (user.role === system_roles.teacher) {
      req.user_role = user.role;
      req.user_name = `${user_full_detailed.user_first_name} ${user_full_detailed.user_last_name}`;
      req.user_bio = user_full_detailed.teacher[0].teacher_bio;
      req.user_id_child = user_full_detailed.teacher[0].id;
      req.profile_image = user_full_detailed.teacher[0].image_url;
      req.cover_image = user_full_detailed.teacher[0].background_image_url;
      req.user_full_name = `${user_full_detailed.user_first_name}${user_full_detailed.user_last_name}`;
      req.user_id_parent = user_full_detailed.id;
      req.user_account_state = user_full_detailed.user_account_state_id;
      req.user_email = user_full_detailed.user_email;
    } else if (user.role === system_roles.student) {
      req.user_role = user.role;
      req.user_name = `${user_full_detailed.user_first_name} ${user_full_detailed.user_last_name}`;
      req.user_bio = user_full_detailed.student[0].student_bio;
      req.user_id_child = user_full_detailed.student[0].id;
      req.profile_image = user_full_detailed.student[0].profile_image;
      req.cover_image = user_full_detailed.student[0].background_image_url;
      req.user_full_name = `${user_full_detailed.user_first_name}${user_full_detailed.user_last_name}`;
      req.user_id_parent = user_full_detailed.id;
      req.user_account_state = user_full_detailed.user_account_state_id;
      req.user_email = user_full_detailed.user_email;
    }
    //before i go to next i examined the guy who tries to access my dataBase and send his info to the next rout
    next();
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: true,
      data: "server is unable to authorize your token",
    });
  }
};
