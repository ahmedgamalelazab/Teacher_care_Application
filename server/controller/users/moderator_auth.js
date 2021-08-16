/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */

const Account_state = require('../../models/users/Account-states');

const Moderator = require('../../models/users/Moderator');

const User = require('../../models/users/User');

const environment = process.env.NODE_ENV || 'development';

const knexConfig = require('../../knexfile');

const connectionConfig = knexConfig[environment];

const knex = require('knex').knex(connectionConfig);

const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

const userToken = require('../../utils/userUtils');

const bcrypt = require('bcrypt');

module.exports.register= async(req, res, next)=>{
    //data coming from admin screen
    const {
        user_first_name,
        user_last_name,
        user_email,
        user_password,
        user_account_state_id, // this will be generated from the mobile or web memory
        moderator_bio
    } = req.body;   

    //TODO valid the email first before going to the transaction 

    let [user] = await User.query().where({
        user_email : user_email
    });

    if(user){
        return res.status(401).json({
            success : false,
            data: 'this account is registered already !'
        });
    }

    try {
        const salt = await bcrypt.genSalt(15);
        await knex.transaction(async trx => {            
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
            console.log(user);
            const [moderator] = await knex(TABLE_NAMES.moderator)
            .insert({
                user_id:user.id,
                moderator_bio:moderator_bio
            })
            .returning('*')
            .transacting(trx)
            const [account_state] = await Account_state.query().where({
                id:user_account_state_id
            });
            // throw(Error('i need to throw error')); // checking if the transactions works fine or not !
            
            return res.status(201).json({
                success : true,
                data: {
                    moderator_name: `${user.user_first_name} ${user.user_last_name}`,
                    moderator_email: user.user_email,
                    moderator_id:moderator.id,
                    account_state:account_state.user_state,
                }
            });
          })
      } catch(err) {
        // Here the transaction has been rolled back.
        console.log(err);
      }
    
    res.status(500).json({
        success:false,
        data:'server error'
    });

};

