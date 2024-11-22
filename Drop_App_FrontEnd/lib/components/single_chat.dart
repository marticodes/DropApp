import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String userName;
  final String itemName;
  final String userAvatarUrl;
  final String? itemImageUrl; // Assumes this now refers to an asset path
  final String date;
  final String category;

  const ChatItem({
    required this.userName,
    required this.itemName,
    required this.userAvatarUrl,
    this.itemImageUrl,
    required this.date,
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          // Conditional image display
          _fallbackUserAvatar(userAvatarUrl),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(userName, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  // Fallback widget for user avatar with first letter of userName
  Widget _fallbackUserAvatar(String name) {
    return CircleAvatar(

      child: Image.asset(name),);
  }

  // Fallback widget for item image with first letter of itemName
  Widget _fallbackItemAvatar(String itemName) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      alignment: Alignment.center,
      child: Text(
        itemName[0].toUpperCase(),
        style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
