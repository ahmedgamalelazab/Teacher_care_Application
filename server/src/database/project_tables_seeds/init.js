// const KKnex = require('knex');

// const Knex = KKnex.knex();

const bcrypt = require('bcrypt');
require('dotenv').config();


const ordered_table_names = require('../project_tables_names/ordered_table_names');
const TABLE_NAMES = require('../project_tables_names/tableNames');
const EGYPTIAN_CITIES = require('../project_database_source/egyption_cities_source');
const EGYPTIAN_GOVERNORATES = require('../project_database_source/egyptian_governorates_source');
const EGYPTIAN_EDUCATION_LEVEL = require('../project_database_source/egyptian_education_levels_source');
const EGYPTIAN_EDUCATION_SUBJECTS = require('../project_database_source/egyptian_education_subjects_source');
/**
 * @param {Knex} knex 
 */

exports.seed = async function(knex) {
  // Deletes ALL existing entries
  // await  knex('table_name').del();
  await Promise.all(
    ordered_table_names.map((table_name)=>{
      return knex(table_name).del();
    })
  );
  // await Promise.all(Object.keys(ordered_table_names).map((name) => knex(name).del()));

  //starting with EGY-governorates 
  await knex(TABLE_NAMES.governorates_of_Egypt).insert(EGYPTIAN_GOVERNORATES);
  //EGY-municipal cities data entry
  await knex(TABLE_NAMES.governorates_Municipal_divisions).insert(EGYPTIAN_CITIES);
  await knex(TABLE_NAMES.level).insert(EGYPTIAN_EDUCATION_LEVEL);
  //TODO fill the student level table
  await knex(TABLE_NAMES.student_level).insert([
    //============================? primary =========================================
    {level_name_ar:'الأول إبتدائى',level_name_en:'primary-first',level_id:1},
    {level_name_ar:'الثانى إبتدائى',level_name_en:'primary-second',level_id:1},
    {level_name_ar:'الثالث إبتدائى',level_name_en:'primary-third',level_id:1},
    {level_name_ar:'الرابع إبتدائى',level_name_en:'primary-fourth',level_id:1},
    {level_name_ar:'الخامس إبتدائى',level_name_en:'primary-fifth',level_id:1},
    {level_name_ar:'السادس إبتدائى',level_name_en:'primary-sixth',level_id:1},
    //============================? preparatory =========================================
    {level_name_ar:'الأول الإعدادى',level_name_en:'preparatory-first',level_id:2},
    {level_name_ar:'الثانى الإعدادى',level_name_en:'preparatory-second',level_id:2},
    {level_name_ar:'الثالث الإعدادى',level_name_en:'preparatory-third',level_id:2},
    //============================? secondary =========================================
    {level_name_ar:'الأول الثانوى',level_name_en:'secondary-first',level_id:3},
    {level_name_ar:'الثانى الثانوى',level_name_en:'secondary-second',level_id:3},
    {level_name_ar:'الثالث الثانوى',level_name_en:'secondary-third',level_id:3},
  ]);
  await knex(TABLE_NAMES.subject).insert(EGYPTIAN_EDUCATION_SUBJECTS);
  await knex(TABLE_NAMES.account_state).insert(
    [
      {user_state:'active'},
      {user_state:'disabled'},
      {user_state:'banned'},
      {user_state:'deleted'},
    ]
  );
  try{
    const salt = await bcrypt.genSalt(15);
    await knex.transaction(async trx=>{
      const [user] = await knex(TABLE_NAMES.user).insert({
        user_email: 'agemy844@gmail.com',
        user_first_name: 'ahmed',
        user_last_name:'gamal',
        user_password:await bcrypt.hash(process.env.ADMIN_PASSWORD,salt),
        user_account_state_id:1, // account will be always activated God welling
      }).returning('*')
        .transacting(trx);
      console.log(user);
      const [admin] = await knex(TABLE_NAMES.admin).insert({
        // admin_bio:"My name is Gemy , Im the Owner of this application , pleas if any user have any Problem with the service or any complains , you can text me on agemy844@gmail.com , wish the best to Users whom are using this app",
        user_id:user.id
      }).returning('*')
        .transacting(trx);
      console.log(admin);
    })
  }catch(err){
    console.log(err);
  }
};
