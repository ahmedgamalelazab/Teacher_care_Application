const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Governorates extends Model{

    static get tableName() {
        return TABLE_NAMES.governorates_of_Egypt;
    }
    

}

module.exports = Governorates;