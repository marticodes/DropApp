import db from '../db.mjs';
import Share from '../Models/Share_model.mjs';
import fetch from 'node-fetch';

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

//const fetch = require('node-fetch');

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

// Function to fetch product prices from an external API
async function fetchProductPricesFromAPI() {
    const apiUrl = `https://price-comparison8.p.rapidapi.com/api/compare`;
    const apiKey = 'YOUR_RAPIDAPI_KEY'; // Replace with your actual API key

    try {
        const response = await fetch(apiUrl, {
            method: 'GET',
            headers: {
                'X-RapidAPI-Key': apiKey,
                'X-RapidAPI-Host': 'price-comparison8.p.rapidapi.com'
            }
        });

        if (!response.ok) {
            throw new Error('Failed to fetch data from the API');
        }

        const data = await response.json();
        return data.products; // Assume the API returns a 'products' field with product info
    } catch (error) {
        console.error('Error fetching data from the API:', error);
        return []; // Return an empty array if something goes wrong
    }
}

// Function to scale product price between 0 and 10
function scalePrice(price, maxPrice) {
    const scaledValue = (price / maxPrice) * 10;
    return Math.min(10, Math.max(0, scaledValue)); // Ensure the scaled value is between 0 and 10
}

// Main function to get the coin value based on product name and status
async function get_coin_value(product_name, status) {
    // Fetch the product prices from the external API
    const products = await fetchProductPricesFromAPI();

    // Find the product by name (case insensitive)
    const product = products.find(p => p.name.toLowerCase() === product_name.toLowerCase());

    if (!product) {
        console.log(`Product "${product_name}" not found.`);
        return 0; // If the product is not found, return 0
    }

    // Find the maximum price in the list to scale other prices accordingly
    const maxPrice = Math.max(...products.map(p => p.price));

    // Scale the product's price between 0 and 10 based on the maximum price
    const scaledPrice = scalePrice(product.price, maxPrice);

    // Apply status-based scaling logic
    if (status === "New") {
        return scaledPrice;
    } else if (status === "Good conditions") {
        return scaledPrice * 0.9; // 10% off for "Good conditions"
    } else if (status === "Used") {
        return scaledPrice * 0.7; // 30% off for "Used"
    }

    return 0; // If no status matches, return 0
}


export default ShareDAO;
