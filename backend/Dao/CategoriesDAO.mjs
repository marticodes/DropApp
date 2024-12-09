import db from '../db.mjs';
import Categories from "../Models/Categories_model.mjs"

const CategoriesDAO = {
    async listCategories() {  //V
      return new Promise((resolve, reject) => {
        try {
          const sql = 'SELECT * FROM Categories';
          return db.all(sql, [], (err, rows) => {
              if (err) {
                reject(err);
              }else if (rows === undefined) {
                resolve([]);
              }else {
                const categories = rows.map(row => new Categories(row.category_name));
                resolve(categories);
              }
          });
        } catch (error) {
          reject(error);
        }
      });
    }
};

export default CategoriesDAO;
