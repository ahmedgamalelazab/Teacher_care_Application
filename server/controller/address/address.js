/**
 * ************************created by eng : AHMED GAMAL*****************************************
 * ***********TEACHER_CARE PROJECT AUTH -> REGISTERING USER , LOGGING USERS , LOAD DATA USERS *********
 * DATE OF CREATION : 11-6-2021 2:54 AM FRIDAY NIGHT *******************************************
 * THIS FILES ARE NOT ALLOWED TO BE SHARED TO ALL AND IF SO I WILL SUE THE PUBLISHED ASS 🤨
 */

const { DatabaseError } = require('pg');
const Governorates = require('../../models/address/Governorates');
const Cities = require('../../models/address/Governorates_Municipal_cities');

module.exports.getGovernorates = async(req , res , next)=>{

    const governorates = await Governorates.query();

    return res.status(200).json({
        success : true,
        data : governorates
    });
}

module.exports.getCities = async(req,res,next)=>{

    const cities = await Cities.query();

    return res.status(200).json({
        success : true,
        data : cities
    });

}

//special route to get a specific cities depends on a specific governorate

module.exports.governorateRelatedCities = async(req , res , next)=>{

    //first get the governorate from the url 
    const {governorate} = req.query;
    //second take this governorate and get the id of the governorate
    const [data] = await Governorates.query().where({governorate_name_en : governorate});

    if(!data){
        const [data] = await Governorates.query().where({governorate_name_ar : governorate});
        if(!data){
            return res.status(404).json({
                success: false,
                data: 'not found'
            });
        }
        const governorate_related_city = await Cities.query().where({governorates_of_Egypt_id : data.id});
        return res.send(governorate_related_city);
    }

    const governorate_related_city = await Cities.query().where({governorates_of_Egypt_id : data.id});

    return res.send(governorate_related_city);

}


//when the moderator or admin starts to pick a city for the user they will be able to do that through out this query 
module.exports.getSpecificCity = async (req, res, next)=>{

    const {city} = req.query;

    const [data] = await Cities.query().where({city_name_en : city});

    if(!data){
        const [data] = await Cities.query().where({city_name_ar : city});
        if(!data){
            return res.status(404).json({
                success : false,
                data : 'not found'
            })
        }
        return res.status(200).json({
            success : true,
            data : data
        })

    }

    return res.status(200).json({
        success : true,
        data : data
    })
  
}

//extra queries in case of need it on the application level

module.exports.getGovernorateById = async(req, res , next)=>{

    const {id} = req.params;

    const [data] = await Governorates.query().where({id : id});

    if(!data){
        return res.status(200).json({
            success : false,
            data : 'not found'
        });
    }

    return res.status(200).json({
        success : true,
        data : data
    });

}


module.exports.getCityById = async(req, res , next)=>{

    const {id} = req.params;

    const [data] = await Cities.query().where({id : id});

    if(!data){
        return res.status(200).json({
            success : false,
            data : 'not found'
        });
    }

    return res.status(200).json({
        success : true,
        data : data
    });

}

 


