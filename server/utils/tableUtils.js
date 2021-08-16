const TABLE_NAMES = require('../src/database/project_tables_names/tableNames');

function addDefaultColumns(table) {
    table.timestamps(false, true);
    table.datetime('deleted_at');
  }

async function addTableFromTwoRowsOnly(knex , tableName , columnName , length){
    await knex.schema.createTable(tableName , (table)=>{
        table.increments('id').primary();
        table.string(columnName , length);
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    })
}

async function teacherManyToManyTables(knex , tableName ,refTable_name, columnName){
    await knex.schema.createTable(tableName , (table)=>{
        table.increments('id').primary(); //  primary key 🔴
        table.uuid('teacher_id').notNullable();
        table.integer(columnName).notNullable();
        table.foreign('teacher_id').references('id').inTable(TABLE_NAMES.teacher);
        table.foreign(columnName).references('id').inTable(refTable_name);
        addDefaultColumns(table);//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
    });
}

  module.exports = {
      addDefaultColumns,
      addTableFromTwoRowsOnly,
      teacherManyToManyTables
  }