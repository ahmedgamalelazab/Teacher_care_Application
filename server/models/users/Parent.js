const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Parent extends Model{

    static get tableName() {
        return TABLE_NAMES.parent;
    }

    static get relationMappings(){

        const Student = require('./Student');

        return {
            student:{
                relation:Model.BelongsToOneRelation,
                modelClass:Student,
                join:{
                    from:`${TABLE_NAMES.parent}.student_id`,
                    to:`${TABLE_NAMES.student}.id`
                }
            }
        }

    }

}

module.exports = Parent;