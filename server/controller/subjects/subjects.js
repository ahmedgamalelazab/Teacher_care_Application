//this module will connect the client will all the subjects from the db 
//dependencies

const Subject = require('../../models/user-level-subject/Subject');


module.exports.fetchAllSystemSubjects = async (req, res, next) => {
    try {
        
        const subjects = await Subject.query();  

        return res.status(200).json({
            success:true,
            data:subjects,
        })

    } catch (error) {
        console.log(error);
        res.status(500).json({
            success:false,
            data:"network error or server crash !"
        });
    }
};
