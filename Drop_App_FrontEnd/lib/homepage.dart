import 'package:flutter/material.dart';
import 'package:drop_app/top_bar/top_bar_search.dart'; 
import 'package:drop_app/filter_menu.dart'; 
//import 'package:drop_app/top_bar_go_back.dart';
import 'package:drop_app/donation_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: FilterMenu(),
      appBar: CustomTopBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7, // Adjusts the height of each card
          ),
          itemCount: 5, // Number of items to display
          itemBuilder: (context, index) {
            return PostCard(
              user_id: 'Kim Namjoon',
              itemName: 'Air Fryer',
              picture: 'https://via.placeholder.com/150', // Replace with actual image URL
              coin_value: 4,
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