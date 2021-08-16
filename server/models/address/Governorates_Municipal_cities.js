const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Governorates_Municipal_cities extends Model{

    static get tableName() {
        return TABLE_NAMES.governorates_Municipal_divisions;
    }

}

module.exports = Governorates_Municipal_cities;