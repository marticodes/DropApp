import db from '../db.mjs';
import Share from '../Models/Share_model.mjs';

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
    async insertSharingQuest(sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, status) { //Vv
        return new Promise((resolve, reject) => {
            try {
                const coin_value = get_coin_value(sproduct_name, status);
                const posting_time = new Date().toISOString();
                const sql = 'INSERT INTO Share (sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, coin_value, active, posting_time, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
                
                db.run(sql, [sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, 5, 1, posting_time, status], function(err) {
                    if (err) {
                        reject(err);
                    } else {
                        const id = this.lastID; 
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
    async inactiveSharingQuest(sproduct_id){    //Vv
        return new Promise((resolve, reject) => {
            try {
                const sql = 'UPDATE Share SET active=? WHERE sproduct_id=?';
                db.run(sql, [0, sproduct_id], function (err) {
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
    async listActiveSharingQuest(){ //Vv
        return new Promise((resolve, reject) => {
            try { 
                const sql = 'SELECT * FROM Share WHERE active = ?';
                db.all(sql, [1], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const sharing= rows.map(d => new Share(d.sproduct_id, d.sproduct_name, d.sproduct_category, d.sproduct_description, d.sproduct_start_time, d.sproduct_end_time, d.borrower_id, d.coin_value, d.active, d.posting_time, d.status));
                        resolve(sharing);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },
    async listMyActiveSharingQuests(user_id){   //Vv
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Share WHERE borrower_id=? AND active=?';
                db.all(sql, [user_id,1], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const sharing= rows.map(d => new Share(d.sproduct_id, d.sproduct_name, d.sproduct_category, d.sproduct_description, d.sproduct_start_time, d.sproduct_end_time, d.borrower_id, d.coin_value, d.active, d.posting_time, d.status));
                        resolve(sharing);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },
    async listAllMySharingQuests(user_id){  //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Share WHERE borrower_id=?';
                db.all(sql, [user_id], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const sharing= rows.map(d => new Share(d.sproduct_id, d.sproduct_name, d.sproduct_category, d.sproduct_description, d.sproduct_start_time, d.sproduct_end_time, d.borrower_id, d.coin_value, d.active, d.posting_time, d.status));
                        resolve(sharing);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },
    /*
    Categories should be a list that is updated every time the users clicks a filter
    If the filter is pressed add the name of the category, otherwise remove it and pass again the list as input
    */
    async filterSharingByCategories(categories) {
        return new Promise((resolve, reject) => {
            try {
                // Costruzione dinamica dei segnaposti per ogni categoria
                const placeholders = categories.map(() => '?').join(', ');
    
                // Query SQL con placeholders
                const sql = `SELECT * FROM Share WHERE sproduct_category IN (${placeholders})`;
    
                // Esegui la query, passando l'array 'categories' come parametri
                db.all(sql, categories, (err, rows) => {
                    if (err) {
                        reject(err);  // Se c'è un errore nel database
                    } else if (rows.length === 0) {
                        resolve([]);  // Se non ci sono risultati, restituisci un array vuoto
                    } else {
                        // Se ci sono righe, mappale in oggetti 'Share'
                        const sharing = rows.map(d => new Share(
                            d.sproduct_id, 
                            d.sproduct_name, 
                            d.sproduct_category, 
                            d.sproduct_description, 
                            d.sproduct_start_time, 
                            d.sproduct_end_time, 
                            d.borrower_id, 
                            d.coin_value, 
                            d.active, 
                            d.posting_time, 
                            d.status
                        ));
                        resolve(sharing);  // Risolvi con gli oggetti Share
                    }
                });
            } catch (error) {
                reject(error);  // Gestisci eventuali errori
            }
        });
    },     
    async filterSharingByCoin(min, max){    //V
        return new Promise((resolve, reject) => {
            try {
                const sql = `SELECT * FROM Share WHERE coin_value>=? AND coin_value<=?`;
                return db.all(sql, [min,max], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const sharing= rows.map(d => new Share(d.sproduct_id, d.sproduct_name, d.sproduct_category, d.sproduct_description, d.sproduct_start_time, d.sproduct_end_time, d.borrower_id, d.coin_value, d.active, d.posting_time, d.status));
                        resolve(sharing);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    }

    /*
    async deleteSharingQuest(sproduct_id){ 
        const sql = 'DELETE * FROM Share WHERE sproduct_id'; 
        return db.run(sql, [sproduct_id]);
    },
    async listAllSharingQuest(){
        const sql = 'SELECT * FROM Share';
        return db.all(sql, [1]);
    },
    */
}

async function get_coin_value(product_name, status) {   //TO DO

    // Function to fetch the market value from an external source
    async function fetchMarketValue(product_name) {
        // Replace the URL with the actual API endpoint or database query
        const apiUrl = `https://api.example.com/products?name=${encodeURIComponent(product_name)}`;
        try {
            const response = await fetch(apiUrl);
            if (!response.ok) {
                throw new Error(`Failed to fetch market value: ${response.statusText}`);
            }
            const data = await response.json();
            // Assume the API returns a 'marketValue' field in the response
            return data.marketValue || 0;
        } catch (error) {
            console.error(error);
            return 0; // Return 0 if there's an error
        }
    }

    // Fetch the market value
    const marketValue = await fetchMarketValue(product_name);

    // Map market value to the [0, 10] scale
    const value = Math.min(10, Math.max(0, marketValue / 100)); // Assuming a max value of 100

    // Adjust the value based on the status
    if (status === "New") {
        return value;
    } else if (status === "Good conditions") {
        return (90 / 100) * value;
    } else if (status === "Used") {
        return (70 / 100) * value;
    } else {
        return 0;
    }
}


export default ShareDAO;
