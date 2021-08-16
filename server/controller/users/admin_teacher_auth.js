/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */


//code section 
const environment = process.env.NODE_ENV || 'development';

const knexConfig = require('../../knexfile');

const connectionConfig = knexConfig[environment];

const knex = require('knex').knex(connectionConfig);

const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

// const userToken = require('../../utils/userUtils');

const bcrypt = require('bcrypt');

// const Teacher = require('../../models/users/Teacher');

const User = require('../../models/users/User');

const Level = require('../../models/user-level-subject/Level');

const Subject = require('../../models/user-level-subject/Subject');

// const Teacher_level = require('../../models/user-level-subject/teacher_level');

// const Teacher_subject = require('../../models/user-level-subject/teacher_subject');

const Governorates = require('../../models/address/Governorates');

const Cities = require('../../models/address/Governorates_Municipal_cities');

const Admin = require('../../models/users/Admin');


module.exports.register = async(req , res , next)=>{
    /**
     * ? user_first_name => teacher first name $$ last_name so 
     * ? with email this will be the email to use it to login in the system
     * ? user account state is the state of the account active or disabled or banned 
     * ? egyptian_governorate will come from the ui of the form and we will do query to attach it to municipals
     * ? egyptian_related city will be used to fetch the id of the target municipal and will be attached later 
     * ? to fill the address with data and fetch the address id and fill the teacher with it
     */
    const {
        user_first_name,
        user_last_name,
        user_email,
        user_password,
        user_account_state_id,
        student_maximum_number,
        egyptian_governorate,
        egyptian_related_city,
        teacher_phone_number,
        payed_for_service,
        level, // array of levels 
        subject, // array of subjects
    } = req.body;   


    //check if the email is exist or not

    //mongodb 
    //orm like mongodb 
    let [user] = await User.query().where({
        user_email:user_email,
    });

    if(user){
        return res.status(404).json({
            success:false,
            data:'this email has registered already !'
        });
    }

    //if no user registered in the system then we will take the whole things and make one transaction
    try{
        const salt = await bcrypt.genSalt(15);
        let governorate_related_city;
        let data;
        let levels_ids = [];
        let subjects_ids = [];
        let target_level;
        let target_subject;
        //fill a list of levels id
       await Promise.all([
        level.every(async(levelObject)=>{
            [target_level] = await Level.query().where({
                level_name_en:levelObject
            });
            if(!target_level){
                [target_level] = await Level.query().where({
                    level_name_ar:levelObject
                });
                if(!target_level){                
                    throw(Error('no level match !'));
                }
                console.log('test from the problem source arabic response');
                console.log(target_level);
                levels_ids.push(target_level.id);
                return false;
            }
            //if level found
            console.log('test from the problem source english response');
            console.log(target_level);
            levels_ids.push(target_level.id);
        }),
        //get the subjects id
        subject.every(async(subjectObject)=>{
            [target_subject] = await Subject.query().where({
                subject_name_en:subjectObject
            });
            if(!target_subject){
                [target_subject] = await Subject.query().where({
                    subject_name_ar:subjectObject
                });
                if(!target_subject){                
                    throw(Error('no subject match !'));
                }
                console.log('testing the call from the arabic subject problem');
                console.log(target_subject);
                subjects_ids.push(target_subject.id);
                return false;
            }
            //if level found
            console.log('testing the call from the english subject problem');
            console.log(target_subject);
            subjects_ids.push(target_subject.id);
        })
       ]);
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
        const [admin] = await Admin.query().withGraphJoined({
            user:true,
        });        
        const [teacher] = await knex(TABLE_NAMES.teacher)
        .insert({
            teacher_phone_number:teacher_phone_number,
            payed_for_service:payed_for_service,
            added_by_admin: admin.id,
            user_id:user.id,
            address_id:address.id,
            maximum_students:student_maximum_number,
        })
        .returning('*')
        .transacting(trx);
        //adding teacher levels and subjects
        console.log(levels_ids);
        console.log(subjects_ids);
        await Promise.all(
        [
            levels_ids.forEach(async(id)=>{
                const result = await knex(TABLE_NAMES.teacher_level)
                .insert({
                    teacher_id:teacher.id,
                    level_id:id
                })
                .returning('*')
                .transacting(trx);
            }),
            subjects_ids.forEach(async(id)=>{
                const result = await knex(TABLE_NAMES.teacher_subject)
                .insert({
                    teacher_id:teacher.id,
                    subject_id:id
                })
                .returning('*')
                .transacting(trx);
            })
        ]
        );

        //this job is the job of admin to just insert a teacher in the database 
        //the job of login and get a token should not be programmed here 
        //the register job is just a job to insert teacher data in the db that's it 
        //when the teacher tries to login now the teacher will get the token and the rest
        
        //if all success

        // throw(Error('checking if the data will be transmitted ?'))

        return res.status(201).json({
            success:true,
            data:{
                teacher_id:teacher.id,
                maximum_students:teacher.maximum_students,
                user_id:user.id,
                admin_id:admin.id,
                address_id:address.id
            },
        });

       

    })
    }catch(error){
        console.log(error);
        return res.status(500).json({
            success:false,
            data:error
        });
    }

    // return res.json({
    //     user_first_name,
    //     user_last_name,
    //     user_email,
    //     user_password,
    //     user_account_state_id,
    //     egyptian_governorate,
    //     egyptian_related_city,
    //     teacher_phone_number,
    //     payed_for_service        
    // });
}
