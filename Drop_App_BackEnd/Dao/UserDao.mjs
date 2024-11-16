import db from '../db.mjs';
import crypto from "crypto";
import User from "../Models/User_model.mjs"

export default function UserDao() {
    //TO DO: add add_rating
    this.setUserAsGraduate = (user_id) => { //V //V0= not graduated 1=graduated
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE User SET user_graduated=? WHERE user_id=?';
                db.run(sql, [1, user_id], function (err) {
                    if (err) {
                      reject(err);
                    }else {
                      resolve(this.changes > 0); //at least one line changed
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };

    this.getUserInfo=(user_id) => { //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM User WHERE user_id = ?';
                db.get(sql, [user_id], (err, row) => {
                    if (err) {
                        reject(err);
                    } else if (row.length === 0) {
                        resolve(false);
                    } else {
                        const user = new User(user_id, user_name, user_surname, user_cardnum, coins_num, user_picture, user_rating, user_location, user_graduated, active);
                        resolve(user);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };

    this.inactiveUser=(user_id) => {    //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE User SET active=? WHERE user_id=?';
                db.run(sql, [0, user_id], function (err) {
                    if (err) {
                    reject(err);
                    }else {
                    resolve(this.changes > 0); //at least one line changed
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };
      
    this.insertUser=(user_name, user_surname, user_cardnum, user_picture, user_location)=>{ //V
        return new Promise((resolve, reject) => {
            coins_num= user_coins(user_cardnum);
            try {
                const sql = 'INSERT INTO User (user_name, user_surname, user_cardnum, coins_num, user_picture, user_rating, user_location, user_graduated, hash, salt, active) VALUES (?,?,?,?,?,?,?,?,?,?,?)';
                db.run(sql, [user_name, user_surname, user_cardnum, coins_num, user_picture, 0, user_location, 0, x, x, 1], (err, row) => {
                    if (err) {
                        reject(err);
                    } else if (row.length === 0) {
                        resolve(false);
                    } else {
                        const id = row.user_id;
                        resolve(id);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };

    this.isUserActive=(user_id) => {    //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT active FROM User WHERE user_id=?';
                return db.run(sql, [user_id], (err, row) => {
                    if (err) {
                        reject(err);
                    } else if (row.length === 0) {
                        resolve(false);
                    } else {
                        const active = row;
                        resolve(active);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
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

    /*
    this.deleteUser=() => { //this will cascade to all the chats that have the user
        const sql = 'DELETE * FROM User WHERE user_id = ?';
        return db.run(sql, [user_id]);
    };
    */
}

function user_coins(user_cardnum) {
    const currentYear = new Date().getFullYear().toString();
    if(user_cardnum.toString().startsWith(currentYear)){
        return 5;
    }else{
        return 3;
    }
}