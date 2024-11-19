import 'package:drop_app/models/sharing_post_model.dart';
import 'package:drop_app/pages/create_request.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/components/single_share_quest.dart';
import 'package:drop_app/top_bar/top_bar_search.dart';
import 'package:drop_app/top_bar/top_bar_go_back.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:drop_app/api/api_service.dart';

class ShareQuestList extends StatefulWidget {
  const ShareQuestList({super.key});

  @override
  ShareQuestListState createState() => ShareQuestListState();
}

class ShareQuestListState extends State<ShareQuestList> {
  String _searchQuery = ''; // Holds the search input
  final List<SharingModel> _sharingModelPosts = [];

  @override
  void initState() {
    super.initState();
    fetchActiveSharingPosts(); // Fetch the active sharing posts when the widget is first created
  }

  // Fetch active sharing posts from the API
  Future<void> fetchActiveSharingPosts() async {
    try {
      List<SharingModel> posts = await ApiService.listActiveSharing();
      setState(() {
        _sharingModelPosts.clear(); // Clear any previous data
        _sharingModelPosts.addAll(posts); // Add fetched posts to the list
      });
    } catch (e) {
      print('Error fetching active sharing posts: $e');
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter posts based on search query
    List<SharingModel> filteredPosts = _sharingModelPosts.where((post) {
      return post.sproductName.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: CustomTopBar(onSearchChanged: _onSearchChanged), 
      body: ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          final quest = filteredPosts[index];

          return ShareQuestItem(
            userName: 'quest.userName', // Replace with actual user name if available
            itemName: quest.sproductName,
            itemDescription: quest.sproductDescription,
            coins: quest.coinValue,
            timeRemaining: '30', // Replace with actual time remaining
            date: quest.sproductStartTime,
          );
        },
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: const Color.fromARGB(255, 108, 106, 157),
        foregroundColor: Colors.white,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 10,
        children: [
          SpeedDialChild(
            child: Image.asset('assets/images/donate.png', color: Colors.white, width: 28, height: 28),
            backgroundColor: const Color.fromARGB(255, 108, 106, 157),
            foregroundColor: Colors.white,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Share()),
            ),
          ),
          SpeedDialChild(
            child: Image.asset('assets/images/share.png', color: Colors.white, width: 28, height: 28),
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 108, 106, 157),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Share()),
            ),
          ),
        ],
      ),
    );
  }
}
