import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/models/chat_model.dart';
import 'package:drop_app/models/sharing_post_model.dart';
import 'package:drop_app/models/user_model.dart';
import 'package:drop_app/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/models/donation_post_model.dart';
import 'package:drop_app/top_bar/top_bar_go_back.dart';
import 'package:drop_app/components/user_review_name_row.dart';
import 'package:drop_app/global.dart' as globals;


class ItemDetailPage extends StatefulWidget {
  final DonationModel item;
  const ItemDetailPage({Key? key, required this.item}) : super(key: key);
  @override
  ItemDetailPageState createState() => ItemDetailPageState();

}

class ItemDetailPageState extends State<ItemDetailPage> {
  final int rating = 4;
  final SERVER_URL = 'http://localhost:3001/';

  Future<int> insertChat( userID1,
        userID2,
        productID,
        type,
        sproductId,
        ) async {
       int productId = await ApiService.insertChat(
        userID1,
        userID2,
        productID,
        type,
        sproductId,
      );
      return productId;
  }

  @override
  Widget build(BuildContext context) {
  DonationModel item = widget.item;

  Future<UserModel> fetchUserById(DonationModel item) async {
  UserModel user =  await ApiService.fetchUserById(item.donorId);
  return user;
  }


    return Scaffold(
      appBar: BackTopBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserProfileRow(
            userId: item.donorId,
          ),
          Image.network(
            SERVER_URL + item.productPicture,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                        Text(item.productCategory, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 251, 124, 45),
                          radius: 16.5,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow[700],
                            radius: 14.5,
                            child: CircleAvatar(
                              backgroundColor: const Color.fromARGB(255, 234, 157, 42),
                              radius: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 100),
                        Text('${item.coinValue} Coin', style: TextStyle(fontSize: 16, color: Colors.yellow[700], fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('Item Condition', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                Text('Good', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Description', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                Text( item.productDescription, style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 108, 106, 157),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                int requestedById = item.donorId; // Ensure this is valid
                int productId = item.productId; // Ensure this is valid
                int productType = 0;
                int chatId = await insertChat(globals.userData, requestedById, productId, productType, 0);
                ChatModel chat = ChatModel(
                    chatId: chatId,
                    userId1: globals.userData,
                    userId2: requestedById,
                    productId: productId,
                    type: productType,
                    sproductId: 0
                  );

                UserModel user = await fetchUserById(item);
                


                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MessagePage(post: item, chat: chat, user: user)),
                      );
              },
              child: Center(child: Text('Chat', style: TextStyle(fontSize: 18, color:  const Color.fromARGB(221, 255, 255, 255)))),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
