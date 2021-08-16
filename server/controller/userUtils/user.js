/**
 * implements each user has only one folder
 * the folder name will be taken from the user name and his id => userName+UserId
 * if the folder not exist , then create this folder
 * if the folder contain already a images , truncate the target image -> depends on the type on the image if its profile or cover one
 * push the image on the server and save it and hash it in the data base by accessing the target user and put it into his image path
 */

//section of requirements
const User = require("../../models/users/User");

const Admin = require("../../models/users/Admin");

const Teacher = require("../../models/users/Teacher");

const Student = require("../../models/users/Student");

const Parent = require("../../models/users/Parent");

const Moderator = require("../../models/users/Moderator");

const fs = require("fs"); //control the server storage

const path = require("path");

const system_roles = require("../../src/system_roles/system_roles");

const system_upload_util = require("../../src/system_uplaod_src/system_upload_helpers");

const Room = require('../../models/teacher_student_utils/Room');

//section of middleware
//this can't fetch the user data to build on top of it the folder so we will pass it with the token

//section of the helper function

///this function expects to get role and string path for his image path on the server
async function hash_user_images_into_their_dataBase(
  userRole,
  imagePath,
  childId,
  ProfileOrCover
) {
  if (ProfileOrCover === system_upload_util.profileImage) {
    //! hash the target user database with the profileImagePath
    switch (userRole) {
      case system_roles.admin:
        await Admin.query()
          .patch({
            image_url: imagePath,
          })
          .where({
            id: childId,
          });
        break;
      case system_roles.moderator:
        await Moderator.query()
          .patch({
            image_url: imagePath,
          })
          .where({
            id: childId,
          });
        break;
      case system_roles.teacher:
        await Teacher.query()
          .patch({
            image_url: imagePath,
          })
          .where({
            id: childId,
          });
        break;
      case system_roles.student:
        await Student.query()
          .patch({
            profile_image: imagePath,
          })
          .where({
            id: childId,
          });
        break;
      default:
        return null;
    }
  } else if (ProfileOrCover === system_upload_util.coverImage) {
    //! hash the target user database with the coverImagePath
    switch (userRole) {
      case system_roles.admin:
        await Admin.query()
          .patch({
            background_image_url: imagePath,
          })
          .where({
            id: childId,
          });
        break;
      case system_roles.moderator:
        await Moderator.query()
          .patch({
            background_image_url: imagePath,
          })
          .where({
            id: childId,
          });
        break;
      case system_roles.teacher:
        await Teacher.query()
          .patch({
            background_image_url: imagePath,
          })
          .where({
            id: childId,
          });
        break;
      case system_roles.student:
        await Student.query()
          .patch({
            background_image_url: imagePath,
          })
          .where({
            id: childId,
          });
        break;
      default:
        return null;
    }
  } else {
    return null;
    //not make sense to get a code out of choices
  }
}

module.exports.upload_user_image = async (req, res, next) => {
  if (!req.files || Object.keys(req.files).length == 0) {
    res.status(404).json({
      success: false,
      data: "No files Uploaded!",
    });
  }
  try {
    // requires folder name
    const userFolderName = `${req.user_id_child}/ProfileImages`; // the id of the user will represent the current folder storage
    // requires path of the folder
    const userFolderPath = `./uploads/${userFolderName}`;
    //requires checking if the folder exist then truncate all the files in in
    if (fs.existsSync(userFolderPath)) {
      await Promise.all([      
        fs.readdir(userFolderPath, async (error, files) => {
          if (error) {
            console.log(error);
            return res.status(500).json({
              success: false,
              data: "just server crash!",
            });
          }
          //if it can read ur files
          for (const file of files) {
            try {
              await Promise.all([
                fs.unlinkSync(path.join(userFolderPath, file)),
              ]);
            } catch (error) {
              console.log(error);
              //on error we can now stop the rest of the program
              return res.status(500).json({
                success: false,
                data: "just server crash!",
              });
            }
          }
        }),
      ]);
    }
    //requires checking for this folder exist or not ?
    if (!fs.existsSync(userFolderPath)) {
      await Promise.all([fs.mkdirSync(userFolderPath, { recursive: true })]);
    }
    // each user now will have his own directory and now it's time to move the files into them
    //fetch the sample file :
    const userImage = req.files.file;

    console.log(userFolderPath);

    const uploadPath = `${userFolderPath}/${userImage.name}`;

    console.log(uploadPath.replace(".", ""));

    const finalPath = uploadPath.replace(".", "");

    userImage.mv(uploadPath, async function (error) {
      if (error) {
        console.log(error);
        return res.status(500).json({
          success: false,
          data: "can not save your image in this folder!",
        });
      }
      //if no error no it's time to hash the image path into the db
      // we have to make the path static to fetch it simply

      //!create a helper function to split the users database and insert the images paths into every single user
      await hash_user_images_into_their_dataBase(
        req.user_role,
        finalPath,
        req.user_id_child,
        system_upload_util.profileImage
      );

      res.status(200).json({
        success: true,
        data: {
          fileName: req.files.file.name,
          fileMemeType: req.files.file.mimetype,
          fileSize: req.files.file.size,
          user_role: req.user_role,
          user_id_parent: req.user_id_parent,
          user_id_child: req.user_id_child,
          user_full_name: req.user_full_name,
          profile_image: finalPath,
        },
      });
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash !",
    });
  }
};

//!what about the cover image ? ? ?  ? ?

module.exports.upload_user_cover_image = async (req, res, next) => {
  if (!req.files || Object.keys(req.files).length == 0) {
    res.status(404).json({
      success: false,
      data: "No files Uploaded!",
    });
  }
  try {
    // requires folder name
    const userFolderName = `${req.user_id_child}/CoverImages`;
    // requires path of the folder
    const userFolderPath = `./uploads/${userFolderName}`;
    //requires checking if the folder exist then truncate all the files in in
    if (fs.existsSync(userFolderPath)) {
      await Promise.all([
        fs.readdir(userFolderPath, async (error, files) => {
          if (error) {
            console.log(error);
            return res.status(500).json({
              success: false,
              data: "just server crash!",
            });
          }
          //if it can read ur files
          for (const file of files) {
            try {
              await Promise.all([
                fs.unlinkSync(path.join(userFolderPath, file)),
              ]);
            } catch (error) {
              console.log(error);
              //on error we can now stop the rest of the program
              return res.status(500).json({
                success: false,
                data: "just server crash!",
              });
            }
          }
        }),
      ]);
    }
    //requires checking for this folder exist or not ?
    if (!fs.existsSync(userFolderPath)) {
      await Promise.all([fs.mkdirSync(userFolderPath, { recursive: true })]);
    }
    // each user now will have his own directory and now it's time to move the files into them
    //fetch the sample file :
    const userImage = req.files.file;

    console.log(userFolderPath);

    const uploadPath = `${userFolderPath}/${userImage.name}`;

    console.log(uploadPath.replace(".", ""));

    const finalPath = uploadPath.replace(".", "");

    console.log(finalPath);

    userImage.mv(uploadPath, async function (error) {
      if (error) {
        console.log(error);
        return res.status(500).json({
          success: false,
          data: "can not save your image in this folder!",
        });
      }

      await hash_user_images_into_their_dataBase(
        req.user_role,
        finalPath,
        req.user_id_child,
        system_upload_util.coverImage
      );

      res.status(200).json({
        success: true,
        data: {
          fileName: req.files.file.name,
          fileMemeType: req.files.file.mimetype,
          fileSize: req.files.file.size,
          user_role: req.user_role,
          user_id_parent: req.user_id_parent,
          user_id_child: req.user_id_child,
          user_full_name: req.user_full_name,
          cover_image: finalPath,
        },
      });
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash !",
    });
  }
};

// upload user Profile after login

module.exports.update_user_profile_after_Login = async (req, res, next) => {
  //this route connected with the user Middleware and this middleware will feed me back with all the data i need to update this profile
  try {
    switch (req.user_role) {
      case system_roles.admin:
        return res.status(200).json({
          success: true,
          data: {
            user_role: req.user_role,
            admin_name: req.user_name,
            admin_bio: req.user_bio,
            profile_image: req.profile_image,
            cover_image: req.cover_image,
            user_child_id: req.user_id_child,
            user_full_name_concat: req.user_full_name,
            user_parent_id: req.user_id_parent,
            admin_account_state: req.user_account_state,
            admin_email: req.user_email,
          },
        });
      case system_roles.moderator:
        return res.status(200).json({
          success: true,
          data: {
            user_role: req.user_role,
            moderator_name: req.user_name,
            moderator_bio: req.user_bio,
            profile_image: req.profile_image,
            cover_image: req.cover_image,
            user_child_id: req.user_id_child,
            user_full_name_concat: req.user_full_name,
            user_parent_id: req.user_id_parent,
            moderator_account_state: req.user_account_state,
            moderator_email: req.user_email,
          },
        });
      case system_roles.teacher:
        return res.status(200).json({
          success: true,
          data: {
            user_role: req.user_role,
            teacher_name: req.user_name,
            teacher_bio: req.user_bio,
            profile_image: req.profile_image,
            cover_image: req.cover_image,
            user_child_id: req.user_id_child,
            user_full_name_concat: req.user_full_name,
            user_parent_id: req.user_id_parent,
            teacher_account_state: req.user_account_state,
            teacher_email: req.user_email,
          },
        });
      case system_roles.student:
        return res.status(200).json({
          success: true,
          data: {
            user_role: req.user_role,
            student_name: req.user_name,
            student_bio: req.user_bio,
            profile_image: req.profile_image,
            cover_image: req.cover_image,
            user_child_id: req.user_id_child,
            user_full_name_concat: req.user_full_name,
            user_parent_id: req.user_id_parent,
            student_account_state: req.user_account_state,
            student_email: req.user_email,
          },
        });
      default:
        return res.status(500).json({
          success: false,
          data: "something went wrong with server during switching users",
        });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      data: "network error or server crash !",
    });
  }
};

// update user bio , it will be global service and available to all kind of users

module.exports.patchUserBio = async (req, res, next) => {
  //expect ot take from the user in the request body => new Bio
  const { user_bio } = req.body;

  //this module will be connected to the auth middleware to get a user detection

  try {
    switch (req.user_role) {
      case system_roles.admin:
        // return the same data because we will update the whole ui //ONLY SAFE MODE
        //this module will only update the user bio so the only thing will be needed to updated is the bio
        //updating
        const [admin_bio_result] = await Admin.query()
          .patch({
            admin_bio: user_bio,
          })
          .where({
            id: req.user_id_child,
          })
          .returning("*");

        console.log(admin_bio_result);

        return res.status(200).json({
          success: true,
          data: {
            user_role: req.user_role,
            admin_name: req.user_name,
            admin_bio: admin_bio_result.admin_bio,
            profile_image: req.profile_image,
            cover_image: req.cover_image,
            user_child_id: req.user_id_child,
            user_full_name_concat: req.user_full_name,
            user_parent_id: req.user_id_parent,
            admin_account_state: req.user_account_state,
            admin_email: req.user_email,
          },
        });
      case system_roles.moderator:
        const [moderator_bio_result] = await Moderator.query()
          .patch({
            moderator_bio: user_bio,
          })
          .where({
            id: req.user_id_child,
          })
          .returning("*");
        console.log(moderator_bio_result);
        return res.status(200).json({
          success: true,
          data: {
            user_role: req.user_role,
            moderator_name: req.user_name,
            moderator_bio: moderator_bio_result.moderator_bio,
            profile_image: req.profile_image,
            cover_image: req.cover_image,
            user_child_id: req.user_id_child,
            user_full_name_concat: req.user_full_name,
            user_parent_id: req.user_id_parent,
            moderator_account_state: req.user_account_state,
            moderator_email: req.user_email,
          },
        });
      case system_roles.teacher:
        const [teacher_bio_result] = await Teacher.query()
          .patch({
            teacher_bio: user_bio,
          })
          .where({
            id: req.user_id_child,
          })
          .returning("*");

        console.log(teacher_bio_result);
        return res.status(200).json({
          success: true,
          data: {
            user_role: req.user_role,
            teacher_name: req.user_name,
            teacher_bio: teacher_bio_result.teacher_bio,
            profile_image: req.profile_image,
            cover_image: req.cover_image,
            user_child_id: req.user_id_child,
            user_full_name_concat: req.user_full_name,
            user_parent_id: req.user_id_parent,
            teacher_account_state: req.user_account_state,
            teacher_email: req.user_email,
          },
        });
      case system_roles.student:
        const [student_bio_result] = await Student.query()
          .patch({
            student_bio: user_bio,
          })
          .where({
            id: req.user_id_child,
          })
          .returning("*");

        console.log(student_bio_result);
        return res.status(200).json({
          success: true,
          data: {
            user_role: req.user_role,
            student_name: req.user_name,
            student_bio: student_bio_result.student_bio,
            profile_image: req.profile_image,
            cover_image: req.cover_image,
            user_child_id: req.user_id_child,
            user_full_name_concat: req.user_full_name,
            user_parent_id: req.user_id_parent,
            student_account_state: req.user_account_state,
            student_email: req.user_email,
          },
        });
      default:
        return res.status(500).json({
          success: false,
          data: "something went wrong with server during switching users",
        });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      data: "network error or server crash !",
    });
  }
};

//user Control screen data will be connected with this route

module.exports.fetchUserControlScreenData = async (req, res, next) => {
  //this module will be connected with the auth middleware so every thing about the user will be here
  //target here get all numbers of all system objects
  //system objects for admin  --> teachers , moderatos  , parents
  //system objects for moderators  --> teachers , parents
  //system objects for teacher --> students , parents
  try {
    switch (req.user_role) {
      case system_roles.admin:
        // do some code
        const admin_moderatos_count = await Moderator.query();
        const admin_teachers_count = await Teacher.query();
        const admin_students_count = await Student.query();
        const admin_parents_count = await Parent.query();

        return res.status(200).json({
          success: true,
          data: {
            user_role: req.user_role,
            total_moderators_in_system: admin_moderatos_count.length,
            total_teachers_in_system: admin_teachers_count.length,
            total_students_in_system: admin_students_count.length,
            total_parents_in_system: admin_parents_count.length,
          },
        });
      case system_roles.moderator:
        //do some code
        const moderator_teachers_count = await Teacher.query();
        const moderator_students_count = await Student.query();
        const moderator_parents_count = await Parent.query();

        return res.status(200).json({
          success: true,
          data: {
            user_role: req.user_role,
            total_teachers_in_system: moderator_teachers_count.length,
            total_students_in_system: moderator_students_count.length,
            total_parents_in_system: moderator_parents_count.length,
          },
        });
      case system_roles.teacher:
        //do some code
      
        const teacher_students_count = await Student.query().where({
          teacher_id : req.user_id_child,
        });
        const teacher_parents_count = await Parent.query();
         
        const teacher_room_count = await Room.query().where({
          teacher_id:req.user_id_child,
        });

        console.log('counting ....');
        console.log(teacher_parents_count);
        console.log(teacher_room_count);

        
        //! get me the room number 

        return res.status(200).json({
          success: true,
          data: {
            user_role: req.user_role,
            total_students_in_system: teacher_students_count.length,
            total_parents_in_system: teacher_parents_count.length,
            total_teacher_rooms_in_system:teacher_room_count.length,
          },
        });
      default:
        return null;
    }

    return res.status(200).json({
      user_child_id: req.user_id_child,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      data: "network error or server crash !",
    });
  }
};
