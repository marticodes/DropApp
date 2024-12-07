import 'package:drop_app/models/id_model.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/models/chat_model.dart';
import 'package:drop_app/models/donation_post_model.dart';
import 'package:drop_app/models/message_model.dart';
import 'package:drop_app/models/sharing_post_model.dart';
import 'package:drop_app/models/user_model.dart';
import 'package:drop_app/pages/message_page.dart';
import 'package:drop_app/components/single_chat.dart';
import 'package:drop_app/top_bar/top_bar_search_chat.dart';
import 'package:drop_app/global.dart' as globals;
import 'package:intl/intl.dart';
class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  int selectedFilter = 2;
  String _searchQuery = '';
  List<ChatModel> chatItems = [];
  final Map<int, Map<String, dynamic>> _chatDataCache = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllChatsForUser(globals.userData).then((_) => preloadChatData());
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  Future<void> fetchAllChatsForUser(int userId) async {
    try {
      List<ChatModel> posts = await ApiService.fetchAllChatsForUser(userId);
      setState(() {
        chatItems = posts;
      });
    } catch (error) {
      print('Error fetching chats: $error');
    }
  }

  Future<void> preloadChatData() async {
    try {
      for (var chat in chatItems) {
        _chatDataCache[chat.chatId] = await _fetchChatData(chat);
      }
    } catch (error) {
      print('Error preloading chat data: $error');
    } finally {
      setState(() {
        _isLoading = false; // Loading complete
      });
    }
  }

  Future<Map<String, dynamic>> _fetchChatData(ChatModel chat) async {
    try {
      final UserModel user = await ApiService.fetchUserById(chat.userId2);
      final productData = await ApiService.getChatProduct(chat.chatId);
      final sproductId = productData['sproduct_id'];
      final productId = productData['product_id'];
      final product = await fetchPostByProductId(chat, sproductId, productId);
      final List<MessageModel> messages =
          await ApiService.fetchMessagesByChatId(chat.chatId);

      return {
        'user': user,
        'product': product,
        'messages': messages,
      };
    } catch (error) {
      print('Error fetching chat data for chatId ${chat.chatId}: $error');
      return {};
    }
  }

  Future<dynamic> fetchPostByProductId(ChatModel chat, final sproductId, final productId) async {
    if (chat.type == 1) {
      try {
        final List<SharingModel>posts = await ApiService.listAllSharing();
        return posts.firstWhere((post) => post.sproductId == sproductId);
      } catch (error) {
        print('Error processing sharing posts: $error');
      }
    } else {
      try {
        final donationPosts = await ApiService.fetchAllDonationPosts();
        return donationPosts.firstWhere((post) => post.productId == productId);
      } catch (error) {
        print('Error processing donation posts: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    List<ChatModel> filteredChatItems = [];
     List<ChatModel> items = chatItems.where((chat) {
      final data = _chatDataCache[chat.chatId];
      if (data == null) return false;

      final user = data['user'] as UserModel;
      final product = data['product'];

      // Match search query with user name or product name
      final userNameMatch = user.userName.toLowerCase().contains(_searchQuery);
      final productNameMatch = (chat.type == 0
              ? product.productName
              : product.sproductName)
          .toLowerCase()
          .contains(_searchQuery);

      return userNameMatch || productNameMatch;
    }).toList();

    // Apply selected filter (Donation, Sharing, or All)
    items = selectedFilter == 2
        ? items
        : items.where((chat) => chat.type == selectedFilter).toList();


    filteredChatItems.addAll(items.reversed);

    return Scaffold(
      appBar: CustomTopBar(onSearchChanged: _onSearchChanged),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter Row
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _buildFilterChip('All', 2),
                      _buildFilterChip('Donation', 0),
                      _buildFilterChip('Sharing', 1),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredChatItems.length,
                    itemBuilder: (context, index) {
                      final chat = filteredChatItems[index];
                      final data = _chatDataCache[chat.chatId];

                      if (data == null) {
                        return const Center(
                            child: Text('Error or missing chat data.'));
                      } else {
                        final user = data['user'] as UserModel;
                        final product = data['product'];
                        final messages =
                            data['messages'] as List<MessageModel>;

                        if (chat.type == 0) {
                          return getDonation(chat, user, product, messages);
                        } else {
                          return getSharing(chat, user, product, messages);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChip(String label, int filterValue) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedFilter == filterValue,
        onSelected: (bool selected) {
          setState(() {
            selectedFilter = filterValue; // Update the selected filter value
          });
        },
      ),
    );
  }

  ChatItem getDonation(chat, user, product, messages) {
    return ChatItem(
      userName: user.userName,
      itemName: product.productName,
      date: (messages.isNotEmpty)
          ? DateFormat('dd/MM/yyyy hh:mm a').format(DateParse(messages.last.messageTime))
          : DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
      userAvatarUrl: user.userPicture,
      category: 0,
      itemImageUrl: product.productPicture,
      user: user,
      chat: chat,
      product: product,
    );
  }

  ChatItem getSharing(chat, user, product, messages) {
    return ChatItem(
      userName: user.userName,
      itemName: product.sproductName,
      date: (messages.isNotEmpty)
          ? DateFormat('dd/MM/yyyy hh:mm a').format(DateParse(messages.last.messageTime))
          : DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
      userAvatarUrl: user.userPicture,
      category: 1,
      user: user,
      chat: chat,
      product: product,
    );
  }


  DateTime DateParse(String date){try {
    // Extract only the necessary part before "GMT"
    String trimmedDate = date.split("GMT")[0].trim();
    // Use the correct pattern to parse the date
    return DateFormat("EEE MMM dd yyyy HH:mm:ss").parse(trimmedDate);
  } catch (e) {
    print("Date parsing failed for $date: $e");
    return DateTime.now(); // Fallback to current time
  }}
}