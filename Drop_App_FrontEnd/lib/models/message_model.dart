class MessageModel {
  final int messageId;
  final int chatId;
  final String messageTime;
  final String content;
  final String? image; // Image is nullable
  final int senderId;

  MessageModel({
    required this.messageId,
    required this.chatId,
    required this.messageTime,
    required this.content,
    this.image,
    required this.senderId,
  });

  // Factory constructor to parse JSON into a MessageModel object
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['message_id'],
      chatId: json['chat_id'],
      messageTime: json['message_time'],
      content: json['content'],
      image: json['image'], // It might be null
      senderId: json['sender_id'],
    );
  }

  // Method to convert MessageModel object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'chat_id': chatId,
      'message_time': messageTime,
      'content': content,
      'image': image,
      'sender_id': senderId,
    };
  }
}
