const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Room extends Model{

    static get tableName() {
        return TABLE_NAMES.room;
    }

    static get relationMappings(){

        const Exam = require('./Exam');
        const Student = require('../users/Student');
        const Teacher = require('../users/Teacher');

        return {
            exam: {
                relation:Model.HasManyRelation,
                modelClass:Exam,
                join:{
                    from:`${TABLE_NAMES.room}.id`,
                    to:`${TABLE_NAMES.exam}.room_id`,
                }
            },
            student: {
                relation:Model.HasManyRelation,
                modelClass:Student,
                join:{
                    from:`${TABLE_NAMES.room}.id`,
                    to:`${TABLE_NAMES.student}.room_id`,
                }
            },
            teacher:{
                relation:Model.BelongsToOneRelation,
                modelClass:Teacher,
                join:{
                    from:`${TABLE_NAMES.room}.teacher_id`,
                    to:`${TABLE_NAMES.teacher}.id`
                }
            }

        }

    }

}

module.exports = Room;