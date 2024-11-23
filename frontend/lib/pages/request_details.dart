import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/components/user_review_name_row.dart';
import 'package:drop_app/models/chat_model.dart';
import 'package:drop_app/models/donation_post_model.dart';
import 'package:drop_app/models/sharing_post_model.dart';
import 'package:drop_app/models/user_model.dart';
import 'package:drop_app/pages/message_page.dart';
import 'package:drop_app/tabs/chat.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/top_bar/top_bar_go_back.dart';
import 'package:intl/intl.dart';
import 'package:drop_app/global.dart' as globals;


class ShareDetailPage extends StatefulWidget {
  final SharingModel post;
  final UserModel user;
  const ShareDetailPage({super.key, required this.post, required this.user});

  @override
  ShareDetailPageState createState() => ShareDetailPageState();}

  class  ShareDetailPageState extends State< ShareDetailPage> {

  @override
  Widget build(BuildContext context) {
    SharingModel sharepost = widget.post;
    UserModel user = widget.user;
    DateTime endTime = DateTime.parse(sharepost.sproductEndTime);
    DateTime startTime = DateTime.parse(sharepost.sproductStartTime);
    String formattedStartTime = DateFormat('dd-MM-yyyy   HH:mm').format(startTime);
    String formattedEndTime = DateFormat('dd-MM-yyyy   HH:mm').format(endTime);

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

    return Scaffold(
      appBar: BackTopBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User profile row
          UserProfileRow(userId: sharepost.borrowerID),
          // Item details section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  const Text(
                    "Item Name",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   Text(sharepost.sproductName),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(sharepost.sproductCategory),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                                backgroundColor: const Color.fromARGB(255, 251, 124, 45),
                                radius: 44,
                                child: CircleAvatar(
                                  backgroundColor: Colors.yellow[700],
                                  radius: 38,
                                  child: const CircleAvatar(
                                    backgroundColor:  Color.fromARGB(255, 234, 157, 42),
                                    radius: 26,
                                  ),
                                ),
                              ),
                           Text('${sharepost.coinValue} coins'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "From",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(formattedStartTime),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Until",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(formattedEndTime),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   Text(
                    sharepost.sproductDescription,
                  ),
                ],
              ),
            ),
            const Spacer(),

          // Chat button above the navigation bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 108, 106, 157), 
                foregroundColor: Colors.white, 
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed:()  async{
                int requestedById = user.userId; // Ensure this is valid
                int sproductId = sharepost.sproductId; // Ensure this is valid
                int productType = 1;
                int chatId = await insertChat(1, requestedById, sharepost.borrowerID, productType, sproductId);
                ChatModel chat = ChatModel(
                    chatId: chatId,
                    userId1: globals.userData,
                    userId2: requestedById,
                    productId: sharepost.sproductId,
                    type: productType,
                    sproductId: sproductId
                  );

                  // Navigate to the MessagePage only after the API call completes
                  DonationModel d = DonationModel(
                    productId: 0,
                    productName: 'Nope',
                    productCategory: '',
                    productDescription: '',
                    productPicture: '',
                    donorId: 0,
                    coinValue: 0,
                    active: 0,
                    postingTime: '',
                    status: ''
                  );

                
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MessagePage(dpost: d, spost: sharepost, chat: chat, user: user)),
                      );
                      },
              
              child: const Center(child: Text('Chat', style: TextStyle(fontSize: 18))),
            ),
          ),

          const SizedBox(height: 10), // Space between Chat button and NavBar

        ],
      ),
    );
  }
}