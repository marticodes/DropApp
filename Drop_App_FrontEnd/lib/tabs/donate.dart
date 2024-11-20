import 'package:drop_app/pages/create_request.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/top_bar/top_bar_search.dart';
import 'package:drop_app/components/filter_menu_donation.dart';
import 'package:drop_app/components/donation_item.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/models/donation_post_model.dart';
import 'package:drop_app/pages/page_item_donation.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  String _searchQuery = ''; // Holds the search input
  final List<DonationModel> _donationPosts = []; // Holds the list of donation posts

  @override
  void initState() {
    super.initState();
    fetchDonationPosts(); // Fetch donation posts on initialization
  }

  Future<void> fetchDonationPosts() async {
    List<DonationModel> posts = await ApiService.fetchActiveDonationPosts();
    setState(() {
      _donationPosts.clear();
      _donationPosts.addAll(posts);
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DonationModel> filteredPosts = _donationPosts.where((post) {
      return post.productName.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      drawer: FilterMenu(),
      appBar: CustomTopBar(onSearchChanged: _onSearchChanged),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7,
          ),
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) {
            final post = filteredPosts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailPage(item: post),
                  ),
                );
              },
              child: PostCard(item: post),
            );
          },
        ),
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
            backgroundColor: const Color.fromARGB(255, 108, 106, 157),
            foregroundColor: Colors.white,
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
