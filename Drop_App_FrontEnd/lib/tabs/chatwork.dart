import 'package:flutter/material.dart';
import 'package:drop_app/top_bar/top_bar_go_back.dart';
import 'package:drop_app/components/rating.dart';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'message': 'I have the pot you are looking for. Should we meet at W2 in ten?', 'sender': 'user', 'time': '08:15 AM'},
    {'message': 'Yes. Thank you for your help! Let’s confirm the share.', 'sender': 'other', 'time': '08:16 AM'},
  ];

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'message': text,
        'sender': 'user',
        'time': 'Just Now',
      });
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackTopBar(), 
      body: Column(
        children: [
          //User Banner
          Container(
            color: const Color.fromARGB(255, 108, 106, 157),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 25,
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cooking Pot',  //CHANGE
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                         color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 3,),
                        Text(
                          'Kim Namjoon',  //CHANGE
                          style: TextStyle(
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
          
          //Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: buttonColor == Colors.grey
                  ? null // Disable the button when it's gray
                  : _onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor, // Button color based on state
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(buttonState, 
                style: const TextStyle(
                color: Colors.white,
                fontSize:20,
                fontWeight: FontWeight.w400, 
              ),), // Display the current state text
            ),
          ),

          
          // Chat bubbles
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUser ? const Color.fromARGB(255, 108, 106, 157) : Colors.yellow[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['message'],
                          style: isUser ? TextStyle(color: Colors.white): TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        message['time'],
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(0,0,0,0.5), // Border color
                width: 0.2, // Border width
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
                      prefixIcon: Icon(Icons.face, color: const Color.fromARGB(255, 108, 106, 157)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.image, color: const Color.fromARGB(255, 108, 106, 157)),
                  onPressed: () {
                    // Handle image selection
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send, color: const Color.fromARGB(255, 108, 106, 157)),
                  onPressed: () {
                    _sendMessage(_messageController.text);
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
      // Show the RatingWidget popup
      showDialog(
        context: context,
        builder: (context) => RatingWidget(
          onPressed: () {
            // When the rating is done, set the button to "Completed" state
            setState(() {
              buttonState = "Returned";
              buttonColor = Colors.grey; // Make the button gray
            });
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      );
    }
  }




}


