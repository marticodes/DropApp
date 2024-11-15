import db from '../db.mjs';

const DonationDAO = {
    async insertDonation(product_name, product_description, product_category, product_picture, donor_id, status) {
        const coin_value=get_coin_value(sproduct_name); //TO DO
        const posting_time= new Date().toISOString();
        const sql = 'INSERT INTO Donation (product_name, product_category, product_description, product_picture, donor_id, coin_value, active, posting_time, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
        return db.run(sql, [product_name, product_category, product_description, product_picture, donor_id, coin_value, 1, posting_time, status]);
    },
    /*
    this changes just the active flag (1=active, 0=inactive)
    an inactive product is similar to deleted but without consequences
    */
    async inactiveDonation(product_id){
        const sql = 'UPDATE Donation SET active=? WHERE product_id=?';
        return db.run(sql, [0, product_id]);
    },
    async listActiveDonations(){           
        const sql = 'SELECT * FROM Donation WHERE active = ?';
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
    async filterDonationsByCategories(categories) {     //TO DO:check
        const placeholders = categories.map(() => '?').join(', ');
        const sql = `SELECT * FROM Donation WHERE product_category IN (${placeholders})`;
        return db.all(sql, [categories]);
    },
    
    async filterDonationByCoin(min, max){
        const sql = `SELECT * FROM Donation WHERE coin_value>=? AND coin_value<=?`; 
        return db.all(sql, [min,max]);
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

export default DonationDAO;
