const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Subject extends Model{

    static get tableName() {
        return TABLE_NAMES.subject;
    }

}

module.exports = Subject;