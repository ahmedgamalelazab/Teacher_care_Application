// this module will fetch each one of the users by his token in order to update the user screens after logging

const Teacher = require('../../models/users/Teacher');

const Governorate = require('../../models/address/Governorates');

const Cities = require('../../models/address/Governorates_Municipal_cities');

const Address = require('../../models/address/address');

const Account_state = require('../../models/users/Account-states');




module.exports.systemTeacherGetMeRequest = async (req, res, next) => {
  // this module will be connected with the user middleware
  try {
    // the middleware will return to me data relative to the teacher
    [teacher] = await Teacher.query()
      .withGraphJoined({
        user: true,
        levels: true,
        subjects: true,
      })
      .where({
        user_id: req.user_id_parent,
      });

    let target_address;
    let target_municipal;
    let target_governorate;

    await Promise.all([
      ([target_address] = await Address.query().where({
        id: teacher.address_id,
      })),
      ([target_municipal] = await Cities.query().where({
        id: target_address.Governorates_Municipal_divisions_id,
      })),
      ([target_governorate] = await Governorate.query().where({
        id: target_municipal.governorates_of_Egypt_id,
      })),
    ]);
    // console.log(target_address);
    // console.log(target_municipal);
    // console.log(target_governorate);

    const [account_state] = await Account_state.query().where({
      id: teacher.user.user_account_state_id,
    });

    return res.status(200).json({
      success: true,
      data: {
        user_role: "teacher",
        user_id: teacher.user_id,
        teacher_id: teacher.id,
        teacher_bio: teacher.teacher_bio,
        teacher_phone: teacher.teacher_phone_number,
        added_by_admin: teacher.added_by_admin ? true : false,
        admin_id: teacher.added_by_admin,
        added_by_moderator: teacher.added_by_moderator ? true : false,
        moderator_id: teacher.added_by_moderator,
        teacher_profile_image: teacher.image_url,
        teacher_backGround_image:teacher.background_image_url,
        isLogged: teacher.is_logged, //when the teacher log out we will patch this property to false or null
        user_information: {
          user_email: teacher.user.user_email,
          user_name: `${teacher.user.user_first_name} ${teacher.user.user_last_name}`,
          user_account_state: teacher.user.user_account_state_id,
        },
        address_information_english: {
          country: target_address.country,
          city_en: target_municipal.city_name_en,
          governorate_en: target_governorate.governorate_name_en,
        },
        address_information_arabic: {
          country: target_address.country_ar,
          city_ar: target_municipal.city_name_ar,
          governorate_ar: target_governorate.governorate_name_ar,
        },
        teacher_level: teacher.levels,
        teacher_subject: teacher.subjects,       
      },
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "connection error or server crash !",
    });
  }
};
