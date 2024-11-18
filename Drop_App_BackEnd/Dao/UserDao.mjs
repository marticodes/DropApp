import db from '../db.mjs';
import crypto from "crypto";
import User from "../Models/User_model.mjs"

export default function UserDao() {
    this.setUserAsGraduate = (user_id) => {//V0= not graduated 1=graduated
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

    this.addReview = (user_rating, user_id) => {
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE User SET user_rating = user_rating + ?, num_rev = num_rev + ? WHERE user_id = ?';
                db.run(sql, [user_rating, 1, user_id], function (err) {
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

    this.getRating = (user_id) => {
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT user_rating, num_rev FROM User WHERE user_id = ?';
                db.get(sql, [user_id], (err, row) => {
                    if (err) {
                        reject(err); 
                    } else if (!row) { 
                        resolve(false);
                    } else {
                        resolve(Math.floor(row.user_rating / row.num_rev));
                    }
                });
            } catch (error) {
                reject(error); 
            }
        });
    };

    this.getUserInfo=(user_id) => {
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM User WHERE user_id = ?';
                db.get(sql, [user_id], (err, row) => {
                    if (err) {
                        reject(err);
                    } else if (row.length === 0) {
                        resolve(false);
                    } else {
                        const user = new User(row.user_id, row.user_name, row.user_surname, row.user_cardnum, row.coins_num, row.user_picture, row.user_rating, row.user_location, row.user_graduated, row.hash, row.salt, row.active, row.num_rev);
                        resolve(user);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };

    this.inactiveUser=(user_id) => {
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
      
    this.insertUser = (user_name, user_surname, user_cardnum, user_picture, user_location) => {
        return new Promise((resolve, reject) => {
            const currentYear = new Date().getFullYear().toString();
            let coins_num = 0;
            if (user_cardnum.toString().startsWith(currentYear)) {
                coins_num = 5;
                console.log("a");
            } else {
                coins_num = 3;
                console.log("b");
            }
    
            try {
                const sql = 'INSERT INTO User (user_name, user_surname, user_cardnum, coins_num, user_picture, user_rating, user_location, user_graduated, hash, salt, active, num_rev) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)';
                db.run(sql, [user_name, user_surname, user_cardnum, coins_num, user_picture, 0, user_location, 0, "x", "x", 1, 0], function(err) { // Notice the use of function to get access to `this`
                    if (err) {
                        reject(err);
                    } else if (this.changes === 0) { 
                        resolve(false);
                    } else {
                        const id = this.lastID; 
                        resolve(id);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };
    

    this.isUserActive = (user_id) => {
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT active FROM User WHERE user_id = ?';
                db.get(sql, [user_id], (err, row) => {
                    if (err) {
                        reject(err); 
                    } else if (!row) { 
                        resolve(false);
                    } else {
                        resolve(row.active); 
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

