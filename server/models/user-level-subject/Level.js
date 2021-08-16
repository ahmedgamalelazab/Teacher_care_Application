const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Level extends Model{

    static get tableName() {
        return TABLE_NAMES.level;
    }

}

module.exports = Level;