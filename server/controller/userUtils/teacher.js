/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */

//TODO allow teacher to add bio and extra information and his app controllers ❎
//TODO get teachers levels and subjects and all extra utils related to the teacher ❎

//01027888879

const Teacher = require("../../models/users/Teacher");

const environment = process.env.NODE_ENV || "development";

const knexConfig = require("../../knexfile");

const connectionConfig = knexConfig[environment];

const knex = require("knex").knex(connectionConfig);

const TABLE_NAMES = require("../../src/database/project_tables_names/tableNames");

const Exam = require("../../models/teacher_student_utils/Exam");

const Room = require("../../models/teacher_student_utils/Room");

const Student = require("../../models/users/Student");

const Question = require("../../models/teacher_student_utils/Question");

//?✔ get all teachers route
module.exports.getAllTeachers = async (req, res, next) => {
  //TODO get all teachers and how many they are in my system
  try {
    const teachers = await Teacher.query().withGraphJoined({
      user: true,
      levels: true,
      subjects: true,
      address: true,
    });
    // .select("teacher.id" , "user.id","user.user_email");

    //if all are ok

    res.status(200).json({
      success: true,
      data: teachers,
      teachers_count: teachers.length,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      data: "error in network or server crash !",
    });
  }
};

//get all teachers added by Admin

module.exports.getAllTeachersAddedByModerator = async (req, res, next) => {
  try {
    const teachers = await Teacher.query()
      .withGraphJoined({
        moderator: true,
        user: true,
      })
      .where({ added_by_admin: null });

    res.status(200).json({
      success: true,
      data: teachers,
      teachers_count: teachers.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      data: "error in network or server crash !",
    });
  }
};

module.exports.getAllTeachersAddedByAdmin = async (req, res, next) => {
  try {
    const teachers = await Teacher.query()
      .withGraphJoined({
        admin: true,
        user: true,
      })
      .where({ added_by_moderator: null });

    res.status(200).json({
      success: true,
      data: teachers,
      teachers_count: teachers.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      data: "error in network or server crash !",
    });
  }
};

//TODO MAKE A ROUTE THAT WILL MODIFY THE TEACHER account state

//TODO implement log out teachers using the socket io and on the front side make the socket listening to the updates and log every body off
module.exports.modifyTeacherIsLogged = async (req, res, next) => {
  const { teacher_id } = req.params;
  console.log(teacher_id);
  try {
    //patch the teacher isLogged
    const result = await Teacher.query()
      .patch({
        is_logged: false,
      })
      .where({
        id: teacher_id,
      })
      .returning("*");

    //if all ok

    return res.status(201).json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash",
    });
  }
};

//implementing soft delete on the teachers side
//when we delete the teacher account , i have to go and change the account state of the teacher

module.exports.deleteTeacherAccountUsingSoft = async (req, res, next) => {
  try {
    const { teacher_id } = req.params;

    const teacher_deleted = await Teacher.query()
      .patch({
        deleted_at: knex.fn.now(),
      })
      .where({
        id: teacher_id,
      });

    return res.status(201).json({
      success: true,
      data: teacher_deleted,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash",
    });
  }
};

//undelete teacher
module.exports.undeleteTeacherAccountUsingSoft = async (req, res, next) => {
  try {
    const { teacher_id } = req.params;

    const teacher_deleted = await Teacher.query()
      .patch({
        deleted_at: null,
      })
      .where({
        id: teacher_id,
      });

    return res.status(201).json({
      success: true,
      data: teacher_deleted,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      data: "network error or server crash",
    });
  }
};

//control the teacher payed service
//teacher payed for the service true
module.exports.teacher_payed_for_service_true = async (req, res, next) => {
  try {
    const { teacher_id } = req.params;

    const teacher_payed = await Teacher.query()
      .patch({
        payed_for_service: true,
      })
      .where({
        id: teacher_id,
      });

    return res.status(201).json({
      success: true,
      data: teacher_payed,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash",
    });
  }
};

//teacher_didn't pay for the service
module.exports.teacher_payed_for_service_false = async (req, res, next) => {
  try {
    const { teacher_id } = req.params;

    const teacher_payed = await Teacher.query()
      .patch({
        payed_for_service: false,
      })
      .where({
        id: teacher_id,
      });

    return res.status(201).json({
      success: true,
      data: teacher_payed,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash",
    });
  }
};

//how many students belong to each teacher

module.exports.getAllStudentsBelongsToOneTeacher = async (req, res, next) => {
  const { teacher_id } = req.params;

  try {
    let [teacher_students] = await Teacher.query()
      .withGraphJoined({
        student: true,
        user: true,
      })
      .where({
        "teacher.id": teacher_id,
      });

    res.status(200).json({
      success: true,
      data: teacher_students,
      students_number: teacher_students.student.length,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash",
    });
  }
};

//all teacher utils starts here
//the student are all of them connected to the teacher so students utils will come after the teacher utils when all are done

//building the teacher exam util .. the teacher should be able to add exam

module.exports.teacher_create_exam = async (req, res, next) => {
  const {
    exam_bio,
    exam_name,
    exam_duration_in_hrs,
    exam_ends_at,
    exam_starts_at,
    month,
    room_id,
    year,
    exam_question_degree,
  } = req.body;

  try {
    let teacher_exam = await Exam.query().insert({
      exam_bio: exam_bio,
      exam_name: exam_name,
      exam_duration_in_hrs: exam_duration_in_hrs,
      exam_ends_at: exam_ends_at,
      exam_starts_at: exam_starts_at,
      month: month,
      exam_question_degree: exam_question_degree,
      room_id: room_id,
      year: year,
    });

    res.status(201).json({
      success: true,
      data: teacher_exam,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash",
    });
  }

  return res.json({
    exam_bio,
    exam_name,
    exam_duration_in_hrs,
    exam_ends_at,
    exam_starts_at,
    month,
    room_id,
    year,
  });
};

//after creating room and exam the teacher have to able to include questions

module.exports.teacher_exam_post_question = async (req, res, next) => {
  //TODO go build the question object
  //make the exam object have many questions

  const {
    question_text,
    question_answer_one,
    question_answer_two,
    question_answer_three,
    question_answer_final_answer,
    exam_id,
  } = req.body;

  try {
    const question = await Question.query().insert({
      question_text,
      question_answer_one,
      question_answer_two,
      question_answer_three,
      question_answer_final_answer,
      exam_id,
    });

    res.status(201).json({
      success: true,
      data: question,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash",
    });
  }

  return res.json({
    question_text,
    question_answer_one,
    question_answer_two,
    question_answer_three,
    question_answer_final_answer,
    exam_id,
  });
};

//? on of the most important util for the teacher is to get a exam with related questions

module.exports.getAllExamsByRoomId = async (req, res, next) => {
  const { room_id } = req.params;

  try {
    const [result] = await Room.query()
      .withGraphJoined({
        exam: true,
      })
      .where({
        "room.id": room_id,
      });
    res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      data: "error in network or server crash !",
    });
  }
};

module.exports.getExamByIdAndRelativeQuestions = async (req, res, next) => {
  const { exam_id } = req.params;

  try {
    const [result] = await Exam.query()
      .withGraphJoined({
        question: true,
      })
      .where({
        "exam.id": exam_id,
      });
    res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      data: "error in network or server crash !",
    });
  }
};

// important util make the teacher able to register a student by his id to a room

module.exports.registerStudentToRoom = async (req, res, next) => {
  const { room_id, student_id } = req.body;

  try {
    let [student] = await Student.query()
      .patch({
        room_id: room_id,
      })
      .where({
        "student.id": student_id,
      })
      .returning("*");

    return res.status(201).json({
      success: true,
      data: student,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash",
    });
  }
};

//teacher controls the money payments of a student

module.exports.teacher_student_pay_states_true = async (req, res, next) => {
  const { student_id } = req.params;

  try {
    let [student] = await Student.query()
      .patch({
        month_payed: true,
      })
      .where({
        "student.id": student_id,
      })
      .returning("*");

    return res.status(201).json({
      success: true,
      data: student,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash",
    });
  }
};

module.exports.teacher_student_pay_states_false = async (req, res, next) => {
  const { student_id } = req.params;

  try {
    let [student] = await Student.query()
      .patch({
        month_payed: false,
      })
      .where({
        "student.id": student_id,
      })
      .returning("*");

    return res.status(201).json({
      success: true,
      data: student,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      data: "network error or server crash",
    });
  }
};

//this util will be connected to only the teacher !teacher
//this will allow him to safely logout from the application

module.exports.teacherSafeLogOut = async (req, res, next) => {
  const { user_id } = req.params;
  const dataBaseSearchFlag = {
    1: "teacher",
    2: "students",
  };
  //accessing the teacher object in the database and make him take this

  //checking this id whom it's belong to
  //start with the teacher and then we will search in the students data base

  let dataBaseResponseBack = await Teacher.query().where({
    id: user_id,
  });

  if (dataBaseResponseBack.length === 0) {
    dataBaseResponseBack = await Student.query().where({
      id: user_id,
    });
    if (dataBaseResponseBack.length === 0) {
      return res.status(404).json({
        success: false,
        data: `no data for this user who tried to logout from the system!`,
      });
    } else {
      const result = await Student.query()
        .patch({
          is_logged: false,
        })
        .where({
          id: user_id,
        });
      return res.status(200).json({
        success: true,
        data: `the result of this process is : ${result}`,
      });
    }
  }

  //see in the system what id this is belong to
  const result = await Teacher.query()
    .patch({
      is_logged: false,
    })
    .where({
      id: user_id,
    });

  return res.status(200).json({
    success: true,
    data: `the result of this process is : ${result}`,
  });
};
