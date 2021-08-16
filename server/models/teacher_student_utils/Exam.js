const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Exam extends Model{

    static get tableName() {
        return TABLE_NAMES.exam;
    }

    static get relationMappings(){

        const Room = require('./Room');
        const Question = require('./Question');
        const Student_answer = require('./Student_answer');

        return {

            room:{
                relation:Model.BelongsToOneRelation,
                modelClass:Room,
                join:{
                    from: `${TABLE_NAMES.exam}.room_id`,
                    to: `${TABLE_NAMES.room}.id`
                }
            },
            question:{
                relation:Model.HasManyRelation,
                modelClass:Question,
                join:{
                    from:`${TABLE_NAMES.exam}.id`,
                    to: `${TABLE_NAMES.question}.exam_id`
                }
            },
            student_answer:{
                relation:Model.HasManyRelation,
                modelClass:Student_answer,
                join:{
                    from:`${TABLE_NAMES.exam}.id`,
                    to: `${TABLE_NAMES.student_answer}.exam_id`
                }
            }

        }

    }

}

module.exports = Exam;