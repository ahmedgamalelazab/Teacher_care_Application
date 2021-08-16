const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Admin extends Model{

    static get tableName() {
        return TABLE_NAMES.admin;
    }

    static get relationMappings() {
        // Importing models here is a one way to avoid require loops.
        const User = require('../users/User');
        const Teacher = require('../users/Teacher');
    
        return {  
          user:{
            relation:Model.BelongsToOneRelation,
            modelClass:User,
            join:{
              from:`${TABLE_NAMES.admin}.user_id`, 
              to:`${TABLE_NAMES.user}.id`,
            }
          },
          teacher:{
            relation:Model.HasManyRelation,
            // admin will point to many teachers so i have to point to the teacher table 
            modelClass:Teacher,
            join:{
              from:`${TABLE_NAMES.admin}.id`, 
              to:`${TABLE_NAMES.teacher}.admin_id`,
            }
          }
      }
    }

}
module.exports = Admin;