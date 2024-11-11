import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("User Profile"),
        backgroundColor: const Color.fromARGB(255, 108, 106, 157),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User Profile Information",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Here you can display the user's profile information."),
            // You can add more widgets like user name, email, and selected categories here
          ],
        ),
      ),
    );
  }
}