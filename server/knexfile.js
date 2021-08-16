// Update with your config settings.

module.exports = {

  development: {
    client: 'postgresql',
    connection: {
      host: "localhost",
      database: 'teacher_care',
      user:     'postgres',
      password: 'root'
    },
    migrations: {
      directory: "./src/database/project_tables_migration"
    },
    seeds: {
      directory: './src/database/project_tables_seeds'
  },
  },
  //we will change the connection stuff to suit the production later 🎈🎈🎈
  production: {
    client: 'postgresql',
    connection: {
      host: "localhost",
      database: 'teacher_care',
      user:     'postgres',
      password: 'root'
    },
    migrations: {
      directory: "./src/database/project_tables_migration"
    },
    seeds: {
      directory: './src/database/project_tables_seeds'
  },
  }

};
