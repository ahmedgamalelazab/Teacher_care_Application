//database connection stuff 
const Knex = require('knex');

const { Model } = require('objection');

const environment = process.env.NODE_ENV || 'development';

const knexConfig = require('../../knexfile');

const connectionConfig = knexConfig[environment];

const connection = Knex.knex(connectionConfig);

// console.log(environment);
// console.log(connectionConfig);

Model.knex(connection);

module.exports = Model;


/**
 * firstly you have to stablish a connection with knex object 
 *  secondly you have to store this connection in a connection variable 
 * finally you have to stablish a connection with Model from objection js by passing this connection settings into it knex object 
 */

