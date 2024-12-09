import db from '../db.mjs';
import Chat from '../Models/Chat_model.mjs';

const ChatDAO = {
    async insertChat(user_id_1, user_id_2, product_id, type, sproduct_id) { //V
        return new Promise((resolve, reject) => {
            try {
                const sql = `INSERT INTO Chat (user_id_1, user_id_2, product_id, type, sproduct_id) VALUES (?,?,?,?,?)`;
                db.run(sql, [user_id_1, user_id_2, product_id, type, sproduct_id], (err, result) => {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(result.insertId || null);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },

    async getUsersIdByChatId(chatId) {  //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Chat WHERE chat_id = ?';
                return db.all(sql, [chatId], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve([]);
                    } else {
                        const chats = rows.map(a => new Chat(a.chat_id, a.user_id_1, a.user_id_2, a.product_id, a.type, a.sproduct_id));
                        const ids = [chats[0].user_id_1, chats[0].user_id_2];
                        resolve(ids);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },

    async getProductIdByChatId(chatId){ //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Chat WHERE chat_id = ?';
                return db.all(sql, [chatId], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve([]);
                    } else {
                        const chats = rows.map(a => new Chat(a.chat_id, a.user_id_1, a.user_id_2, a.product_id, a.type, a.sproduct_id));
                        const ids = [chats[0].product_id, chats[0].sproduct_id];
                        resolve(ids);
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },

    async getChatTypeByChatId(chatId){  //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Chat WHERE chat_id = ?';
                return db.all(sql, [chatId], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve([]);
                    } else {
                        const chats = rows.map(a => new Chat(a.chat_id, a.user_id_1, a.user_id_2, a.product_id, a.type, a.sproduct_id));
                        const type = chats[0].type;
                        resolve(type); 
                    }
                });
            } catch (error) {
                reject(error);
            }
        });
    },

    async getAllChatsByUser(user_id_1){ //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Chat WHERE (user_id_1 = ? OR user_id_2=?)';
                return db.all(sql, [user_id_1, user_id_1], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve([]);
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
    
    async getChatIdByUserAndProduct(user_id_1, user_id_2, product_id, sproduct_id){ //V
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Chat WHERE (user_id_1 = ? AND user_id_2 = ?) AND (product_id = ? OR sproduct_id = ?)'
                return db.all(sql, [user_id_1, user_id_2, product_id, sproduct_id], (err, rows) => {
                    if (err) {
                        reject(err);
                    } else if (rows.length === 0) {
                        resolve([]);
                    } else {
                        const chats = rows.map(a => new Chat(a.chat_id, a.user_id_1, a.user_id_2, a.product_id, a.type, a.sproduct_id));
                        const id = chats[0].chat_id;
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