import 'package:flutter/material.dart';
import 'package:drop_app/top_bar/top_bar_search.dart'; 
import 'package:drop_app/elements/filter_menu_donation.dart'; 
//import 'package:drop_app/top_bar_go_back.dart';
import 'package:drop_app/elements/donation_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _searchQuery = ''; // Holds the search input

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}