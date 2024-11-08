import db from '../db.mjs';
import Share from '../Models/Share.js';

/*
- sproduct_id: id of the (sharing)product (PK)
- sproduct_name: name of the (sharing)product 
- sproduct_category: category of the (sharing)product (FK)
- sproduct_start_time: starting timestamp
- sproduct_end_time: ending timestamp 
- borrower_id: the id of the user that is posting the request (FK)
- coin_value: coin value of the (sharing)product 
- active: 1=active, 0=inactive
*/

const ShareDAO = {
    async insertSharingQuest(sproduct_name, sproduct_category, sproduct_description, sproduct_end_time, borrower_id) {
        const coin_value=get_coin_value(sproduct_name);
        const sproduct_start_time= new Date().toISOString();
        const sql = 'INSERT INTO Share (sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, coin_value, active) values (?, ?, ?, ?, ?, ?, ?, 1))';
        return db.run(sql, [sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, coin_value, 1]);
    },
    async deleteSharingQuest(sproduct_id){ //don't use it unless you want also the related chats to be removed
        const sql = 'DELETE * FROM Share WHERE sproduct_id'; 
        return db.run(sql, [sproduct_id]);
    },
    async inactiveSharingQuest(sproduct_id){ //this changes just the active flag (1=active, 0=inactive)
        const sql = 'UPDATE Donation SET active=? WHERE sproduct_id=?';
        return db.run(sql, [0, sproduct_id]);
    },
    async listActiveSharingQuest(){
        const sql = 'SELECT * FROM Share WHERE active = ?';
        return db.all(sql, [1]);
    },
    async listAllSharingQuest(){
        const sql = 'SELECT * FROM Share';
        return db.all(sql, [1]);
    },
    async listMyActiveSharingQuests(user_id){
        const sql = 'SELECT * FROM Share WHERE borrower_id=? AND active=?';
        return db.all(sql, [user_id,1]);
    },
    async listAllMySharingQuests(user_id){
        const sql = 'SELECT * FROM Share WHERE borrower_id=?';
        return db.all(sql, [user_id]);
    },
    /*
    Categories should be a list that is updated every time the users clicks a filter
    If the filter is pressed add the name of the category, otherwise remove it and pass again the list as input
    */
    async filterDonationsByCategories(categories) { 
        const placeholders = categories.map(() => '?').join(', ');
        const sql = `SELECT * FROM Share WHERE sproduct_category IN (${placeholders})`;
        return db.all(sql, categories);
    }
    //we are not allowing edits for the post right?
}

export default ShareDAO;
