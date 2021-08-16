const Model = require('../../src/database/db');
const TABLE_NAMES = require('../../src/database/project_tables_names/tableNames');
const Student = require('./Student');

class Teacher extends Model{

    static get tableName() {
        return TABLE_NAMES.teacher;
    }

    //setup the relations with teacher model
    static get relationMappings(){
        //section of objects
        //avoid module loops
        const Admin = require('../users/Admin');
        const Moderator = require('../users/Moderator');
        const User = require('../users/User');
        const Address = require('../address/address');
        const Level = require('../user-level-subject/Level');
        const Subject = require('../user-level-subject/Subject');
        const Student = require('../users/Student');
        const Room = require('../teacher_student_utils/Room');

      return {
        admin:{
          relation: Model.BelongsToOneRelation,
          modelClass:Admin,
          join:{
            from:`${TABLE_NAMES.teacher}.added_by_admin`,
            to:`${TABLE_NAMES.admin}.id`
          }
        },
        room:{
          relation:Model.HasManyRelation,
          modelClass:Room,
          join:{
            from:`${TABLE_NAMES.teacher}.id`,
            to:`${TABLE_NAMES.room}.teacher_id`
          }
        },
        moderator:{
          relation: Model.BelongsToOneRelation,
          modelClass:Moderator,
          join:{
            from:`${TABLE_NAMES.teacher}.added_by_moderator`,
            to:`${TABLE_NAMES.moderator}.id`
          }
        },
        user:{
          relation: Model.BelongsToOneRelation,
          modelClass:User,
          join:{
            from:`${TABLE_NAMES.teacher}.user_id`,
            to:`${TABLE_NAMES.user}.id`
          }
        },
        address:{
          relation: Model.BelongsToOneRelation,
          modelClass:Address,
          join:{
            from:`${TABLE_NAMES.teacher}.address_id`,
            to:`${TABLE_NAMES.address}.id`
          }
        },
        levels:{
          relation:Model.ManyToManyRelation,
          modelClass:Level,
          join:{
            from:`${TABLE_NAMES.teacher}.id`,
            through:{
              from:`${TABLE_NAMES.teacher_level}.teacher_id`,
              to:`${TABLE_NAMES.teacher_level}.level_id`
            },
            to:`${TABLE_NAMES.level}.id`
          }
        },
        subjects:{
          relation:Model.ManyToManyRelation,
          modelClass:Subject,
          join:{
            from:`${TABLE_NAMES.teacher}.id`,
            through:{
            from:`${TABLE_NAMES.teacher_subject}.teacher_id`,
            to:`${TABLE_NAMES.teacher_subject}.subject_id`
            },
            to:`${TABLE_NAMES.subject}.id`
          }
        },
        student:{
          relation:Model.HasManyRelation,
          modelClass:Student,
          join:{
            from:`${TABLE_NAMES.teacher}.id`,
            to:`${TABLE_NAMES.student}.teacher_id`
          }
        }
      }
    }

}

module.exports = Teacher;