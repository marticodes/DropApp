import 'package:drop_app/models/chat_model.dart';
import 'package:drop_app/models/donation_post_model.dart';
import 'package:drop_app/models/sharing_post_model.dart';
import 'package:drop_app/models/user_model.dart';
import 'package:drop_app/pages/create_request.dart';
import 'package:drop_app/pages/donate_message_page.dart';
import 'package:drop_app/pages/share_message_page.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/top_bar/top_bar_go_back.dart';
import 'package:drop_app/components/rating.dart';


const serverUrl = 'http://localhost:3001/';

class MessagePage extends StatefulWidget {
   final post;
   final ChatModel chat;
   final UserModel user;
 MessagePage({super.key, this.post, required this.chat, required this.user});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    ChatModel chat = widget.chat;
    UserModel user = widget.user;
    if(chat.type == 0) 
      {return DonationMessagePage(chat: chat, post: widget.post!, user:user );}
    else{
      return ShareMessagePage(chat: chat, post: widget.post!, user:user );
    }
  }

}


