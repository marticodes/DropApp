import 'package:drop_app/components/filter_menu_sharing.dart';
import 'package:drop_app/models/sharing_post_model.dart';
import 'package:drop_app/pages/create_donation_post.dart';
import 'package:drop_app/pages/create_request.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/components/single_share_quest.dart';
import 'package:drop_app/top_bar/top_bar_search.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/models/user_model.dart';

class ShareQuestList extends StatefulWidget {
  const ShareQuestList({super.key});

  @override
  ShareQuestListState createState() => ShareQuestListState();
}

class ShareQuestListState extends State<ShareQuestList> {
  String _searchQuery = ''; // Holds the search input
  final List<SharingModel> _sharingModelPosts = [];
  final Map<int, UserModel> _userCache = {};
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchActiveSharingPosts(); // Fetch posts when the page is initialized
  }

  // Fetch all sharing posts and reverse the order
  Future<void> fetchActiveSharingPosts() async {
    try {
      List<SharingModel> posts = await ApiService.listAllSharing();

      setState(() {
        _sharingModelPosts.clear();
        _sharingModelPosts.addAll(posts.reversed);
      });

      // Fetch user data for each post, if not already in the cache
      for (var post in posts) {
        if (!_userCache.containsKey(post.borrowerID)) {
          UserModel user = await ApiService.fetchUserById(post.borrowerID);
          setState(() {
            _userCache[post.borrowerID] = user;
          });
        }
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  // Fetch filtered sharing posts
  Future<void> fetchFilteredSharingPosts(List<String> categories) async {
    try {
      List<SharingModel> posts = await _apiService.filterSharingByCategory(categories);

      setState(() {
        _sharingModelPosts.clear();
        _sharingModelPosts.addAll(posts.reversed);
      });

      // Fetch user data for each post, if not already in the cache
      for (var post in posts) {
        if (!_userCache.containsKey(post.borrowerID)) {
          UserModel user = await ApiService.fetchUserById(post.borrowerID);
          setState(() {
            _userCache[post.borrowerID] = user;
          });
        }
      }
    } catch (e) {
      print("Error fetching filtered posts: $e");
    }
  }

  // Handle the search input change
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter posts based on the search query
    List<SharingModel> filteredPosts = _sharingModelPosts.where((post) {
      return post.sproductName.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      drawer: FilterMenu(
        onApplyFilters: (selectedCategories) {
          fetchFilteredSharingPosts(selectedCategories);
        },
      ),
      appBar: CustomTopBar(onSearchChanged: _onSearchChanged), // Replace back top bar with search bar
      body: ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          final quest = filteredPosts[index];

          // Retrieve the user name from the cache
          String userName = '${_userCache[quest.borrowerID]?.userName} ${_userCache[quest.borrowerID]?.userSurname}' ?? 'Loading...';

          return ShareQuestItem(
            post: quest,
            userCache: _userCache,
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
            child: Image.asset('assets/images/donate.png', color: Colors.white, width: 28, height: 28),
            backgroundColor: const Color.fromARGB(255, 108, 106, 157),
            foregroundColor: Colors.white,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Donate()),
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
