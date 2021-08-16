/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */


const Moderator = require('../../models/users/Moderator');

const User = require('../../models/users/User');

const Admin = require('../../models/users/Admin');

const environment = process.env.NODE_ENV || 'development';

const knexConfig = require('../../knexfile');

const connectionConfig = knexConfig[environment];

const knex = require('knex').knex(connectionConfig);

const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

const userToken = require('../../utils/userUtils');

const Student = require('../../models/users/Student');

const bcrypt = require('bcrypt');

const getJwtToUser = require('../../utils/userUtils');

const Teacher = require('../../models/users/Teacher');

const Governorate = require('../../models/address/Governorates');

const Cities = require('../../models/address/Governorates_Municipal_cities');

const Address = require('../../models/address/address');

const Account_state = require('../../models/users/Account-states');



module.exports.login = async(req, res, next)=>{
    const {user_email , user_password} = req.body;

    //safety point 

    if(!user_email || !user_password){
        return res.status(404).json({
            success:false,
            data:'no data from user entered !'
        });
    }

    //searching with this email in the database
    let [user] = await User.query().where({
        user_email:user_email,
    });

    

    if(!user){
        return res.status(404).json({
            success:false,
            data:'INVALID EMAIL OR PASSWORD',
        })
    }
    //the splitter design
    //? here we should split the data to know who is the user ? teacher or admin or .... parent 

    //start search in the admin db first 
    //?🔑🔑🔑🔑🔑🔑🔑🔥🔥🔥🔥 admin 🔥🔥🔥🔥🔑🔑🔑🔑🔑🔑🔑
    let[child] = await Admin.query().where({
        user_id:user.id// 🎗user_id🎗 is simple the dna of the 🎗child and🎗 🎗user.id🎗 is the dna of the 🎗parent🎗 
    });

    //console.log(user); 🔥🔥🔥🔥 test

    if(child){
       //that's mean i'm admin 
      try{ 
        const [result] = await Admin.query().withGraphFetched({
            user:true,
        });
           //check the admin password
           const passwordIsValid = await bcrypt.compare(user_password,result.user.user_password);
    
           if(!passwordIsValid){
                return res.status(401).json({
                    success:false,
                    data:'INVALID USERNAME OR PASSWORD !'
                });
           }
           const token = await getJwtToUser(result.user , result , process.env.USER_ADMIN);
           // in case of admin here
           return res.status(200).json({
                success:true,
                auth_type:'admin',
                data:{
                    admin_name:`${result.user.user_first_name} ${result.user.user_last_name}`,
                    user_role:'admin',
                    admin_id: result.id,
                    user_id: result.user.id,
                    admin_bio: result.admin_bio,
                    profile_image: result.image_url,
                    cover_image:result.background_image_url,
                    admin_first_name:result.user.user_first_name,
                    admin_last_name:result.user.user_last_name,
                    admin_email:result.user.user_email,
                    admin_account_state:result.user.user_account_state_id,
                    token: token
                }
           });

      }catch(error){
          console.log(error);
        res.status(500).json({
            success: false,
            data:'netWork error or server crash !'
        });
      }
    }
    //?🔑🔑🔑🔑🔑🔑🔑🔑🔑 end admin 🔑🔑🔑🔑🔑🔑🔑🔑🔑

    //?else that's mean the user is not admin and maybe is something from the down below
    //second we can search with the moderators 
    //?🔑🔑🔑🔑🔑🔑🔑🔑🔑 moderator 🔑🔑🔑🔑🔑🔑🔑🔑🔑
    //moderator can login as he want i wont make only one account usage 
    //if moderator got deleted he wont access
    [child] = await Moderator.query().where({
        user_id:user.id,
    });
    
    console.log(child);

    if(child){
        try{
            const [result] = await User.query().withGraphJoined({
                moderator:true,
            }).where({
                user_id:user.id,
            });

            if(result.moderator[0].deleted_at!=null){
                return res.status(404).json({
                  success:false,
                  data:'your account has been suspended pleas contact the admin to let it back'
                })
            }

            console.log(result);

             //check for password
            const passwordIsValid = await bcrypt.compare(user_password,result.user_password);
                if(!passwordIsValid){
                    return res.status(401).json({
                        success:false,
                        data:'INVALID USERNAME OR PASSWORD !'
             });
            }
    
            const [account_state] = await Account_state.query().where({
                id:result.user_account_state_id
            });

            console.log(account_state);
    
            const token = await getJwtToUser(result , result.moderator[0] , process.env.USER_MODERATOR);

            res.status(200).json({
                success:true,
                auth_type:'moderator',
                data:{
                   moderator_name:`${result.user_first_name} ${result.user_last_name}`,
                   moderator_id:result.moderator[0].id,
                   user_id:result.id,
                   user_role:'moderator',
                   moderator_first_name:result.user_first_name,
                   moderator_last_name:result.user_last_name,
                   moderator_email:result.user_email,
                   user_account_state:account_state.user_state,
                   moderator_bio:result.moderator[0].moderator_bio,
                   moderator_image_url:result.moderator[0].image_url,
                   token:token
                }
            });

        }catch(error){
            console.log(error);
            res.status(500).json({
                success: false,
                data:'netWork error or server crash !'
            });
        }
    }
    //?🔑🔑🔑🔑🔑🔑🔑🔑🔑 end moderator 🔑🔑🔑🔑🔑🔑🔑🔑🔑
    
    //teacher will be the third 
    //?🔑🔑🔑🔑🔑🔑🔑🔑🔑 teacher 🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑

    [child] = await Teacher.query().where({
        "user_id":user.id,
    });

    if(child){
      //TODO we wanna make the teacher able to login and check his password and give him a token carrying the data
     try{
        let [teacher] = await Teacher.query().withGraphJoined({
            user:true,levels:true,subjects:true,
        })
        .where({
            user_id:user.id
        })

        //putting a isLogged validation
        //on the front line the teacher will keep his jwt in the memory and if he wanna log out simply he will push log out button 
        //and if two teachers trying to login both of them in the same time the system wont accept this
        if(teacher.is_logged){
            return res.status(404).json({
              success:false,
              data:'you are already logged in'
            })
        }

        if(teacher.deleted_at != null){
            return res.status(404).json({
                success:false,
                data:'your account has been suspended contact the admin to let it back'
            })
        }

        if(!teacher.payed_for_service){
            return res.status(404).json({
                success:false,
                data:"your account has been suspended because you didn't pay the service "
            })
        }

        //check for the password
        const passwordValidation = 
        await bcrypt.compare(user_password,teacher.user.user_password);
        if(!passwordValidation){
            return res.status(401).json({
                success:false,
                data:'INVALID USERNAME OR PASSWORD !'
            });
        };

        //TODO implement a path for logging out to mutate the value to false
        await Teacher.query().patch({
            is_logged:true,
        })
        .where({
            user_id:user.id
        });

        //after updating the teacher getting the latest update
        [teacher] = await Teacher.query().withGraphJoined({
            user:true,levels:true,subjects:true,
        })
        .where({
            user_id:user.id
        })
         

        const token = await getJwtToUser(teacher.user , teacher , process.env.USER_TEACHER);

        //time to filtering the data
        //i should return to the teacher profile screen the following:
        //very important //* address in details 
        //very important //* teacher full name = first_name + last_name
        
        // let addressInDetail = {};
        let target_address;
        let target_municipal;
        let target_governorate;
    
        await Promise.all([
          [target_address] = await Address.query().where({
            id:teacher.address_id
          }),
          [target_municipal] = await Cities.query()
          .where({
              id:target_address.Governorates_Municipal_divisions_id
          }),
          [target_governorate] = await Governorate.query().where({
            id:target_municipal.governorates_of_Egypt_id
          }) 
        ]);
        // console.log(target_address);
        // console.log(target_municipal);
        // console.log(target_governorate);

        const [account_state] = await Account_state.query().where({
            id:teacher.user.user_account_state_id
        });
        //we will stop the student from accessing his account if the account state changed under any condition
        //TODO add admin util to stop the teacher from accessing his account in case of not paying the month payments


        return res.status(200).json({
            success:true,
            auth_type:'teacher',
            data:{
                user_role:'teacher',
                user_id:teacher.user_id,
                teacher_id:teacher.id,
                teacher_bio:teacher.teacher_bio,
                teacher_phone:teacher.teacher_phone_number,
                added_by_admin:teacher.added_by_admin? true : false,
                admin_id:teacher.added_by_admin,
                added_by_moderator:teacher.added_by_moderator? true : false,
                moderator_id:teacher.added_by_moderator,
                teacher_profile_image:teacher.image_url,
                isLogged:teacher.is_logged, //when the teacher log out we will patch this property to false or null
                user_information:{
                user_email:teacher.user.user_email,
                user_name:`${teacher.user.user_first_name} ${teacher.user.user_last_name}`,
                user_account_state:account_state.user_state
                },
                address_information_english:{
                country:target_address.country,
                city_en:target_municipal.city_name_en,              
                governorate_en:target_governorate.governorate_name_en
                },
                address_information_arabic:{
                    country:target_address.country_ar,
                    city_ar:target_municipal.city_name_ar,                
                    governorate_ar:target_governorate.governorate_name_ar,                
                }
                ,
                teacher_level:teacher.levels,
                teacher_subject:teacher.subjects,
                teacher_token:token,
            }

        });

     }catch(error){
         console.log(error);
         return res.status(500).json({
             success:false,
             data:'error in network or server crash',
         })
     }
    }
    //?🔑🔑🔑🔑🔑🔑🔑🔑🔑 end teacher 🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑
    //student will be the third 
     //?🔑🔑🔑🔑🔑🔑🔑🔑🔑 student 🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑

     [child] = await Student.query().where({
        "user_id":user.id,
      });

      if(child){ 

        try{
             //validate user data
        
        await Student.query().patch({
            is_logged:true,
        })
        .where({
            user_id:user.id
        })

        const [result] = await Student.query().withGraphJoined({
            room:true,
            teacher:true,
            student_level:true,
            address:true,
            user:true,
        }).where({
            "student.user_id":user.id
        })


        
        const passwordIsValid = await bcrypt.compare(user_password ,result.user.user_password);

        if(!passwordIsValid){
          return res.status(404).json({
            success:false,
            data:'INVALID USER NAME OR PASSWORD'
          });
        }

        if(!result.month_payed){
            return res.status(404).json({
                success:false,
                data:'your account got suspended because the month paying not yet get payed'
              });
        }

        //building the student address data

        //mix the address operation to be one unit of operations
        let target_address;
        let target_municipal;
        let target_governorate;
    
        await Promise.all([
          [target_address] = await Address.query().where({
            id:result.address_id
          }),
          [target_municipal] = await Cities.query()
          .where({
              id:target_address.Governorates_Municipal_divisions_id
          }),
          [target_governorate] = await Governorate.query().where({
            id:target_municipal.governorates_of_Egypt_id
          }) 
        ]);

        const [account_state] = await Account_state.query().where({
            id:result.user.user_account_state_id
        });

        //we will stop the student from accessing his account if the account state changed under any condition
        //TODO add this util to the teacher to stop the student from accessing his account in case for example of 
        //TODO not paying the month fees

        const token = await getJwtToUser(result.user , result , process.env.USER_STUDENT);



        res.status(200).json({
            success:true,
            auth_type:'student',
            data:{
            user_role:'student',
            student_email_address:result.user.user_email,
            student_first_name:result.user.user_first_name,
            student_first_name:result.user.user_last_name,
            student_full_name:`${result.user.user_first_name} ${result.user.user_last_name}`,
            user_account_state:account_state.user_state,
            student_id:result.id,
            student_user_id:result.user_id,
            student_teacher_id:result.teacher_id,
            student_bio:result.student_bio,
            student_profile_image:result.profile_image,
            student_phone_number : result.student_phone_number,
            student_room:result.room_id,
            user_is_logged:result.is_logged,
            student_month_paying_state:result.month_payed,
            teacher_phone_number:result.teacher.teacher_phone_number,
            teacher_profile_image:result.teacher.image_url,
            student_level:result.student_level,
            address_information_english:{
                country:target_address.country,              
                city_en:target_municipal.city_name_en,              
                governorate_en:target_governorate.governorate_name_en
              },
              address_information_arabic:{
                  country:target_address.country_ar,
                  city_ar:target_municipal.city_name_ar,                
                  governorate_ar:target_governorate.governorate_name_ar,                
              },
            student_token:token,
            }
        });

        }catch(error){
            console.log(error);
            return res.status(500).json({
                success:false,
                data:'netWork Error or server problems'
            })
        }
       
      }
      //?🔑🔑🔑🔑🔑🔑🔑🔑🔑 end student 🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑

      //? the parent will not be added here , he will own his own route to access into system db 
    



}