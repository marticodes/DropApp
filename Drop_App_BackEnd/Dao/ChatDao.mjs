import db from '../db.mjs';
import Chat from '../Models/Chat.js';

const ChatDAO = {
    /*
    product_id: in case of donation
    sprodcuts_id: in case of sharing
    since I have to select the foreign key of the product, I put both as nullable values
    If the chat is related to a donation, put null for the sproduct_id, and viceversa.
    */
    async insertChat(userID1, userID2, product_id, type, sproduct_id) {
        const sql = 'INSERT INTO Chat (user_id_1, user_id_2, product_id, type, sproduct_id) VALUES (?,?,?,?,?)';
        return db.run(sql, [userID1, userID2, product_id, type, sproduct_id]);
    },

    async getUsersIdByChatId(chatId) {    //returns IDs of both users
        const sql = 'SELECT user_id_1, user_id_2 FROM Chat WHERE chat_id = ?';
        return db.all(sql, [chatId]);
    },

    async getProductIdByChatId(chatId){   //returns IDs of both products types
        const sql = 'SELECT product_id, sproduct_id FROM Chat WHERE chat_id = ?';
        return db.all(sql, [chatId]);
    },

    async getChatTypeByChatId(chatId){  //0=donation, 1=sharing
        const sql = 'SELECT type FROM Chat WHERE chat_id = ?';
        return db.get(sql, [chatId]);
    }

    //get chat_id from users and product ?
};

export default ChatDAO;
