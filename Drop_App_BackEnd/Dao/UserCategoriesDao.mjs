import db from '../db.mjs';
import UserCategories from '../models/Categories.js';

const UserCategoriesDAO = {
    
    async insertCategory(userId, newCategoryName) { //inserts new category for the specific user
        const sql = 'INSERT INTO UserCategories (user_id, category_name) VALUES (?,?)';
        return db.run(sql, [userId, newCategoryName]);
    },
    async deleteCategory(userId, CategoryName) { //removes specific category for specific user
        const sql = 'DELETE FROM UserCategories WHERE user_id = ? and category_name = ?';
        return db.run(sql, [userId, CategoryName]);
    },
    async getAllCategoriesByUserId(userId){ //returns all the categories for the specific user
        const sql = 'SELECT category_name FROM UserCategories WHERE user_id = ?';
        return db.all(sql, [userId]);
    },
    async getSingleCategoryByUserId(userId, CategoryName){ //returns if the user has that specific category or not
        const sql = 'SELECT COUNT(*) FROM UserCategories WHERE user_id = ? AND category_name=?';
        return db.get(sql, [userId, CategoryName]);
    }
};

export default UserCategoriesDAO;
