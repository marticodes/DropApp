import 'package:drop_app/pages/create_request.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/top_bar/top_bar_search.dart'; 
import 'package:drop_app/components/filter_menu_donation.dart'; 
//import 'package:drop_app/top_bar_go_back.dart';
import 'package:drop_app/components/donation_item.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class DonatePage extends StatefulWidget {
  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  String _searchQuery = ''; // Holds the search input

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> donationPosts = [
      {'user_id': 'Kim Namjoon', 'itemName': 'Air Fryer', 'picture': 'https://via.placeholder.com/150', 'coin_value': 4},
      {'user_id': 'Lee Jieun', 'itemName': 'Microwave', 'picture': 'https://via.placeholder.com/150', 'coin_value': 5},
      // Add more items as needed
    ];

    // Filter posts based on search query
    List<Map<String, dynamic>> filteredPosts = donationPosts.where((post) {
      return post['itemName'].toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      drawer: FilterMenu(),
      appBar: CustomTopBar(onSearchChanged: _onSearchChanged), // Pass the search callback
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7,
          ),
          itemCount: filteredPosts.length, // Display filtered posts
          itemBuilder: (context, index) {
            final post = filteredPosts[index];
            return PostCard(
              user_id: post['user_id'],
              itemName: post['itemName'],
              picture: post['picture'],
              coin_value: post['coin_value'],
            );
          },
        ),
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