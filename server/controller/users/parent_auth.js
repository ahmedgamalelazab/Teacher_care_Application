/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */


const User = require('../../models/users/User');

const Teacher = require('../../models/users/teacher');

const Student = require('../../models/users/student');

const Parent = require('../../models/users/Parent');

const getJwtToUser = require('../../utils/userUtils');


// in this file we will focus on let the parent have the ability to login


module.exports.parent_login = async(req, res, next)=>{

    //expecting from the user to get the key of the student to give him the ability to log in 

  try {
    const {user_key} = req.body;

    if(!user_key){
        return res.status(404).json({
            success:false,
            data:'cant continue the process without user_key'
        })
    }
    try{

      //now i have the user key ( student key ) now i will go and search in the student data base and see 
      // if the key match any or not if it's match i will let him in if not i will not let him in 
      let [student] = await Student.query().where({
          id:user_key
      })

      if(!student){
        return res.status(404).json({
            success:false,
            data:'INVALID KEY'
        });
      }

      //if student match , now lets make this parent able to join and continue
      
      let [parent] = await Parent.query()
      .withGraphJoined({
          student:true,
      })
      .where({
          student_id:student.id
      })

      //fetch the name of the student to display his name to his parent 

      const [user] = await User.query().where({
          id:parent.student.user_id
      })

      const [result] = await Student.query().withGraphJoined({
        student_level:true,
    }).where({
        "student.user_id":user.id
    })

      const token = await getJwtToUser(student , parent , process.env.USER_PARENT);


      res.status(200).json({
          success:true,
          data:{
              parent,
              student_name:`${user.user_first_name} ${user.user_last_name}`,
              student_level:result.student_level,
              parent_toke:token,

          }
      });

    }catch(error){
        console.log(error);
        return res.status(404).json({
            success:false,
            data:'INVALID KEY'
        });
    }

  } catch (error) {
    console.log(error);
    return res.status(500).json({
        success:false,
        data:'network error or server crash !'
    });       
  }


}