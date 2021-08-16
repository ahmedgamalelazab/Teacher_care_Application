/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */


// here in this module we will only register the user in the data base

const environment = process.env.NODE_ENV || 'development';

const knexConfig = require('../../knexfile');

const connectionConfig = knexConfig[environment];

const knex = require('knex').knex(connectionConfig);

const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

const Teacher = require('../../models/users/Teacher');

const User = require('../../models/users/User');

// const Teacher_level = require('../../models/user-level-subject/teacher_level');

// const Teacher_subject = require('../../models/user-level-subject/teacher_subject');

const Governorates = require('../../models/address/Governorates');

const Cities = require('../../models/address/Governorates_Municipal_cities');

const Student_level = require('../../models/teacher_student_utils/student_level');

const Parent = require('../../models/users/Parent');

const bcrypt = require('bcrypt');

const Student = require('../../models/users/Student');


//in this file the teacher will be able to add a student in that data base with the following 

//* each student should belong to a teacher , address , student level 
//* each student should be login using teacher provider email address and password 
//* this module don't care for how the user will act after being added to this database but this is only data entry
//control the students insertion 
// if the number of the students exceeds the number that admin detected for him it should return error 


//TODO add this utils in the teacher student register page 
//TODO all the teacher to send a request to fetch all the level related student levels and pass it to this request

module.exports.teacher_student_register = async (req , res , next)=>{


    //we expect the teacher will insert this data about the student
    const {
        user_first_name,
        user_last_name,
        user_email,
        user_password,
        user_account_state_id,
        egyptian_governorate,
        egyptian_related_city,
        student_phone_number,
        student_level,
        teacher_id,
        parent_first_name,
        parent_last_name,
    } = req.body;

    
    
    try{

        let [user] = await User.query().where({
            user_email: user_email,
        });

        //if user found
        if(user){
            res.status(404).json({
                success:false,
                data:"this email registered already!"
            })
        }

        //if not 
        try{

            const students_Number  = await Student.query();

            const [targetTeacher]  = await Teacher.query().where({id : teacher_id});

            if(students_Number.length >= targetTeacher.maximum_students){
                return res.status(400).json({
                    success:false,
                    data:"contact the admin for more students"
                })
            }

            const salt = await bcrypt.genSalt(15);
            let governorate_related_city;
            let data;
            //transaction begins here
            await knex.transaction(async (trx) => {
                //build the address table first
              [data] = await Governorates.query().where({governorate_name_en : egyptian_governorate});
            //if there's a governorate then don't read the next couple of lines
                if(!data){
                    [data] = await Governorates.query().where({governorate_name_ar : egyptian_governorate});
                if(!data){
                   throw(Error('no governorate match !'));       
              }
                governorate_related_city = await Cities.query().where({governorates_of_Egypt_id : data.id}); 
            }
            governorate_related_city = await Cities.query().where({governorates_of_Egypt_id : data.id});
            //now i have a list of related governorate city
            const [City] = governorate_related_city.filter((city)=>{
                // console.log(city);
                return city.city_name_ar === egyptian_related_city || city.city_name_en === egyptian_related_city;
            });
            console.log(City);
            //🚕🚕🚕🚕🚕🚕🚕🚕transaction starts🚕🚕🚕🚕🚕🚕🚕🚕
            //🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕
            const [address] = await knex(TABLE_NAMES.address).insert({
                Governorates_Municipal_divisions_id:City.id,
            })
            .returning('*')
            .transacting(trx)
            const [user] = await knex(TABLE_NAMES.user)
            .insert({
              user_email: user_email,
              user_first_name: user_first_name,
              user_last_name:user_last_name,
              user_password:await bcrypt.hash(user_password , salt),
              user_account_state_id:user_account_state_id,
            })
            .returning('*')
            .transacting(trx)
            //getting the student_level_id
            let [student_level_result] = await Student_level.query().where({
                level_name_ar:student_level
            });
            if(!student_level_result){
                [student_level_result] = await Student_level.query().where({
                    level_name_en:student_level
                });
            }
            const [student] = await knex(TABLE_NAMES.student)
            .insert({
                student_phone_number:student_phone_number,
                teacher_id: teacher_id,
                user_id:user.id,
                address_id:address.id,
                student_level_id:student_level_result.id,
            })
            .returning('*')
            .transacting(trx);
            //adding student should add some data belongs to a parent
            //adding parent of the student 
            const [student_parent] = await knex(TABLE_NAMES.parent).insert({
                student_id:student.id,
                parent_first_name:parent_first_name,
                parent_last_name: parent_last_name,
            })
            .returning('*')
            .transacting(trx);            
            //if all success
            return res.status(201).json({
                success:true,
                data:{
                    student_id:student.id,
                    parent_id:student_parent.id,
                    user_id:user.id,
                    teacher_id:teacher_id,
                    address_id:address.id
                },
            });
    
        })

        }catch(error){
            console.log(error);
            res.status(500).json({
                success:false,
                data:'transaction failed pleas check the code!'
            })
        }

    }catch(error){
        console.log(error);
        res.status(500).json({
            success:false,
            data:'netWork error or server crash!'
        })
    }
    


    // return res.json({
    //     user_first_name,
    //     user_last_name,
    //     user_email,
    //     user_password,
    //     user_account_state_id,
    //     egyptian_governorate,
    //     egyptian_related_city,
    //     student_phone_number,
    //     student_level,
    //     teacher_id
    // })


}


//TODO add some utils to the student to use 
//* the student should be able to add image in his profile 
//* the student should add a student_bio
//* the student should be able to join a video conference
//* the student should be able to make a message and enter an exam in the time when teacher publish exam