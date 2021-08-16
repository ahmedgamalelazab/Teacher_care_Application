const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Teacher_Level extends Model{

    static get tableName() {
        return TABLE_NAMES.teacher_level;
    }

}

module.exports = Teacher_Level;