const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Question extends Model{

    static get tableName() {
        return TABLE_NAMES.question;
    }

    static get relationMappings(){
        const Exam = require('./Exam');

        return {
            exam: {
                relation:Model.BelongsToOneRelation,
                modelClass:Exam,
                join:{
                    from:`${TABLE_NAMES.question}.exam_id`,
                    to: `${TABLE_NAMES.exam}.id`
                }
            }
        }
    }
}

module.exports = Question;