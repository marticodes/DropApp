import 'package:drop_app/models/sharing_post_model.dart';
import 'package:drop_app/pages/create_request.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/components/single_share_quest.dart';
import 'package:drop_app/top_bar/top_bar_search.dart';
import 'package:drop_app/top_bar/top_bar_go_back.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/models/user_model.dart';

class ShareQuestList extends StatefulWidget {
  const ShareQuestList({super.key});

  @override
  ShareQuestListState createState() => ShareQuestListState();
}

class ShareQuestListState extends State<ShareQuestList> {
  // late final List<ShareQuest> shareQuests;
  String _searchQuery = ''; // Holds the search input
  final List<SharingModel> _sharingModelPosts=  [];
  final Map<int, String> _userNamesCache = {};

  
  @override
  void initState() {
    super.initState();
    fetchActiveSharingPosts(); 
  }

Future<void> fetchActiveSharingPosts() async {
  List<SharingModel> posts = await ApiService.listAllSharing();

  setState(() {
    _sharingModelPosts.clear();
    _sharingModelPosts.addAll(posts);
  });

  for (var post in posts) {
    if (!_userNamesCache.containsKey(post.borrowerID)) {
      try {
        // Fetch user data
        UserModel user = await ApiService.fetchUserById(post.borrowerID);

        setState(() {
          _userNamesCache[post.borrowerID] = '${user.userName} ${user.userSurname}';
        });
      } catch (e) {
        setState(() {
          _userNamesCache[post.borrowerID] = 'Unknown User'; // Fallback for errors
        });
      }
    }
  }
}
  
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }


  @override
  Widget build(BuildContext context) {
    // // Filter posts based on search query
    List<SharingModel> filteredPosts = _sharingModelPosts.where((post) {
      return post.sproductName.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: CustomTopBar(onSearchChanged: _onSearchChanged), // MUST CHANGE THIS TO SEARCH BAR INSTEAD OF BACKTOPBAR 
      //the issue why i cant use the normal search bar is that share quests are not widget but list
      //to make the search bar to work the seatchquestlist has to become a widget (CHECK HOW I DID FOR DONATION)
      body: ListView.builder(
  itemCount: filteredPosts.length,
  itemBuilder: (context, index) {
    final quest = filteredPosts[index];

    // Retrieve the user name from the cache
    String userName = _userNamesCache[quest.borrowerID] ?? 'Loading...';

    return ShareQuestItem(
      userName: userName, // Pass the correct user name
      itemName: quest.sproductName,
      itemDescription: quest.sproductDescription,
      coins: quest.coinValue,
      timeRemaining: '30', // FIX
      date: quest.sproductStartTime,
    );
  },
),
      floatingActionButton: SpeedDial(
          icon: Icons.add, // The main floating button icon
          activeIcon: Icons.close, // Icon when the button is expanded
          backgroundColor: const Color.fromARGB(255, 108, 106, 157),
          foregroundColor: Colors.white,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          spacing: 10, // Space between children
          children: [
            SpeedDialChild(
              child: Image.asset('assets/images/donate.png', color: Colors.white, width: 28, height:  28,),
              backgroundColor: const Color.fromARGB(255, 108, 106, 157),
              foregroundColor: Colors.white,
              onTap: () =>  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Share()),
                      ),
            ),
            SpeedDialChild(
              child: Image.asset('assets/images/share.png', color: Colors.white, width: 28, height:  28,),
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 108, 106, 157),
              onTap: () =>  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Share()),
                      ),
            ),
          ],
        ),

    );
  }
}