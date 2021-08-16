// this module will return to the client all the levels from the data base

//dependencies

const Level = require('../../models/user-level-subject/Level');

const StudentLevel = require('../../models/teacher_student_utils/student_level');


module.exports.fetchAllSystemLevels = async (req, res, next) => {
    try {
        
        const levels = await Level.query();  

        return res.status(200).json({
            success:true,
            data:levels,
        })

    } catch (error) {
        console.log(error);
        res.status(500).json({
            success:false,
            data:"network error or server crash !"
        });
    }
};

// student levels will be required to complete the register process

module.exports.fetchAllStudentLevels = async(req , res , next)=>{
    try{

        const studentLevel = await StudentLevel.query();

        //if all are ok 

        res.status(200).json({
            success:true,
            data:studentLevel
        });

    }catch(error){
        console.log(error);
        res.status(500).json({
            success:false,
            data:"internet error or server crash !"
        });
    }
}