/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */

const jwt = require('jsonwebtoken');


///parent (user) chunk of data and child (the user department |moderator| or |teacher| or |student| or |parent|);
function getJwtToUser(parent , child , user_role){
    const user = {
        user_id:parent.id,
        child_id:child.id,
        user_role:user_role
    }
    console.log(user);
    return new Promise((resolve,reject)=>{
        try{
            const token = jwt.sign(user , process.env.USER_SECRET);
            resolve(token);
        }catch(error){
            reject('error during the crypt process');
        }
    })

}

module.exports = getJwtToUser;