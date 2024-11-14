import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String userName;
  final String itemName;
  final String? userAvatarUrl;
  final String? itemImageUrl;
  final String date;
  final String category;

  const ChatItem({
    required this.userName,
    required this.itemName,
    this.userAvatarUrl,
    this.itemImageUrl,
    required this.date,
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all( 10.0),
      child: Row(
        children: [
          // Conditional image display
          category == "Donation"
              ? Stack(
                  clipBehavior: Clip.none, // Allows the circle to overflow the stack
                  children: [
                    // Square item image or fallback with first letter
                    itemImageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              itemImageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _fallbackItemAvatar(itemName);
                              },
                            ),
                          )
                        : _fallbackItemAvatar(itemName),
                    // Circular user avatar positioned to partially overlap the square image
                    Positioned(
                      bottom: -4, 
                      right: -4,
                      child: userAvatarUrl != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(userAvatarUrl!),
                              radius: 12,
                              onBackgroundImageError: (error, stackTrace) {
                                // Use fallback if loading fails
                                return;
                              },
                            )
                          : _fallbackUserAvatar(userName, 12),
                    ),
                  ],
                )
              : userAvatarUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(userAvatarUrl!),
                      radius: 25,
                      onBackgroundImageError: (error, stackTrace) {
                        // Use fallback if loading fails
                        return;
                      },
                    )
                  : _fallbackUserAvatar(userName, 25),
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
  Widget _fallbackUserAvatar(String name, double radius) {
    return CircleAvatar(
      backgroundColor: Colors.blueAccent,
      radius: radius,
      child: Text(
        name[0].toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
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