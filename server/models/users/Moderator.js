const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');

class Moderator extends Model{

    static get tableName() {
        return TABLE_NAMES.moderator;
    }

    static get relationMappings() {
        // Importing models here is a one way to avoid require loops.
        const User = require('../users/User');
        return {  
          user:{
            relation:Model.BelongsToOneRelation,
            modelClass:User,
            join:{
              from:`${TABLE_NAMES.moderator}.user_id`, 
              to: `${TABLE_NAMES.user}.id`,
            }
          },
      }
    }

}

module.exports = Moderator;