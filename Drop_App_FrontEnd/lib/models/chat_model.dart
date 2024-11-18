class ChatModel {
  final int chatId;
  final int userId1;
  final int userId2;
  final int productId;
  final int type;
  final int sproductId;

  ChatModel({
    required this.chatId,
    required this.userId1,
    required this.userId2,
    required this.productId,
    required this.type,
    required this.sproductId,
  });

  // Factory constructor to parse JSON into a ChatModel object
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chat_id'],
      userId1: json['user_id_1'],
      userId2: json['user_id_2'],
      productId: json['product_id'],
      type: json['type'],
      sproductId: json['sproduct_id'],
    );
  }

  // Method to convert ChatModel object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'user_id_1': userId1,
      'user_id_2': userId2,
      'product_id': productId,
      'type': type,
      'sproduct_id': sproductId,
    };
  }
}
