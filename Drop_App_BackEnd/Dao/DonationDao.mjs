import db from '../db.mjs';
import Donation from "../Models/Donation_model.mjs"
import { readFileSync } from 'fs'; // Import readFileSync from 'fs' module
import pkg from 'natural'; // Import the entire 'natural' module
const { PorterStemmer } = pkg; // Extract PorterStemmer from the module
import { compareTwoStrings } from 'string-similarity'; // Ensure the package is installed

const DonationDAO = {
    async insertDonation(product_name, product_description, product_category, product_picture, donor_id, status) {  //v
        return new Promise((resolve, reject) => {
            try {
                const coin_value = get_coin_value(product_name, status, product_category); 
                const posting_time = new Date().toISOString(); 
                const sql = 'INSERT INTO Donation (product_name, product_category, product_description, product_picture, donor_id, coin_value, active, posting_time, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
                
                db.run(sql, [product_name, product_category, product_description, product_picture, donor_id, 5, 1, posting_time, status], function(err) {
                    if (err) {
                        reject(err);
                    } else if (this.lastID) {
                        const id = this.lastID;
                        resolve(id);
                    } else {
                        resolve(false);
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

    async listMyActiveDonations(user_id) { //v
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Donation WHERE donor_id=? AND active=?';
                db.all(sql, [user_id, 1], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve([]);  
                    } else {
                        const donations = rows.map(row => new Donation(
                            row.product_id, 
                            row.product_name, 
                            row.product_description, 
                            row.product_picture, 
                            row.donor_id, 
                            row.coin_value, 
                            row.product_category, 
                            row.active, 
                            row.posting_time, 
                            row.status
                        ));
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
                        resolve([]);
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

    async filterDonationsByCategories(categories) {
        return new Promise((resolve, reject) => {
            try {
                const placeholders = categories.map(() => '?').join(', ');
                const sql = `SELECT * FROM Donation WHERE product_category IN (${placeholders})`;
                db.all(sql, categories, (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve([]); 
                    } else {
                        const donations = rows.map(row => new Donation(
                            row.product_id, 
                            row.product_name, 
                            row.product_description, 
                            row.product_picture, 
                            row.donor_id, 
                            row.coin_value, 
                            row.product_category, 
                            row.active, 
                            row.posting_time, 
                            row.status
                        ));
                        resolve(donations);  
                    }
                });
            } catch (error) {
                reject(error); 
            }
        });
    },
    
    
    async filterDonationByCoin(min, max) {  
        return new Promise((resolve, reject) => {
            try {
                const sql = `SELECT * FROM Donation WHERE coin_value >= ? AND coin_value <= ?`; 
                db.all(sql, [min, max], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve([]);
                    } else {
                        const donations = rows.map(row => new Donation(
                            row.product_id,
                            row.product_name,
                            row.product_description,
                            row.product_picture,
                            row.donor_id,
                            row.coin_value,
                            row.product_category,
                            row.active,
                            row.posting_time,
                            row.status
                        ));
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

export default DonationDAO;
