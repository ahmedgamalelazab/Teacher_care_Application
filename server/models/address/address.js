const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Address extends Model{

    static get tableName() {
        return TABLE_NAMES.address;
    }

}

module.exports = Address;