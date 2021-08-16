/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */

// here the teacher should be able to create a room and get all the rooms
// where the teacher tries to register a student into a room that's will be in the usersUtils
// so this file will only care for adding a room in the db

const Room = require("../../models/teacher_student_utils/Room");

module.exports.createRoom = async (req, res, next) => {
  const { room_title, room_bio, teacher_id, video_conference_state } = req.body;

  try {
    const create_room_result = await Room.query()
      .insert({
        room_bio: room_bio,
        room_name: room_title,
        teacher_id: teacher_id,
        video_conference_state: video_conference_state,
      })
      .returning("*");

    //if all are ok .. no exception

    return res.status(201).json({
      success: true,
      data: create_room_result,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network fail or server crash !",
    });
  }
};

//get all teacher rooms

module.exports.getTeacherRooms = async (req, res, next) => {
  //every thing will happen on the background of this function
  const teacher_id = req.user_id_child;

  let response = await Room.query().where({
    teacher_id: teacher_id,
  });

  return res.status(200).json({
    success: true,
    data: response,
  });
};
