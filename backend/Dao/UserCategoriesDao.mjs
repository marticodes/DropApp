import db from '../db.mjs';
import UserCategories from '../Models/UserCategories_model.mjs';

const UserCategoriesDAO = {
    async insertCategory(userId, newCategoryName) { //V
        return new Promise((resolve, reject) => {
            try {
                const sql = `INSERT INTO UserCategories (user_id, category_name) VALUES (?,?)`;
                db.run(sql, [userId, newCategoryName], (err, result) => {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(true);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },
    async deleteCategory(userId, categoryName) { //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'DELETE FROM UserCategories WHERE user_id = ? AND category_name = ?';
                db.run(sql, [userId, categoryName],  (err, result) => {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(true);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },
    async getAllCategoriesByUserId(userId){ //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM UserCategories WHERE user_id = ?';
                db.all(sql, [userId], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const userCategories = rows.map(row => new UserCategories(row.user_id, row.category_name));
                        resolve(userCategories);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },
    async getSingleCategoryByUserId(userId, CategoryName){  //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT COUNT(*) FROM UserCategories WHERE user_id = ? AND category_name=?';
                db.all(sql, [userId, CategoryName], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        resolve(1);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    }
};

export default UserCategoriesDAO;
