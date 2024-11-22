import 'package:flutter/material.dart';
import 'package:drop_app/tabs/profile.dart'; // Import the UserProfilePage

class CategorySelectionPage extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  final List<String> categories = [
    'Books',
    'Clothing',
    'Decoration',
    'Electronics',
    'Food',
    'Health',
    'Kitchenware',
    'Linens',
    'Miscellaneous',
    'Sports',
    'Stationery',
    'Storage',
    'Vehicles',
  ];

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Select Categories"),
        backgroundColor: const Color.fromARGB(255, 108, 106, 157),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Categories You Are Interested In. You will be notified if someone is looking to borrow an item in one of these categories.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Wrap(
                spacing: 10.0,  // Horizontal space between items
                runSpacing: -6.0, // Adjust this for vertical spacing
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: selectedCategories.contains(category),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      },
                      selectedColor: const Color.fromARGB(255, 154, 153, 194),
                      backgroundColor: const Color.fromARGB(255, 242, 238, 238),
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedCategories.isNotEmpty) {
                  // Navigate to User Profile Page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfilePage()), //we cannot change this because this page is also used for SignIn
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select at least one category')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 108, 106, 157),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Done',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}