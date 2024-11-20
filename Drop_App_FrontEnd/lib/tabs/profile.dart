// import 'package:drop_app/api/api_service.dart';
// import 'package:drop_app/models/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:drop_app/pages/category_selection_page.dart';
// import 'package:drop_app/top_bar/top_bar_go_back.dart';

// class UserProfilePage extends StatefulWidget {
//   const UserProfilePage({super.key});

//   @override
//   UserProfilePageState createState() => UserProfilePageState();
// }

// class UserProfilePageState extends State<UserProfilePage> {
//   late final UserModel user;
//   @override
//   void initState() {
//     super.initState();
//     fetchUserById(id); 
//   }

//   Future<void> fetchUserById(int id) async {
//       // Call your API function to get the active sharing posts
//       UserModel posts = await ApiService.fetchUserById(id);   
//       setState(() {
//         user=posts; // Add fetched posts to the list
//       });
//   }


//   // final String name = "John";
//   // final String surname = "Doe";
//   // final String studentID = "20234567";
//   // final String profileImageUrl =
//   //     "https://via.placeholder.com/150"; // Placeholder profile image URL
//   // final int rating = 4; //this is the number of starts that has to be implemented (lets round the number to the biggest full integer)
//   //this is the number of yellow starts to come out

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BackTopBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Profile Image
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: NetworkImage(user.userPicture),
//             ),
//             SizedBox(height: 20),
            
//             // User Information
//             Text(
//               "$user.userName",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               "Student ID: $user.userId",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 4),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Rating = ",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 ...List.generate(5, (index) {
//                   return Icon(
//                     Icons.star,
//                     color: index < user.userRating ? Colors.amber : Colors.grey,
//                     size: 20,
//                   );
//                 }),
//               ],
//             ),
//             SizedBox(height: 30),

//             // Change Selected Categories Button (at the top)
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate to CategorySelectionPage
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CategorySelectionPage()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 108, 106, 157),
//                 minimumSize: Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text(
//                 'Change Selected Categories',
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//               ),
//             ),
//             SizedBox(height: 15),
//             // Change Password Button (at the bottom)
//             ElevatedButton(
//               onPressed: () {
//                 // Button does nothing currently
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Change Password function not implemented.")),  //NOT IMPLEMENTED
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 108, 106, 157),
//                 minimumSize: Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text(
//                 'Change Password',
//                 style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255)),
//               ),
//             ),
//             Spacer(), // Adds space to push the next button down
//             // Log Out Button (at the end of the page)
//             ElevatedButton(
//               onPressed: () {
//                 // Log out action (navigate back to the login screen or main page)
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 241, 138, 138),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text(
//                 'Log Out',
//                 style: TextStyle(fontSize: 14, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }