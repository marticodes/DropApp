// import 'package:drop_app/models/id_model.dart';
// import 'package:flutter/material.dart';
// import 'package:drop_app/api/api_service.dart';
// import 'package:drop_app/models/chat_model.dart';
// import 'package:drop_app/models/donation_post_model.dart';
// import 'package:drop_app/models/message_model.dart';
// import 'package:drop_app/models/sharing_post_model.dart';
// import 'package:drop_app/models/user_model.dart';
// import 'package:drop_app/pages/message_page.dart';
// import 'package:drop_app/components/single_chat.dart';
// import 'package:drop_app/top_bar/top_bar_search_chat.dart';
// import 'package:drop_app/global.dart' as globals;
// import 'package:intl/intl.dart';
// class ChatListPage extends StatefulWidget {
//   @override
//   _ChatListPageState createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   int selectedFilter = 2;
//   String _searchQuery = '';
//   List<ChatModel> chatItems = [];
//   final Map<int, Map<String, dynamic>> _chatDataCache = {};
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchAllChatsForUser(globals.userData).then((_) => preloadChatData());
//   }

//   void _onSearchChanged(String query) {
//     setState(() {
//       _searchQuery = query.toLowerCase();
//     });
//   }

//   Future<void> fetchAllChatsForUser(int userId) async {
//     try {
//       List<ChatModel> posts = await ApiService.fetchAllChatsForUser(userId);
//       setState(() {
//         chatItems = posts;
//       });
//     } catch (error) {
//       print('Error fetching chats: $error');
//     }
//   }

//   Future<void> preloadChatData() async {
//     try {
//       for (var chat in chatItems) {
//         _chatDataCache[chat.chatId] = await _fetchChatData(chat);
//       }
//     } catch (error) {
//       print('Error preloading chat data: $error');
//     } finally {
//       setState(() {
//         _isLoading = false; // Loading complete
//       });
//     }
//   }

//   Future<Map<String, dynamic>> _fetchChatData(ChatModel chat) async {
//     try {
//       final UserModel user = await ApiService.fetchUserById(chat.userId2);
//       final productData = await ApiService.getChatProduct(chat.chatId);
//       final sproductId = productData['sproduct_id'];
//       final productId = productData['product_id'];
//       final product = await fetchPostByProductId(chat, sproductId, productId);
//       final List<MessageModel> messages =
//           await ApiService.fetchMessagesByChatId(chat.chatId);

//       return {
//         'user': user,
//         'product': product,
//         'messages': messages,
//       };
//     } catch (error) {
//       print('Error fetching chat data for chatId ${chat.chatId}: $error');
//       return {};
//     }
//   }

//   Future<dynamic> fetchPostByProductId(ChatModel chat, final sproductId, final productId) async {
//     if (chat.type == 1) {
//       try {
//         final posts = await ApiService.listAllSharing();
//         return posts.firstWhere((post) => post.sproductId == sproductId);
//       } catch (error) {
//         print('Error processing sharing posts: $error');
//       }
//     } else {
//       try {
//         final donationPosts = await ApiService.fetchActiveDonationPosts();
//         return donationPosts.firstWhere((post) => post.productId == productId);
//       } catch (error) {
//         print('Error processing donation posts: $error');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<ChatModel> filteredChatItems = [];
//     List<ChatModel> items = selectedFilter == 2
//         ? chatItems
//         : chatItems.where((chat) => chat.type == selectedFilter).toList();

//     filteredChatItems.addAll(items.reversed);

//     return Scaffold(
//       appBar: CustomTopBar(onSearchChanged: _onSearchChanged),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // Filter Row
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       _buildFilterChip('All', 2),
//                       _buildFilterChip('Donation', 0),
//                       _buildFilterChip('Sharing', 1),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredChatItems.length,
//                     itemBuilder: (context, index) {
//                       final chat = filteredChatItems[index];
//                       final data = _chatDataCache[chat.chatId];

//                       if (data == null) {
//                         return const Center(
//                             child: Text('Error or missing chat data.'));
//                       } else {
//                         final user = data['user'] as UserModel;
//                         final product = data['product'];
//                         final messages =
//                             data['messages'] as List<MessageModel>;

//                         if (chat.type == 0) {
//                           return getDonation(chat, user, product, messages);
//                         } else {
//                           return getSharing(chat, user, product, messages);
//                         }
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildFilterChip(String label, int filterValue) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: ChoiceChip(
//         label: Text(label),
//         selected: selectedFilter == filterValue,
//         onSelected: (bool selected) {
//           setState(() {
//             selectedFilter = filterValue; // Update the selected filter value
//           });
//         },
//       ),
//     );
//   }

//   ChatItem getDonation(chat, user, product, messages) {
//     return ChatItem(
//       userName: user.userName,
//       itemName: product.productName,
//       date: (messages.isNotEmpty)
//           ? DateFormat('dd/MM/yyyy hh:mm a').format(messages.last.time)
//           : DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
//       userAvatarUrl: user.userPicture,
//       category: 0,
//       itemImageUrl: product.productPicture,
//       user: user,
//       chat: chat,
//       product: product,
//     );
//   }

//   ChatItem getSharing(chat, user, product, messages) {
//     return ChatItem(
//       userName: user.userName,
//       itemName: product.sproductName,
//       date: (messages.isNotEmpty)
//           ? DateFormat('dd/MM/yyyy hh:mm a').format(messages.last.time)
//           : DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
//       userAvatarUrl: user.userPicture,
//       category: 1,
//       user: user,
//       chat: chat,
//       product: product,
//     );
//   }
// }





// class ChatListPage extends StatefulWidget {
//   @override
//   _ChatListPageState createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   int selectedFilter = 2;
//   String _searchQuery = '';
//   List<ChatModel> chatItems = [];
//   final Map<int, Future<Map<String, dynamic>>> _chatDataCache = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchAllChatsForUser(globals.userData);
//   }

//   void _onSearchChanged(String query) {
//     setState(() {
//       _searchQuery = query.toLowerCase();
//     });
//   }

//   Future<void> fetchAllChatsForUser(int userId) async {
//     try {
//       List<ChatModel> posts = await ApiService.fetchAllChatsForUser(userId);
//       setState(() {
//         chatItems = posts;
//       });
//     } catch (error) {
//       print('Error fetching chats: $error');
//     }
//   }

//   Future<Map<String, dynamic>> fetchChatData(ChatModel chat) {
//     if (!_chatDataCache.containsKey(chat.chatId)) {
//       _chatDataCache[chat.chatId] = _fetchChatData(chat);
//     }
//     return _chatDataCache[chat.chatId]!;
//   }


//    Future<Map<String, dynamic>> _fetchChatData(ChatModel chat) async {
//     try {
//       final UserModel user = await ApiService.fetchUserById(chat.userId2);
//       final productData = await ApiService.getChatProduct(chat.chatId);
//       final sproductId = productData['sproduct_id'];
//       final productId = productData['product_id'];
//       final product = await fetchPostByProductId(chat, sproductId, productId);


//       final List<MessageModel> messages = await ApiService.fetchMessagesByChatId(chat.chatId);

//       return {
//         'user': user,
//         'product': product,
//         'messages': messages,
//       };
//     } catch (error) {
//       print('Error fetching chat data for chatId ${chat.chatId}: $error');
//       return {};
//     }
//   }

  
//   Future<dynamic> fetchPostByProductId(ChatModel chat, final sproductId, final productId) async {
//   if (chat.type == 1) {
//     // Chat type is 1: Process Sharing objects
//     try {
//       final posts = await ApiService.listAllSharing();
//       // Find the SharingModel with the given productId
//       final post = posts.firstWhere(
//         (post) => post.sproductId == sproductId,);
//       return post;
//     } catch (error) {
//       print('Error processing sharing posts: $error');
//     }
//   } else {
//     // Chat type is 0: Process Donation objects
//     try {
//       List<DonationModel> donationPosts = await ApiService.fetchActiveDonationPosts();
//       // Find the DonationModel with the given productId
//       final post = donationPosts.firstWhere(
//         (post) => post.productId == productId,);

//       return post;
//     } catch (error) {
//       print('Error processing donation posts: $error');
//     }
//   } 
// } 
  

//   @override
//   Widget build(BuildContext context) {
//     //  List<ChatModel> filteredPosts = chatItems.where((post) {
//     //   return post.productName.toLowerCase().contains(_searchQuery);
//     // }).toList();
    
//     List<ChatModel> filteredChatItems = [];
    
//     List<ChatModel> items = selectedFilter == 2
//         ? chatItems
//         : chatItems.where((chat) => chat.type == selectedFilter).toList();

//     filteredChatItems.addAll(items.reversed);

//     return Scaffold(
//       appBar: CustomTopBar(onSearchChanged: _onSearchChanged),
//       body: Column(
//         children: [
//           // Filter Row
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 _buildFilterChip('All', 2),
//                 _buildFilterChip('Donation', 0),
//                 _buildFilterChip('Sharing', 1),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredChatItems.length,
//               itemBuilder: (context, index) {
//                 final chat = filteredChatItems[index];
//                 return FutureBuilder<Map<String, dynamic>>(
//                   future: fetchChatData(chat),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                       final data = snapshot.data!;
//                       final user = data['user'] as UserModel;
//                       final product = data['product'];
//                       final messages = data['messages'] as List<MessageModel>;

//                       if (chat.type == 0) {
//                         return getDonation(chat, user, product, messages);
//                       } else {
//                         return getSharing(chat, user, product, messages);
//                       }
//                     } else {
//                       return const SizedBox.shrink();
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label, int filterValue) {
//   return Padding(
//     padding: const EdgeInsets.only(right: 8.0),
//     child: ChoiceChip(
//       label: Text(label),
//       selected: selectedFilter == filterValue,
//       onSelected: (bool selected) {
//         setState(() {
//           selectedFilter = filterValue; // Update the selected filter value
//         });
//       },
//     ),
//   );
// }

//   ChatItem getDonation(chat, user, product, messages){
//     return ChatItem(
//                           userName: user.userName,
//                           itemName: product.productName,
//                           date: (messages.isNotEmpty) 
//                           ? DateFormat('dd/MM/yyyy hh:mm a').format(messages.last.time)
//                           : DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
//                           userAvatarUrl: user.userPicture,
//                           category: 0,
//                           itemImageUrl: product.productPicture,
//                           user: user,
//                           chat:chat,
//                           product: product,
//                       );

//   }

//   ChatItem getSharing(chat, user, product, messages){
//     return ChatItem(
//       userName: user.userName,
//       itemName: product.sproductName,
//       date: (messages.isNotEmpty) 
//       ? DateFormat('dd/MM/yyyy hh:mm a').format(messages.last.time)
//       : DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
//       userAvatarUrl: user.userPicture,
//       category: 1,
//       user: user,
//     chat:chat,
//     product: product,
//     );
//   }


// }
