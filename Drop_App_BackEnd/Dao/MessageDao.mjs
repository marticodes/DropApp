import db from '../db.mjs';
import Message from '../Models/Message_model.mjs';

/*
- chat_id: id of the chat (PK - FK) 
- message_id: id of the single message (PK)
- message_time: timestamp of the message (DB accepts only text format, so you will need to treat this a string)
- content: text of the message (non nullable)
- image: if the user wants to send the picture, the value should be its path (nullable)
- sender_id: id of the sender (FK)
*/

const MessageDAO = {
    async insertNewMessage(chatId, message_time, content, image, sender_id){   //inserts new message into the db (image is nullable)
        const sql = 'INSERT INTO Message (chatId, message_time, content, image, sender_id) VALUES (?,?,?,?, ?)';
        return db.run(sql, [chatId, message_time, content, image, sender_id]);
    },
    
    async getMessagesByChatId(chatId){  //gets all messages from the chat
        const sql = 'SELECT content FROM Message WHERE chat_id = ?)';
        return db.run(sql, [chatId, message_time, content, image]);
    }
};

export default MessageDAO;
