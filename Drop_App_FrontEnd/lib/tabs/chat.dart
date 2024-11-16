import 'package:drop_app/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/components/single_chat.dart';
import 'package:drop_app/top_bar/top_bar_search_chat.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  String selectedFilter = 'All'; // Track selected filter
  String _searchQuery = ''; // Holds the search input

    void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  final List<Map<String, String>> chatItems = [
    {
      'userName': 'Kim Namjoon',
      'itemName': 'Cooking Pot',
      'date': '2024/10/30',
      'category': 'Donation',
      'avatarUrl': 'https://example.com/avatar1.png',
    },
    {
      'userName': 'Lee Seokmin',
      'itemName': 'Lamp',
      'date': '2024/08/21',
      'category': 'Sharing',
      'avatarUrl': 'https://example.com/avatar2.png',
    },
    {
      'userName': 'Boo Seungkwan',
      'itemName': 'Korean books',
      'date': '2024/09/12',
      'category': 'Donation',
      'avatarUrl': 'https://example.com/avatar3.png',
    },
    {
      'userName': 'Jiajin Xia',
      'itemName': 'Hangers',
      'date': '2024/07/02',
      'category': 'Sharing',
      'avatarUrl': 'https://example.com/avatar4.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter chat items based on the selected filter
    List<Map<String, String>> filteredChatItems = selectedFilter == 'All'
        ? chatItems
        : chatItems.where((chat) => chat['category'] == selectedFilter).toList();

    return Scaffold(
      appBar: CustomTopBar(onSearchChanged: _onSearchChanged), // Pass the search callback
      body: Column(
        children: [
          // Filter Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ChoiceChip(
                  label: Text('All'),
                  selected: selectedFilter == 'All',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = 'All';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Donation'),
                  selected: selectedFilter == 'Donation',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = 'Donation';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Sharing'),
                  selected: selectedFilter == 'Sharing',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = 'Sharing';
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredChatItems.length,
              itemBuilder: (context, index) {
                final chat = filteredChatItems[index];
                return GestureDetector(
                  onTap: () {
                      // Navigate to the placeholder page on tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MessagePage()),
                      );
                    },
                  child: ChatItem(
                    userName: chat['userName']!,
                    itemName: chat['itemName']!,
                    date: chat['date']!,
                    userAvatarUrl: chat['avatarUrl']!,
                    category: chat['category']!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}