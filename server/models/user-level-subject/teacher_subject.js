const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Teacher_Subject extends Model{

    static get tableName() {
        return TABLE_NAMES.teacher_subject;
    }

}
module.exports = Teacher_Subject;