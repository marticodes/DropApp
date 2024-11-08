import db from '../db.mjs';
import User from '../models/User.js';
import crypto from "crypto";

export default function UserDao() {
    //are we allowing to change info?
    this.setUserAsGraduate = (user_id) => { //0= not graduated 1=graduated
        const sql = 'UPDATE User SET user_graduated=? WHERE user_id=?';
        return db.run(sql, [1, product_id]);
    };

    this.getUserInfo=() => {
        const sql = 'SELECT * FROM User WHERE user_id = ?';
        return db.get(sql, [user_id]);
    };

    this.deleteUser=() => { //this will cascade to all the chats that have the user
        const sql = 'DELETE * FROM User WHERE user_id = ?';
        return db.run(sql, [user_id]);
    };
    
    
    //this 2 following functions are from my old project - I will leave them since they are required for the login
    this.getUserById = (id) => {
        return new Promise((resolve, reject) => {
            const query = 'SELECT * FROM users WHERE id=?';

            try {
                db.get(query, [id], (err, row) => {
                    if (err) {
                        reject(err);
                    }
                    if (row === undefined) {
                        resolve({ error: 'User not found.' });
                    } else {
                        resolve(row);
                    }
                });
            } catch (err) { reject({ error: err.message }) }

        });
    };

    this.getUser = (email, password) => {
        return new Promise((resolve, reject) => {
            const sql = 'SELECT * FROM users WHERE email=?';
            db.get(sql, [email], (err, row) => {
                if (err) {
                    reject(err);
                } else if (row === undefined) {
                    resolve(false);
                }
                else {
                    const user = { id: row.id, username: row.email, name: row.name };

                    // Check the hashes with an async call
                    crypto.scrypt(password, row.salt, 32, function (err, hashedPassword) {
                        if (err) reject(err);
                        if (!crypto.timingSafeEqual(Buffer.from(row.hash, 'hex'), hashedPassword))
                            resolve(false);
                        else
                            resolve(user);
                    });
                }
            });
        });
    }

}
