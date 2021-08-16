const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');


class Student_Level extends Model{

    static get tableName() {
        return TABLE_NAMES.student_level;
    }

    static get relationMappings(){
        // one object ( student_level ) have many students 
        const Student = require('../users/Student');

        return {
            student:{
                relation:Model.HasManyRelation,
                modelClass: Student,
                join:{
                  from:`${TABLE_NAMES.student_level}.id`,
                  to:`${TABLE_NAMES.student}.student_level_id`
                }
            }
        }
    }

}


module.exports = Student_Level;