import 'package:flutter/material.dart';
import 'package:drop_app/pages/category_selection_page.dart';
//import 'package:drop_app/top_bar/top_bar_go_back.dart';
import 'package:drop_app/top_bar/bar_only_coins.dart';

class UserProfilePage extends StatelessWidget {
  final String name = "Erika";
  final String surname = "Astigiano";
  final String studentID = "20246475";
  final String profileImageUrl =
      "https://via.placeholder.com/150"; // Placeholder profile image URL
  final int rating = 4; //this is the number of starts that has to be implemented (lets round the number to the biggest full integer)
  //this is the number of yellow starts to come out
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackTopBarr(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            SizedBox(height: 20),
            
            // User Information
            Text(
              "$name $surname",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Student ID: $studentID",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Rating = ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < rating ? Colors.amber : Colors.grey,
                    size: 20,
                  );
                }),
              ],
            ),
            SizedBox(height: 30),
            // Change Selected Categories Button (at the top)
            ElevatedButton(
              onPressed: () {
                // Navigate to CategorySelectionPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategorySelectionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 108, 106, 157),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Change Selected Categories',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 15),
            // Change Password Button (at the bottom)
            ElevatedButton(
              onPressed: () {
                // Button does nothing currently
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Change Password function not implemented.")),  //NOT IMPLEMENTED
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 108, 106, 157),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            Spacer(), // Adds space to push the next button down
            // Log Out Button (at the end of the page)
            ElevatedButton(
              onPressed: () {
                // Log out action (navigate back to the login screen or main page)
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 241, 138, 138),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}