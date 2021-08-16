const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Student extends Model{

    static get tableName() {
        return TABLE_NAMES.student;
    }

    static get relationMappings(){
        //the user relations
        //the student belongs to one 🔺 room only 🔺 ✅
        //the student belongs to one teacher Or we can say a group of users belongs to one 🔺 teacher 🔺 ✅
        //student belongs to one student level and belongs to one🔺 address 🔺 ✅
        //student belong to one 🔺 user 🔺 ✅

        const Room = require('../teacher_student_utils/Room');
        const Teacher = require('../users/Teacher');
        const Student_level = require('../teacher_student_utils/student_level');
        const Address = require('../address/address');
        const User = require('../users/User');
        const Student_answer = require('../teacher_student_utils/Student_answer');
        const Student_report = require('../teacher_student_utils/Student_report');

        return{
            room:{
                relation:Model.BelongsToOneRelation,
                modelClass: Room,
                join:{
                  from:`${TABLE_NAMES.student}.room_id`,
                  to:`${TABLE_NAMES.room}.id` 
                }
            },
            teacher:{
                relation:Model.BelongsToOneRelation,
                modelClass:Teacher,
                join:{
                  from:`${TABLE_NAMES.student}.teacher_id`,
                  to:`${TABLE_NAMES.teacher}.id`
                }
            },
            student_level:{
                relation:Model.BelongsToOneRelation,
                modelClass:Student_level,
                join:{
                  from:`${TABLE_NAMES.student}.student_level_id`,
                  to:`${TABLE_NAMES.student_level}.id`
                }
            },
            address:{
                relation:Model.BelongsToOneRelation,
                modelClass:Address,
                join:{
                  from:`${TABLE_NAMES.student}.address_id`,
                  to:`${TABLE_NAMES.address}.id`
                }
            },
            user:{
                relation:Model.BelongsToOneRelation,
                modelClass:User,
                join:{
                  from:`${TABLE_NAMES.student}.user_id`,
                  to:`${TABLE_NAMES.user}.id`
                }
            },
            student_answer:{
              relation:Model.HasManyRelation,
              modelClass:Student_answer,
              join:{
                from:`${TABLE_NAMES.student}.id`,
                to:`${TABLE_NAMES.student_answer}.student_id`
              }
          },
          student_report:{
            relation:Model.HasManyRelation,
            modelClass:Student_report,
            join:{
              from:`${TABLE_NAMES.student}.id`,
              to:`${TABLE_NAMES.student_report}.student_id`
            }
        },
        }
    }

}

module.exports = Student;