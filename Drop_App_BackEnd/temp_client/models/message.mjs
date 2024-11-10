class Message {
    constructor(chat_id, message_id, message_time, content, image, sender_id) {
        this.chat_id = chat_id;
        this.message_id = message_id;
        this.message_time = message_time;
        this.content=content;
        this.image=image;
        this.sender_id = sender_id;
    }
}

export default Message;