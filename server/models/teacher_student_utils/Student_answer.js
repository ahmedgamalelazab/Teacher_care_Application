const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Student_Answer extends Model{

    static get tableName() {
        return TABLE_NAMES.student_answer;
    }

    //lets set the relation between the student answer and the exam and the questions 

    static get relationMappings(){

        const  Question = require('./Question');

        const Exam = require('./Exam');

        const Student = require('../users/Student');

        return {
            question:{
                relation:Model.BelongsToOneRelation,
                modelClass:Question,
                join:{
                    from:`${TABLE_NAMES.student_answer}.question_id`,
                    to:`${TABLE_NAMES.question}.id`
                }
            },
            exam:{
                relation:Model.BelongsToOneRelation,
                modelClass:Exam,
                join:{
                    from:`${TABLE_NAMES.student_answer}.exam_id`,
                    to:`${TABLE_NAMES.exam}.id`
                }
            },
            student:{
                relation:Model.BelongsToOneRelation,
                modelClass:Student,
                join:{
                    from:`${TABLE_NAMES.student_answer}.student_id`,
                    to:`${TABLE_NAMES.student}.id`
                }
            }
        }
    }

}

module.exports = Student_Answer;