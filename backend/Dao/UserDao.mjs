import db from '../db.mjs';
import crypto from "crypto";
import User from "../Models/User_model.mjs"

export default function UserDao() {
    this.setUserAsGraduate = (user_id) => { //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE User SET user_graduated=? WHERE user_id=?';
                db.run(sql, [1, user_id], (err, result) => {
                    if (err) {
                        reject(err);
                    }else {
                        resolve(true);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };


    this.addReview = (user_rating, user_id) => { //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE User SET user_rating = user_rating + ?, num_rev = num_rev + ? WHERE user_id = ?';
                db.run(sql, [user_rating, 1, user_id], (err, result) => {
                    if (err) {
                      reject(err);
                    }else {
                        resolve(true);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };

    this.addMoneyFromUser = (user_id, coin_amount) => { //e
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE User SET coins_num = coins_num - ?, WHERE user_id = ?';
                db.run(sql, [coin_amount, user_id], (err, result) => {
                    if (err) {
                        reject(err);
                    }else {
                        resolve(true);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };

    this.removeMoneyFromUser = (user_id, coin_amount) => { //e
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE User SET coins_num = coins_num - ? WHERE user_id = ?';
                db.run(sql, [coin_amount, user_id], (err, result) => {
                    if (err) {
                        reject(err);
                    }else {
                        resolve(true);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };

    this.getRating = (user_id) => { //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM User WHERE user_id = ?';
                db.all(sql, [user_id], (err, rows) => {
                    if (err) {
                        reject(err); 
                    } else if (rows.length === 0) { 
                        resolve([]);
                    } else {
                        const user = rows.map(a => new User(a.user_id, a.user_name, a.user_surname, a.user_cardnum, a.coins_num, a.user_picture, a.user_rating, a.user_location, a.user_graduated, a.hash, a.salt, a.active, a.num_rev));
                        resolve(Math.floor(user[0].user_rating / user[0].num_rev));
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
                db.all(sql, [user_id], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve([]);
                    } else {
                        const users = rows.map(a => new User(a.user_id, a.user_name, a.user_surname, a.user_cardnum, a.coins_num, a.user_picture, a.user_rating, a.user_location, a.user_graduated, a.hash, a.salt, a.active, a.num_rev));
                        resolve(users[0]);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };

    this.inactiveUser=(user_id) => { //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE User SET active=? WHERE user_id=?';
                db.run(sql, [0, user_id], (err, result) => {
                    if (err) {
                        reject(err);
                    }else {
                        resolve(true);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };
      
    this.insertUser = (user_name, user_surname, user_cardnum, user_location, hash) => { //V
        return new Promise((resolve, reject) => {
            const currentYear = new Date().getFullYear().toString();
            let coins_num = 0;
            if (user_cardnum.toString().startsWith(currentYear)) {
                coins_num = 5;
            } else {
                coins_num = 3;
            }
    
            try {
                const sql = 'INSERT INTO User (user_name, user_surname, user_cardnum, coins_num, user_rating, user_location, user_graduated, hash, salt, active, num_rev) VALUES (?,?,?,?,?,?,?,?,?,?,?)';
                db.run(sql, [user_name, user_surname, user_cardnum, coins_num, 0, user_location, 0, hash, null, 1, 0], (err, result) => {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(result.insertId || null);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };
    
    this.addUserPicture = (user_picture, user_id) => { //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE User SET user_picture=? WHERE user_id=?';
                db.run(sql, [user_picture, user_id], (err, result) => {
                    if (err) {
                      reject(err);
                    }else {
                      resolve(true); //at least one line changed
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };

    this.removeUserPicture = (user_id) => { //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE User SET user_picture=? WHERE user_id=?';
                db.run(sql, [null, user_id], (err, result) => {
                    if (err) {
                      reject(err);
                    }else {
                      resolve(true); //at least one line changed
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    };

    this.isUserActive = (user_id) => { //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT active FROM User WHERE user_id = ?';
                db.all(sql, [user_id], (err, rows) => {
                    if (err) {
                        reject(err); 
                    } else if (rows.length === 0) {
                        resolve([]);
                    } else {
                        const users = rows.map(a => new User(a.user_id, a.user_name, a.user_surname, a.user_cardnum, a.coins_num, a.user_picture, a.user_rating, a.user_location, a.user_graduated, a.hash, a.salt, a.active, a.num_rev));
                        resolve(users[0].active);
                    }
                });
            } catch (error) {
                reject(error); 
            }
        });
    };
    
    this.checkCredentials = (user_cardnum, hash) => { //V
        return new Promise((resolve, reject) => {
            const query = 'SELECT * FROM User WHERE user_cardnum=? AND hash=?';
            try {
                db.all(query, [user_cardnum, hash], (err, rows) => {
                    if (err) {
                        reject(err);
                    }if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const users = rows.map(a => new User(a.user_id, a.user_name, a.user_surname, a.user_cardnum, a.coins_num, a.user_picture, a.user_rating, a.user_location, a.user_graduated, a.hash, a.salt, a.active, a.num_rev));
                        resolve(users[0].user_id);
                    }
                });
            } catch (err) { reject({ error: err.message }) }

        });
    }

    //this 2 following functions are from my old project - I will leave them since they are required for the login ---------------------------------------------
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
    };

    //---------------------------------------------------------------------------------------------------------------------------------------------------------------
    this.donation_money_update = (product_id, coin_value, user_id) => {
        // Start a transaction manually
        return new Promise((resolve, reject) => {
            db.serialize(() => {
                db.run('BEGIN TRANSACTION', (err) => {
                    if (err) {
                        reject('Error starting transaction');
                        return;
                    }

                    // Step 1: Fetch user info
                    this.getUserInfo(user_id).then(currentUser => {
                        if (!currentUser) {
                            throw new Error('User not found');
                        }
                        if (currentUser.coins_num < coin_value) {
                            throw new Error('Not enough coins');
                        }

                        // Step 2: Fetch donor_id
                        const query = 'SELECT donor_id FROM Donation WHERE product_id = ?';
                        db.all(query, [product_id], (err, rows) => {
                            if (err || rows.length===0) {
                                reject(err || 'Donation not found');
                                return;
                            }
                            const donor_id = rows[0].donor_id;

                            // Step 3: Update coins for both users
                            const updateUserQuery = 'UPDATE User SET coins_num = coins_num - ? WHERE user_id = ?';
                            db.run(updateUserQuery, [coin_value, user_id], (err) => {
                                if (err) {
                                    reject('Error updating user coins');
                                    return;
                                }
                                db.run('UPDATE User SET coins_num = coins_num + ? WHERE user_id = ?', [coin_value, donor_id], (err) => {
                                    if (err) {
                                        reject('Error updating donor coins');
                                        return;
                                    }
                                    // Step 4: Mark donation as inactive
                                    db.run('UPDATE Donation SET active = 0 WHERE product_id = ?', [product_id], (err) => {
                                        if (err) {
                                            reject('Error deactivating donation');
                                            return;
                                        }
                                        // Commit the transaction
                                        db.run('COMMIT', (err) => {
                                            if (err) {
                                                reject('Error committing transaction');
                                            } else {
                                                resolve('Donation processed successfully');
                                            }
                                        });
                                    });
                                });
                            });
                        });
                    }).catch(reject);
                });
            });
        });
    }

    //--------------------------------------------------------------------------------------------------------------------
    this.sharing_money_update = (sproduct_id, coin_value, user_id) => {
        // Start a transaction manually
        return new Promise((resolve, reject) => {
            db.serialize(() => {
                db.run('BEGIN TRANSACTION', (err) => {
                    if (err) {
                        reject('Error starting transaction');
                        return;
                    }
    
                    // Update the user's coins
                    db.run('UPDATE User SET coins_num = coins_num + ? WHERE user_id = ?', [coin_value, user_id], (err) => {
                        if (err) {
                            reject('Error updating donor coins');
                            return;
                        }
    
                        // Mark sharing as inactive
                        db.run('UPDATE Share SET active = 0 WHERE sproduct_id = ?', [sproduct_id], (err) => {
                            if (err) {
                                reject('Error deactivating donation');
                                return;
                            }
    
                            // Commit the transaction
                            db.run('COMMIT', (err) => {
                                if (err) {
                                    reject('Error committing transaction');
                                } else {
                                    resolve('Donation processed successfully');
                                }
                            });
                        });
                    });
                });
            });
        });
    };
    
    //--------------------------------------------------------------------------------------------
    /*
    this.deleteUser=() => { //this will cascade to all the chats that have the user
        const sql = 'DELETE * FROM User WHERE user_id = ?';
        return db.run(sql, [user_id]);
    };
    */
}
