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
    async insertNewMessage(chat_id, content, image, sender_id){   //inserts new message into the db (image is nullable)
        return new Promise((resolve, reject) => {
            try {
                const message_time= new Date().toString();
                const sql = 'INSERT INTO Message (chat_id, message_time, content, image, sender_id) VALUES (?,?,?,?, ?)';
                return db.run(sql, [chat_id, message_time, content, image, sender_id], function(err) {
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
    
    async getMessagesByChatId(chat_id) {
        console.log("Entered messageDao.getMessagesByChatId with chat_id:", chat_id);
    
        return new Promise((resolve, reject) => {
            try {
                const sql = 'SELECT * FROM Message WHERE chat_id = ?';
                console.log(`Executing SQL query: ${sql} with chat_id: ${chat_id}`);
    
                db.all(sql, [chat_id], (err, rows) => {
                    if (err) {
                        console.error("Database error:", err);
                        reject(err);
                    } else if (rows.length === 0) {
                        console.log("No messages found for chat_id:", chat_id);
                        resolve([]);
                    } else {
                        console.log(`Found ${rows.length} messages for chat_id: ${chat_id}`);
                        resolve(rows);
                    }
                });
            } catch (error) {
                console.error("Caught error in messageDao.getMessagesByChatId:", error);
                reject(error);
            }
        });
    }
    
};

export default MessageDAO;
