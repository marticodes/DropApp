import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String userName;
  final String itemName;
  final String date;
  final String avatarUrl; // Placeholder for avatar image URL or path

  const ChatItem({
    required this.userName,
    required this.itemName,
    required this.date,
    required this.avatarUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatarUrl), // Load avatar from URL
        backgroundColor: Colors.blue, // Fallback color if image fails to load
      ),
      title: Text(
        itemName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(userName, style: TextStyle(color: Colors.grey[600])),
      trailing: Text(
        date,
        style: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
}
