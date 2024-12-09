import mysql from 'mysql2/promise';
import knex from 'knex';

// Create a Knex instance for MySQL connection
const db = knex({
    client: 'mysql2',
    connection: {
        host: '34.47.81.55',
        user: 'root',
        password: 'dropapp',
        database: 'database',
        port: 3306,
    },
});

// Wrapper to mimic SQLite's API with callback-style handling
const dbWrapper = {
    all: (sql, params = [], callback) => {
        db.raw(sql, params)
            .then(result => callback(null, result[0])) // Knex returns result[0] which is the rows array
            .catch(error => callback(error, null)); // If error occurs, pass it to callback
    },

    run: (sql, params = [], callback) => {
        db.raw(sql, params)
            .then(result => callback(null, result[0])) // Knex returns raw results
            .catch(error => callback(error, null)); // If error occurs, pass it to callback
    },

    get: (sql, params = [], callback) => {
        db.raw(sql, params)
            .then(result => callback(null, result[0] || null)) // Return the first row or null
            .catch(error => callback(error, null)); // Handle errors in the callback
    },
    
    serialize: (queries = [], callback) => {
        // Ensure 'queries' is an array
        if (!Array.isArray(queries)) {
            return callback(new Error("The 'queries' parameter must be an array"), null);
        }
    
        // Wrap the queries in a transaction, ensuring they run sequentially
        db.transaction(trx => {
            const chain = queries.reduce((promiseChain, currentQuery) => {
                // Ensure each query in the array is an object with sql and params properties
                if (typeof currentQuery.sql !== 'string' || !Array.isArray(currentQuery.params)) {
                    throw new Error("Each query should be an object with 'sql' and 'params' properties.");
                }
    
                return promiseChain.then(() => {
                    return trx.raw(currentQuery.sql, currentQuery.params);
                });
            }, Promise.resolve());
    
            chain
                .then(result => {
                    trx.commit(); // Commit transaction after all queries are executed
                    callback(null, result); // Return the result of the queries
                })
                .catch(error => {
                    trx.rollback(); // Rollback transaction in case of error
                    callback(error, null); // Handle errors in the callback
                });
        });
    },
    
};

export default dbWrapper;
