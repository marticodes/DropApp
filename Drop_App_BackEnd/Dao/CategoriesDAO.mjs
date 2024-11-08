import db from '../db.mjs';
import Categories from '../Models/Chat.js';

const CategoriesDAO = {
    async listCategories() {
        const sql = 'SELECT * FROM Categories';
        return db.all(sql, []);
    },
};

export default CategoriesDAO;
