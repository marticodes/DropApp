import 'package:flutter/material.dart';
import 'package:drop_app/top_bar/top_bar_go_back.dart';
import 'package:drop_app/components/user_review_name_row.dart';

class ItemDetailPage extends StatelessWidget {
  final int rating = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackTopBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Using the UserProfileRow widget
          UserProfileRow(
            userName: 'Sabrina Millies', // Change the name as needed
            rating: rating,
          ),

          // Item image
          Image.asset(
            'lib/testpic/Soup_Spoon.jpg', // Path to your image
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),

          // Item details section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Spoon', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                        Text('Kitchenware', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 251, 124, 45),
                          radius: 16.5,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow[700],
                            radius: 14.5,
                            child: CircleAvatar(
                              backgroundColor: const Color.fromARGB(255, 234, 157, 42),
                              radius: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 100),
                        Text('1 Coin', style: TextStyle(fontSize: 16, color: Colors.yellow[700], fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('Item Condition', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                Text('Good', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Description', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                Text(
                  'Bought it from Homeplus a couple of years ago. Have used it at least once a week but has no stains.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),

          Spacer(),

          // Chat button above the navigation bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 108, 106, 157), 
                foregroundColor: Colors.white, 
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {}, //ADD HERE
              child: Center(child: Text('Chat', style: TextStyle(fontSize: 18))),
            ),
          ),

          SizedBox(height: 10), // Space between Chat button and NavBar

          // Navigation bar
          BackTopBar(),
        ],
      ),
    );
  }
}
