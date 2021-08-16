const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');
//the user has many children like admin , moderator , teacher , student , parents

class User extends Model{

    static get tableName() {
        return TABLE_NAMES.user;
    }

    static get relationMappings() {
        // Importing models here is a one way to avoid require loops.
        const Moderator = require('../users/Moderator');
        const Admin = require('../users/Admin');
        const Teacher = require('./Teacher');
        const Student = require('./Student');
        
        return {  
          admin:{
            relation:Model.HasManyRelation,
            modelClass:Admin,
            join:{
              from:`${TABLE_NAMES.user}.id`, 
              to: `${TABLE_NAMES.admin}.user_id`,
            }
          },
          moderator: {
            relation: Model.HasManyRelation,
            // The related model. This can be either a Model
            // subclass constructor or an absolute file path
            // to a module that exports one. We use a model
            // subclass constructor `Animal` here.
            modelClass: Moderator,
            join: {
              from: `${TABLE_NAMES.user}.id`,
              to: `${TABLE_NAMES.moderator}.user_id`
            }
          },
          teacher:{
            relation:Model.HasManyRelation,
            modelClass:Teacher,
            join:{
              from: `${TABLE_NAMES.user}.id`,
              to: `${TABLE_NAMES.teacher}.user_id`
            }
          },
          student:{
            relation:Model.HasManyRelation,
            modelClass:Student,
            join:{
              from: `${TABLE_NAMES.user}.id`,
              to: `${TABLE_NAMES.student}.user_id`
            }
          }
          //continue the rest of the sub tables of the user here **** 
      }
    }

}

module.exports = User;