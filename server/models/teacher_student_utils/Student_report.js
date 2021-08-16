const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Student_report extends Model{

    static get tableName() {
        return TABLE_NAMES.student_report;
    }

    static get relationMappings(){

        //dependencies
         const Exam = require('./Exam');
         const Student = require('../users/Student');
         const Teacher = require('../users/Teacher');
         const Room = require('./Room');

        return {
            exam:{
                relation:Model.BelongsToOneRelation,
                modelClass:Exam,
                join:{
                    from:`${TABLE_NAMES.student_report}.exam_id`,
                    to:`${TABLE_NAMES.exam}.id`
                }
                                    
            },
            student:{
                relation:Model.BelongsToOneRelation,
                modelClass:Student,
                join:{
                    from:`${TABLE_NAMES.student_report}.student_id`,
                    to:`${TABLE_NAMES.student}.id`
                }
                                
            },
            teacher:{
                relation:Model.BelongsToOneRelation,
                modelClass:Teacher,
                join:{
                    from:`${TABLE_NAMES.student_report}.teacher_id`,
                    to:`${TABLE_NAMES.teacher}.id`
                }
                                
            },
            room:{
                relation:Model.BelongsToOneRelation,
                modelClass:Room,
                join:{
                    from:`${TABLE_NAMES.student_report}.room_id`,
                    to:`${TABLE_NAMES.room}.id`
                }               
            }
        }
    }

}

module.exports = Student_report;