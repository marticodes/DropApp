import db from '../db.mjs';
import Donation from '../Models/Donation.js';

const DonationDAO = {
    async insertDonation(product_name, product_description, product_category, product_picture, donor_id) {
        const coin_value=get_coin_value(sproduct_name);
        const sproduct_start_time= new Date().toISOString();
        const sql = 'INSERT INTO Share (product_name, product_description, product_category, product_picture, donor_id, coin_valu) values (?, ?, ?, ?, ?, ?, ?, 1))';
        return db.run(sql, [product_name, product_category, product_description, product_picture, donor_id, coin_value, 1]);
    },
    async deleteDonation(product_id){ //don't use it unless you want also the related chats to be removed
        const sql = 'DELETE * FROM Donation WHERE product_id'; 
        return db.run(sql, [product_id]);
    },
    async inactiveDonation(product_id){ //this changes just the active flag (1=active, 0=inactive)
        const sql = 'UPDATE Donation SET active=? WHERE product_id=?';
        return db.run(sql, [0, product_id]);
    },
    async listActiveDonations(){
        const sql = 'SELECT * FROM Share WHERE active = ?';
        return db.all(sql, [1]);
    },
    async listAllDonations(){
        const sql = 'SELECT * FROM Share';
        return db.all(sql, [1]);
    },
    async listMyActiveDonations(user_id){
        const sql = 'SELECT * FROM Donation WHERE donor_id=? AND active=?';
        return db.all(sql, [user_id,1]);
    },
    async listAllMyDonations(user_id){
        const sql = 'SELECT * FROM Donation WHERE donor_id=?';
        return db.all(sql, [user_id]);
    },
    /*
    Categories should be a list that is updated every time the users clicks a filter
    If the filter is pressed add the name of the category, otherwise remove it and pass again the list as input
    */
    async filterDonationsByCategories(categories) { 
        const placeholders = categories.map(() => '?').join(', ');
        const sql = `SELECT * FROM Donation WHERE product_category IN (${placeholders})`;
        return db.all(sql, categories);
    }
    
    //we are not allowing edits for the post right?
};

export default DonationDAO;
