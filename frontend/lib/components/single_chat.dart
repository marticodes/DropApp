import 'package:drop_app/models/chat_model.dart';
import 'package:drop_app/models/message_model.dart';
import 'package:drop_app/models/user_model.dart';
import 'package:drop_app/pages/message_page.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String userName;
  final String itemName;
  final String userAvatarUrl;
  final String? itemImageUrl; // Assumes this now refers to an asset path
  final String date;
  final int category;
  final UserModel user;
  final product;
  final ChatModel chat;

  const ChatItem({
    required this.userName,
    required this.itemName,
    required this.userAvatarUrl,
    this.itemImageUrl,
    required this.date,
    required this.category,
    required this.chat,
    required this.product,
    required this.user,
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MessagePage(chat: chat, user: user,post: product,)),
                          );
                        },
      child: Container(
        padding: const EdgeInsets.all( 10.0),
        child: Row(
          children: [
            // Conditional image display
            chat.type == 1
                ? Stack(
                    clipBehavior: Clip.none, // Allows the circle to overflow the stack
                    children: [
                      // Square item image or fallback with first letter
                      itemImageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                          //  child: _fallbackItemAvatar(itemName),
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
                        // child: _fallbackUserAvatar(userName, 12),
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
            SizedBox(width: 200,),
            Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Fallback widget for user avatar with first letter of userName
  Widget _fallbackUserAvatar(String name, double radius) {
    return CircleAvatar(
      backgroundColor:Color.fromARGB(255, 108, 106, 157),
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