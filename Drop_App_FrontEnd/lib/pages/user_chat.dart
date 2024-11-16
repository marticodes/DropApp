import 'package:flutter/material.dart';
import 'package:drop_app/components/message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Sample data simulating messages from a database
  List<Map<String, dynamic>> messages = [
    {"text": "Message 1", "isConfirmed": false},
    {"text": "Message 2", "isConfirmed": false},
    {"text": "Message 3", "isConfirmed": false},
  ];

  // Method to update the state when the message is confirmed
  void confirmMessage(int index) {
    setState(() {
      messages[index]["isConfirmed"] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return MessageWidget(
            message: messages[index]["text"],
            isConfirmed: messages[index]["isConfirmed"],
            onConfirm: () => confirmMessage(index),
          );
        },
      ),
    );
  }
}
