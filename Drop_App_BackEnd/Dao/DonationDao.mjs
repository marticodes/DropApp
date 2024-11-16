import db from '../db.mjs';
import Donation from "../Models/Donation_model.mjs"
const DonationDAO = {
    async insertDonation(product_name, product_description, product_category, product_picture, donor_id, status) {  //V
        return new Promise((resolve, reject) => {
            try {
                const coin_value=get_coin_value(product_name, status);
                const posting_time= new Date().toISOString();
                const sql = 'INSERT INTO Donation (product_name, product_category, product_description, product_picture, donor_id, coin_value, active, posting_time, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
                db.run(sql, [product_name, product_category, product_description, product_picture, donor_id, 5, 1, posting_time, status], (err, row) => {   //TO DO: change coin value
                    if (err) {
                        reject(err);
                    } else if (row.length === 0) {
                        resolve(false);
                    } else {
                        const id = row.product_id;
                        resolve(id);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },
    /*
    this changes just the active flag (1=active, 0=inactive)
    an inactive product is similar to deleted but without consequences
    */
    async inactiveDonation(product_id){ //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE Donation SET active=? WHERE product_id=?';
                return db.run(sql, [0, product_id], function (err) {
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
    },
    async listActiveDonations(){   //V
        return new Promise((resolve, reject) => {
            try {         
                const sql = 'SELECT * FROM Donation WHERE active = ?';
                db.all(sql, [1], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const donations= rows.map(row => new Donation(row.product_id, row.product_name, row.product_description, row.product_picture, row.donor_id, row.coin_value, row.product_category, row.active, row.posting_time, row.status));
                        resolve(donations);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },

    async listMyActiveDonations(user_id){   //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Donation WHERE donor_id=? AND active=?';
                return db.all(sql, [user_id,1], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const donations= rows.map(row => new Donation(row.product_id, row.product_name, row.product_description, row.product_picture, row.donor_id, row.coin_value, row.product_category, row.active, row.posting_time, row.status));
                        resolve(donations);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },

    async listAllMyDonations(user_id){     //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Donation WHERE donor_id=?';
                return db.all(sql, [user_id], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const donations= rows.map(row => new Donation(row.product_id, row.product_name, row.product_description, row.product_picture, row.donor_id, row.coin_value, row.product_category, row.active, row.posting_time, row.status));
                        resolve(donations);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },

    async filterDonationsByCategories(categories) {  //V   //TO DO:check
        return new Promise((resolve, reject) => {
            try {
                const placeholders = categories.map(() => '?').join(', ');
                const sql = `SELECT * FROM Donation WHERE product_category IN (${placeholders})`;
                db.all(sql, [categories], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const donations= rows.map(row => new Donation(row.product_id, row.product_name, row.product_description, row.product_picture, row.donor_id, row.coin_value, row.product_category, row.active, row.posting_time, row.status));
                        resolve(donations);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },
    
    async filterDonationByCoin(min, max){   //V
        return new Promise((resolve, reject) => {
            try {
                const sql = `SELECT * FROM Donation WHERE coin_value>=? AND coin_value<=?`; 
                return db.all(sql, [min,max], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const donations= rows.map(row => new Donation(row.product_id, row.product_name, row.product_description, row.product_picture, row.donor_id, row.coin_value, row.product_category, row.active, row.posting_time, row.status));
                        resolve(donations);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    }

    /*
    async listAllDonations(){
        const sql = 'SELECT * FROM Donation';
        return db.all(sql, [1]);
    },
    async deleteDonation(product_id){
        const sql = 'DELETE * FROM Donation WHERE product_id'; 
        return db.run(sql, [product_id]);
    },
    */
};

function get_coin_value(product_name, status) { //TO DO
}

export default DonationDAO;
