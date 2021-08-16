const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Account_States extends Model{

    static get tableName() {
        return TABLE_NAMES.account_state;
    }

}

module.exports = Account_States;