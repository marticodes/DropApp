import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/models/chat_model.dart';
import 'package:drop_app/models/donation_post_model.dart';
import 'package:drop_app/models/message_model.dart';
import 'package:drop_app/models/sharing_post_model.dart';
import 'package:drop_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/top_bar/top_bar_go_back.dart';
import 'package:drop_app/components/rating.dart';
import 'package:intl/intl.dart';


const serverUrl = 'http://localhost:3001/';

class ShareMessagePage extends StatefulWidget {
   SharingModel spost;
   final ChatModel chat;
   final UserModel user;
 ShareMessagePage({super.key, required this.spost, required this.chat, required this.user});

  @override
  _ShareMessagePageState createState() => _ShareMessagePageState();
}

class _ShareMessagePageState extends State<ShareMessagePage> {
  int moneycount = 7;
  final List<MessageModel> _messageModelPosts = [];

  @override
void initState() {
  super.initState();
  fetchMessagesByChatId(widget.chat.chatId);
}


  Future<void> fetchMessagesByChatId(int chatId) async {
    List<MessageModel> posts = await ApiService.fetchMessagesByChatId(chatId);

    setState(() {
      _messageModelPosts.clear();
      // Reverse the posts and add them to the list
      _messageModelPosts.addAll(posts);
    });

  }

  Future<int> insertMessage(
        chatId,
        content,
        image,
        senderId,
        messageTime,) async {
      int msgId = await ApiService.insertMessage(
        chatId: chatId,
        content: content,
        image: image,
        senderId: senderId,
        messageTime: messageTime
      );
      return msgId;

  }


  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ChatModel chat = widget.chat;
    UserModel user = widget.user;
    SharingModel post = widget.spost;

    String formatMessageTime(DateTime dateTime) {
  // Format the DateTime object to display HH:MM AM/PM
      return DateFormat('hh:mm a').format(dateTime);
}

    return Scaffold(
      appBar: BackTopBar(),
      body: Column(
        children: [
          // User Banner
          Container(
            color: const Color.fromARGB(255, 108, 106, 157),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 25,
                  child: Image.network(serverUrl+user.userPicture)
                ),
                const SizedBox(width: 12),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.sproductName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 3),
                        Text(
                          '${user.userName} ${user.userSurname}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: buttonColor == Colors.grey
                  ? null // Disable the button when it's gray
                  : _onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                buttonState,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          // Chat bubbles
          Expanded(
            child: ListView.builder(
              itemCount: _messageModelPosts.length,
              itemBuilder: (context, index) {
                final message = _messageModelPosts[index];
                final isUser = message.senderId == user.userId;
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment:
                        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color.fromARGB(255, 108, 106, 157)
                              : Colors.yellow[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message.content,
                          style: isUser
                              ? const TextStyle(color: Colors.white)
                              : const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                       formatMessageTime(DateTime.parse(message.messageTime)),
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Input field
          Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                width: 0.2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Message ...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.face,
                          color: Color.fromARGB(255, 108, 106, 157)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.image,
                      color: Color.fromARGB(255, 108, 106, 157)),
                  onPressed: () {
                    // Handle image selection
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send,
                      color: Color.fromARGB(255, 108, 106, 157)),
                  onPressed: () async {
                    String content = _messageController.text;
                    _messageController.clear();

                    int msgId = await insertMessage(chat.chatId,content,"null",user.userId,DateTime.now().toString());
                    MessageModel newMessage = MessageModel(
                    messageId: msgId,
                    chatId: chat.chatId,
                    content: content,
                    image: null,
                    senderId: user.userId,
                    messageTime: DateTime.now().toIso8601String(),
                  );

    // Add the new message to the message list and update the UI
    setState(() {
      _messageModelPosts.add(newMessage);
    });


                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  String buttonState = "Confirm"; // Initial state
  Color buttonColor = const Color.fromARGB(255, 108, 106, 157); // Initial color

  void _onButtonPressed() {
    if (buttonState == "Confirm") {
      setState(() {
        buttonState = "Returned";
      });
    } else if (buttonState == "Returned") {
      setState(() {
              moneycount = 8;
              buttonState = "Completed";
              buttonColor = Colors.grey; // Make the button gray
            });
      // Show the RatingWidget popup
      showDialog(
        context: context,
        builder: (context) => RatingWidget(
          onPressed: () {
            // Update moneycount to 8
            
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      );
    }
  }
}


