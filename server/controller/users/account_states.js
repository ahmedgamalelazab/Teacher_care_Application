/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */


const Account_States = require('../../models/users/Account-states');


module.exports.getAccountStates = async (req, res, next)=>{
    const data = await Account_States.query();
    if(!data){
        res.status(404).json({
            success : false,
            data : 'not found'
        });
    }
    return res.status(200).json({
        success: true,
        data: data 
    })
}

module.exports.getAccountStatesOne = async (req , res , next)=>{

    const {state} = req.query;

    const [data] = await Account_States.query().where({user_state : state});
    
    if(!data){
        return res.status(404).json({
            success: false,
            data: 'not found'
        })
    }

    return res.status(200).json({
        success: true,
        data: data
    })

}

module.exports.getAccountStatesById = async(req , res , next)=>{
    const {id} = req.params;

    const [data] = await Account_States.query().where({id : id});

    if(!data){
        return res.status(404).json({
            success: false,
            data: 'not found'
        });
    }

    return res.status(200).json({
        success: true,
        data: data
    })
}