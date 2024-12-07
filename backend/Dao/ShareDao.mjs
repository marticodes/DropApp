import db from '../db.mjs';
import Share from '../Models/Share_model.mjs';
import fetch from 'node-fetch';
import { readFileSync } from 'fs'; // Import readFileSync from 'fs' module
import pkg from 'natural'; // Import the entire 'natural' module
const { PorterStemmer } = pkg; // Extract PorterStemmer from the module
import { compareTwoStrings } from 'string-similarity'; // Ensure the package is installed

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
                const coin_value = get_coin_value(sproduct_name, status, sproduct_category); 
                const posting_time = new Date().toISOString();
                const sql = 'INSERT INTO Share (sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, coin_value, active, posting_time, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
                
                db.run(sql, [sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, coin_value, 1, posting_time, status], function(err) {
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
    },

    /*
    async deleteSharingQuest(sproduct_id){ 
        const sql = 'DELETE * FROM Share WHERE sproduct_id'; 
        return db.run(sql, [sproduct_id]);
    },
    */

    async listAllSharingQuest(){
        const sql = 'SELECT * FROM Share';
        return db.all(sql, [1]);
    },
}

function get_coin_value(productName, productStatus, category) {
    const dbPath = './products.json'; // Update with the correct path to your file
    const rawData = readFileSync(dbPath, 'utf-8'); // Read file synchronously
    let products;
  
    try {
      products = JSON.parse(rawData).products; // Access the products object directly
    } catch (error) {
      console.error('Error parsing JSON:', error);
      return;
    }
  
    // Normalize and stem the input product name (remove spaces, convert to lowercase)
    const normalizedProductName = productName.trim().toLowerCase();
    const stemmedProductName = PorterStemmer.stem(normalizedProductName);
  
    let mostSimilarProduct = null;
    let highestSimilarity = 0;
  
    // Function to check similarity using stemming within the category
    function checkCategory(categoryProducts) {
      categoryProducts.forEach(product => {
        // Normalize and stem the product name from the database
        const normalizedProduct = product.name.trim().toLowerCase();
        const stemmedProduct = PorterStemmer.stem(normalizedProduct);
  
        // Compare the stemmed product name with the input's stemmed name
        const similarity = compareTwoStrings(stemmedProductName, stemmedProduct);
  
        // If similarity exceeds a threshold and is more relevant than the previous one
        if (similarity > highestSimilarity && similarity > 0.5) {
          highestSimilarity = similarity;
          mostSimilarProduct = product;
        }
      });
    }
  
    // 1. Check similarity within the given category
    if (products[category]) {
      const categoryProducts = products[category];
      if (Array.isArray(categoryProducts)) {
        checkCategory(categoryProducts);
      }
    }
  
    // 2. If no match is found within the given category, look in all other categories
    if (!mostSimilarProduct) {
      for (const cat in products) {
        if (cat !== category && Array.isArray(products[cat])) {
          checkCategory(products[cat]);
        }
      }
    }
  
    // 3. If no match is found, return default value 4
    if (!mostSimilarProduct || highestSimilarity < 0.5) {
      return 4;
    }
  
    const price = mostSimilarProduct.price;
  
    // Calculate value based on status
    let valuePercentage;
    switch (productStatus.toLowerCase()) {
      case 'new':
        valuePercentage = 1.0;
        break;
      case 'good conditions':
        valuePercentage = 0.85;
        break;
      case 'used':
        valuePercentage = 0.7;
        break;
      default:
        console.error(`Invalid product status: "${productStatus}". Valid statuses are "new", "good conditions", "used".`);
        return;
    }
  
    // Calculate adjusted value
    const adjustedValue = price * valuePercentage;
  
    // Remap the value to a range [1, 10]
    const minPrice = 5000;
    const maxPrice = 150000;
    const remappedValue = Math.max(1, Math.min(10, ((adjustedValue - minPrice) / (maxPrice - minPrice)) * 9 + 1));
  
    // Round the rescaled value to an integer
    const roundedValue = Math.round(remappedValue);
    return roundedValue;

    /*
    // Output the required information
    console.log(`Matched Product: ${mostSimilarProduct.name}`);
    console.log(`Price in Won: ${price.toLocaleString()} ₩`);
    console.log(`Adjusted Price (Based on Status: ${productStatus}): ${adjustedValue.toLocaleString()} ₩`);
    console.log(`Rescaled Value: ${roundedValue}`);
    */
}


export default ShareDAO;
