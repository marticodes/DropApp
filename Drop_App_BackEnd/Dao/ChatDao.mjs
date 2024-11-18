import db from '../db.mjs';
import Chat from '../Models/Chat_model.mjs';

const ChatDAO = {
    /*
    product_id: in case of donation
    sprodcuts_id: in case of sharing
    since I have to select the foreign key of the product, I put both as nullable values
    If the chat is related to a donation, put null for the sproduct_id, and viceversa.
    */
    async insertChat(user_id_1, user_id_2, product_id, type, sproduct_id) {
        return new Promise((resolve, reject) => {
            try {
                const sql = 'INSERT INTO Chat (user_id_1, user_id_2, product_id, type, sproduct_id) VALUES (?,?,?,?,?)';
                db.run(sql, [user_id_1, user_id_2, product_id, type, sproduct_id], function(err) {
                    if (err) {
                        reject(err);
                    } else if (this.changes > 0) {
                        const id = this.lastID;  // Use this.lastID to get the inserted chat_id
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
    

    async getUsersIdByChatId(chatId) { //v   //returns IDs of both users
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT user_id_1, user_id_2 FROM Chat WHERE chat_id = ?';
                return db.get(sql, [chatId], (err, row) => {
                    if (err) {
                        reject(err);
                    } else if (row.length === 0) {
                        resolve(false);
                    } else {
                        const ids = [row.user_id_1, row.user_id_2];
                        resolve(ids);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },

    async getProductIdByChatId(chatId){  //v //returns IDs of both products types
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT product_id, sproduct_id FROM Chat WHERE chat_id = ?';
                return db.get(sql, [chatId], (err, row) => {
                    if (err) {
                        reject(err);
                    } else if (row.length === 0) {
                        resolve(false);
                    } else {
                        const ids = [row.product_id, row.sproduct_id];
                        resolve(ids);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },

    async getChatTypeByChatId(chatId){ //V //0=donation, 1=sharing
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT type FROM Chat WHERE chat_id = ?';
                return db.get(sql, [chatId], (err, row) => {
                    if (err) {
                        reject(err);
                    } else if (row.length === 0) {
                        resolve(false);
                    } else {
                        const type = row.type;
                        resolve(type); 
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },

    async getAllChatsByUser(user_id_1, user_id_2){ //v
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Chat WHERE user_id_1 = ? OR user_id_2=?';
                return db.all(sql, [user_id_1, user_id_2], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve(false);
                    } else {
                        const chats = rows.map(row => new Chat(row.chat_id, row.user_id_1, row.user_id_2, row.product_id, row.type, row.sproduct_id));
                        resolve(chats);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },
    
    async getChatIdByUserAndProduct(user_id_1, user_id_2, product_id, sproduct_id){ //v //put 0 in the incorrect product id
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Chat WHERE (user_id_1 = ? AND user_id_2 = ?) AND (product_id = ? OR sproduct_id = ?)'
                return db.get(sql, [user_id_1, user_id_2, product_id, sproduct_id], (err, row) => {
                    if (err) {
                        reject(err);
                    } else if (row.length === 0) {
                        resolve(false);
                    } else {
                        const id = row.chat_id;
                        resolve(id); 
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    }
};

export default ChatDAO;
