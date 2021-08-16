// const KKnex = require('knex');

// const Knex = KKnex.knex();

const TABLE_NAMES = require('../project_tables_names/tableNames');

const  { addDefaultColumns, addTableFromTwoRowsOnly ,teacherManyToManyTables} = require('../../../utils/tableUtils');

/**
 * @param {Knex} knex 
 */
 exports.up = async function up(knex) {
    //?account_state table
    await addTableFromTwoRowsOnly(knex , TABLE_NAMES.account_state,'user_state',150);
    // await addTableFromTwoRowsOnly(knex , TABLE_NAMES.level,'level_name',150);
    await knex.schema.createTable(TABLE_NAMES.level , (table)=>{
        table.increments('id').primary();
        table.string('level_name_ar' , 50);
        table.string('level_name_en' , 50);
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    //creating student level table
    await knex.schema.createTable(TABLE_NAMES.student_level , (table)=>{
        table.increments('id').primary();
        table.integer('level_id').notNullable();
        table.foreign('level_id').references('id').inTable(TABLE_NAMES.level)
        .onUpdate('CASCADE') // If Article PK is changed, update FK as well.
        .onDelete('CASCADE')
        table.text('level_name_ar').notNullable();
        table.text('level_name_en').notNullable();
    });
    // await addTableFromTwoRowsOnly(knex , TABLE_NAMES.subject,'subject_name',150);
    await knex.schema.createTable(TABLE_NAMES.subject , (table)=>{
        table.increments('id').primary();
        table.string('subject_name_ar' , 50);
        table.string('subject_name_en' , 50);
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    // await addTableFromTwoRowsOnly(knex , TABLE_NAMES.governorates_of_Egypt,'governorate_name',150);
    await knex.schema.createTable(TABLE_NAMES.governorates_of_Egypt , (table)=>{
        table.increments('id').primary();
        table.string('governorate_name_ar' , 50);
        table.string('governorate_name_en' , 50);
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    await knex.schema.createTable(TABLE_NAMES.user,(table)=>{
        table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()')); //  primary key 🔴
        table.string('user_first_name',100).notNullable();
        table.string('user_last_name',100).notNullable();
        table.string('user_email',150).notNullable();
        table.string('user_password',150).notNullable();
        table.integer('user_account_state_id').notNullable();
        table.foreign('user_account_state_id').references('id').inTable(TABLE_NAMES.account_state)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        addDefaultColumns(table); //✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    await knex.schema.createTable(TABLE_NAMES.admin , (table)=>{
        table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()')); // this is the admin id
        table.text('admin_bio'); //? can be null , admin put anything he wants ! u know why ? because i'm the admin 😉 //  primary key 🔴
        table.uuid('user_id').notNullable(); // that what iam going to reference
        table.text('image_url');//this will hash the profile image from the server storage
        table.text('background_image_url'); // this will hash the image path from the server storage
        table.foreign('user_id').references('id').inTable(TABLE_NAMES.user) 
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    await knex.schema.createTable(TABLE_NAMES.moderator , (table)=>{
        table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()')); // this is the moderator id  //  primary key 🔴
        table.text('moderator_bio'); //😒😒😒
        table.uuid('user_id').notNullable(); // moderator is a user like anybody else in the application
        table.text('image_url');
        table.text('background_image_url'); // this will hash the path of the background image from the  server storage
        table.boolean('is_logged'); // this will initialized once he login
        table.foreign('user_id').references('id').inTable(TABLE_NAMES.user)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    await knex.schema.createTable(TABLE_NAMES.governorates_Municipal_divisions ,(table)=>{
        table.increments('id').primary(); //  primary key 🔴
        table.integer('governorates_of_Egypt_id').notNullable();
        table.foreign('governorates_of_Egypt_id').references('id').inTable(TABLE_NAMES.governorates_of_Egypt)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        table.string('city_name_ar',250).notNullable();
        table.string('city_name_en',250).notNullable();
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    await knex.schema.createTable(TABLE_NAMES.address , (table)=>{
        table.increments('id').primary(); //  primary key 🔴
        table.string('country').notNullable().defaultTo('Egypt'); //🔴⚪⚫ // i love egypt
        table.string('country_ar').notNullable().defaultTo('مصر'); //🔴⚪⚫ // i love egypt
        table.integer('Governorates_Municipal_divisions_id').notNullable();
        table.foreign('Governorates_Municipal_divisions_id').references('id').inTable(TABLE_NAMES.governorates_Municipal_divisions)
        .onUpdate('CASCADE')
        .onDelete('CASCADE')
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });

    await knex.schema.createTable(TABLE_NAMES.teacher , (table)=>{
        table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()')); // id of the teacher table 🔴
        table.uuid('user_id').notNullable();
        table.foreign('user_id').references('id').inTable(TABLE_NAMES.user)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        table.text('teacher_bio');
        table.integer('maximum_students').notNullable().defaultTo(0);
        table.integer('address_id').notNullable();//every single teacher should have a address 
        table.foreign('address_id').references('id').inTable(TABLE_NAMES.address)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        table.text('teacher_phone_number').notNullable();
        table.uuid('added_by_admin'); // lets references this shit ! //?it can be null because i don't know who added him
        table.uuid('added_by_moderator'); // lets references this shit ! //? it can be null because i don't know who added him
        table.foreign('added_by_admin').references('id').inTable(TABLE_NAMES.admin)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        table.foreign('added_by_moderator').references('id').inTable(TABLE_NAMES.moderator)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        table.text('image_url');
        table.text('background_image_url'); // this will hash the image path from the server local storage
        table.boolean('is_logged');
        table.boolean('payed_for_service').notNullable();
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    await  teacherManyToManyTables(knex , TABLE_NAMES.teacher_level ,TABLE_NAMES.level, 'level_id');
    await  teacherManyToManyTables(knex , TABLE_NAMES.teacher_subject ,TABLE_NAMES.subject, 'subject_id');
    await knex.schema.createTable(TABLE_NAMES.room , (table)=>{
        table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()')); //primary key 🔴
        table.text('room_bio'); 
        table.string('room_name',150);
        table.boolean('video_conference_state').notNullable().defaultTo(false);
        table.uuid('teacher_id').notNullable();
        table.foreign('teacher_id').references('id').inTable(TABLE_NAMES.teacher)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    await knex.schema.createTable(TABLE_NAMES.student , (table)=>{
        //this is a student so the id of the student will be uuid 
        table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()')); //primary key 🔴
        table.uuid('user_id').notNullable();
        table.uuid('teacher_id').notNullable();
        table.foreign('user_id').references('id').inTable(TABLE_NAMES.user)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        table.foreign('teacher_id').references('id').inTable(TABLE_NAMES.teacher)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        table.text('student_bio');
        table.text('profile_image');
        table.text('background_image_url'); // this will hash the image from the server local storage
        table.text('student_phone_number').notNullable();
        table.integer('address_id').notNullable();//every single teacher should have a address 
        table.foreign('address_id').references('id').inTable(TABLE_NAMES.address)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE')
        table.boolean('is_logged');
        table.uuid('room_id'); // student in the creating level it's not important to connect to a room 
        table.foreign('room_id').references('id').inTable(TABLE_NAMES.room)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        table.integer('student_level_id').notNullable();
        table.foreign('student_level_id').references('id').inTable(TABLE_NAMES.student_level)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        table.boolean('month_payed').defaultTo('false'); // at the end of the month teacher will press one button
        //to reset all month payed to all student to start the false state again to all students in the next month
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅

    });
    await knex.schema.createTable(TABLE_NAMES.parent , (table)=>{
        table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()')); // primary key 🔴
        table.uuid('student_id').notNullable();
        table.foreign('student_id').references('id').inTable(TABLE_NAMES.student)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE')
        table.string('parent_first_name',100).notNullable();
        table.string('parent_last_name',100).notNullable();
        table.string('parent_profile_image');
        table.text('background_image_url'); // this will hash the image path from the server local storage
        table.string('parent_bio');
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    await knex.schema.createTable(TABLE_NAMES.message , (table)=>{
        table.increments('id').primary(); //  primary key 🔴
        table.text('message').notNullable();
        //💨💨💨💨💨💨 FROM section
        table.uuid('from_admin');
        table.foreign('from_admin').references('id').inTable(TABLE_NAMES.admin)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        //
        table.uuid('from_moderator');
        table.foreign('from_moderator').references('id').inTable(TABLE_NAMES.moderator)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        //
        table.uuid('from_teacher');
        table.foreign('from_teacher').references('id').inTable(TABLE_NAMES.teacher)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        //
        table.uuid('from_student');
        table.foreign('from_student').references('id').inTable(TABLE_NAMES.student)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        //
        table.uuid('from_parent');
        table.foreign('from_parent').references('id').inTable(TABLE_NAMES.parent)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        //💨💨💨💨💨💨 TO section
        table.uuid('to_admin');
        table.foreign('to_admin').references('id').inTable(TABLE_NAMES.admin)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        //
        table.uuid('to_moderator');
        table.foreign('to_moderator').references('id').inTable(TABLE_NAMES.moderator)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        //
        table.uuid('to_teacher');
        table.foreign('to_teacher').references('id').inTable(TABLE_NAMES.teacher)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        //
        table.uuid('to_student');
        table.foreign('to_student').references('id').inTable(TABLE_NAMES.student)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE')
        //
        table.uuid('to_parent');
        table.foreign('to_parent').references('id').inTable(TABLE_NAMES.parent)
        .onUpdate('CASCADE')
        .onDelete('CASCADE') 
        //
        table.uuid('to_room');
        table.foreign('to_room').references('id').inTable(TABLE_NAMES.room)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });

    await knex.schema.createTable(TABLE_NAMES.exam , (table)=>{
        table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
        table.string('exam_name',150).notNullable();
        table.text('exam_bio');
        table.integer('exam_question_degree').notNullable(); // this will calculate the question in the exam degree
        table.integer('month').notNullable();
        table.integer('year').notNullable();
        table.integer('exam_starts_at').notNullable();//the ui will pick time and 
        // js will convert this time into timestamps and will store it in the db
        table.integer('exam_ends_at').notNullable();
        table.integer('exam_duration_in_hrs').notNullable();
        table.uuid('room_id').notNullable();
        table.foreign('room_id').references('id').inTable(TABLE_NAMES.room)
        .onUpdate('CASCADE')
        .onDelete('CASCADE')
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    await knex.schema.createTable(TABLE_NAMES.question , (table)=>{
        table.increments('id').primary();
        table.text('question_text').notNullable();
        table.text('question_answer_one').notNullable();
        table.text('question_answer_two').notNullable();
        table.text('question_answer_three').notNullable();
        table.text('question_answer_final_answer').notNullable();
        table.uuid('exam_id').notNullable();
        table.foreign('exam_id').references('id').inTable(TABLE_NAMES.exam)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE')
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    await knex.schema.createTable(TABLE_NAMES.student_answer , (table)=>{
        table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
        table.text('student_final_answer').notNullable();
        table.uuid('student_id').notNullable();
        table.integer('question_id').notNullable();
        table.foreign('student_id').references('id').inTable(TABLE_NAMES.student)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE')
        table.foreign('question_id').references('id').inTable(TABLE_NAMES.question)
        .onUpdate('CASCADE')
        .onDelete('CASCADE')
        table.uuid('exam_id').notNullable();
        table.foreign('exam_id').references('id').inTable(TABLE_NAMES.exam)
        .onUpdate('CASCADE')
        .onDelete('CASCADE')
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
    await knex.schema.createTable(TABLE_NAMES.student_report , (table)=>{
        table.increments('id').primary();
        table.integer('exam_total_marks').notNullable(); // i will calculate this 
        table.uuid('exam_id').notNullable();
        table.foreign('exam_id').references('id').inTable(TABLE_NAMES.exam)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        table.uuid('student_id').notNullable();
        table.foreign('student_id').references('id').inTable(TABLE_NAMES.student)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE') 
        table.uuid('teacher_id').notNullable();
        table.foreign('teacher_id').references('id').inTable(TABLE_NAMES.teacher)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE')
        table.uuid('room_id').notNullable();
        table.foreign('room_id').references('id').inTable(TABLE_NAMES.room)
        .onUpdate('CASCADE') 
        .onDelete('CASCADE')
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });

}

exports.down = async function down(knex) {
 await Promise.all(
   [
    TABLE_NAMES.student_report,
    TABLE_NAMES.message,
    TABLE_NAMES.parent,
    TABLE_NAMES.student_answer,
    TABLE_NAMES.student,
    TABLE_NAMES.question,
    TABLE_NAMES.exam,
    TABLE_NAMES.room, 
    TABLE_NAMES.teacher_subject,
    TABLE_NAMES.teacher_level,
    TABLE_NAMES.teacher,
    TABLE_NAMES.address,
    TABLE_NAMES.governorates_Municipal_divisions,
    TABLE_NAMES.moderator,   
    TABLE_NAMES.admin,
    TABLE_NAMES.user,
    TABLE_NAMES.account_state,
    TABLE_NAMES.student_level,
    TABLE_NAMES.level, 
    TABLE_NAMES.subject,
    TABLE_NAMES.governorates_of_Egypt
   ]
    .map((table_name)=>knex
    .schema
    .dropTableIfExists(table_name))
 );
}










//REFERENCES 
 /*
  await knex.schema.createTable('user',function(table){
      table.uuid('id').defaultTo(knex.raw('gen_random_uuid()')); //? this will generate a uuid by default in sql db
      table.increments().primary();
      table.string('name').notNullable();
      table.string('email').notNullable().unique();
      table.timestamp('created_at').defaultTo(knex.fn.now());
      table.timestamp('updated_at').defaultTo(knex.fn.now());
      
  });
  await knex.schema.createTable('user_state',(table)=>{
      table.increments().primary(),
      table.integer('user_id').unsigned().notNullable();
      table.foreign('user_id').references('id').inTable('user');
      table.string('state_name').notNullable();
  });
  */

      /*
  await knex.schema.dropTableIfExists('user_state'); // we are dropping the children first then
  await knex.schema.dropTableIfExists('user'); // we drop the parents that's how it's work in dropping
  */