
/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */

// const User = require('../../models/users/User');

const Moderator = require('../../models/users/Moderator');

const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');


const environment = process.env.NODE_ENV || 'development';

const knexConfig = require('../../knexfile');

const connectionConfig = knexConfig[environment];

const knex = require('knex').knex(connectionConfig);


module.exports.getAllModerators = async (req, res, next)=>{

    try{
        const moderators = await Moderator
        .query()
        .withGraphJoined({
            user:true,
        });

        return res.status(200).json({
            success:true,
            data:moderators,
            moderators_count: moderators.length,
        })

    }catch(error){
        return res.status(500).json({
            success:false,
            data:'server error',
           
        })
    }

}


//TODO modify this using sockets to make the front able to listen to the state and change it immediately 
module.exports.modifyModeratorsIsLoggedState = async(req, res, next)=>{

    const {moderator_id} = req.params;

    try{

        //patch the teacher isLogged 
        const result = await Moderator.query().patch({
            is_logged:false,
        })
        .where({
            id:moderator_id
        })

        //if all ok 

        return res.status(201).json({
            success:true,
            data:result
        })

    }catch(error){
        console.log(error);
        return res.status(500).json({
            success:false,
            data:'network error or server crash'
        })
    }

}

//control the moderator soft delete and is logged 

//?*****
module.exports.deleteModeratorAccountUsingSoft = async(req, res, next)=>{

    try{

        const {moderator_id} = req.params;

        const moderator_deleted = await Moderator.query().patch({
            deleted_at:knex.fn.now()
        })
        .where({
            id:moderator_id
        }) 

        return res.status(201).json({
            success:true,
            data:moderator_deleted
        })

    }catch(error){
        console.log(error);
        return res.status(500).json({
            success:false,
            data:'network error or server crash'
        })
    }



}

//undelete teacher
module.exports.undeleteModeratorAccountUsingSoft = async(req, res, next)=>{

    try{
        const {moderator_id} = req.params;

        const moderator_deleted = await Moderator.query().patch({
            deleted_at:null
        })
        .where({
            id:moderator_id
        }) 

        return res.status(201).json({
            success:true,
            data:moderator_deleted
        })

    }catch(error){
        return res.status(500).json({
            success:false,
            data:'network error or server crash'
        })
    }

}

//TODO allow the moderator to add profile image 
//TODO allow the moderator to add his bio and extra data

