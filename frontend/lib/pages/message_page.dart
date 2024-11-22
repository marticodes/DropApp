import 'package:flutter/material.dart';
import 'package:drop_app/top_bar/top_bar_go_back.dart';
import 'package:drop_app/components/rating.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  int moneycount = 7;

  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'message': 'I have the pot you are looking for. Should we meet at W2 in ten?',
      'sender': 'user',
      'time': '08:15 AM'
    },
    {
      'message': 'Yes. Thank you for your help! Let’s confirm the share.',
      'sender': 'other',
      'time': '08:16 AM'
    },
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
          // User Banner
          Container(
            color: const Color.fromARGB(255, 108, 106, 157),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 25,
                  child: Image.asset('assets/images/martina.jpg')
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bowl',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 3),
                        Text(
                          'Martina Di Paola',
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
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
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
                          message['message'],
                          style: isUser
                              ? const TextStyle(color: Colors.white)
                              : const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        message['time'],
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


