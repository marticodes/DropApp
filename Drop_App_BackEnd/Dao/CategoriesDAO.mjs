import db from '../db.mjs';

const CategoriesDAO = {
    async listCategories() {
        const sql = 'SELECT * FROM Categories';
        return db.all(sql, []);
    },
};

export default CategoriesDAO;
