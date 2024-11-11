import 'package:flutter/material.dart';
import 'package:drop_app/homepage.dart'; // Import the HomePage here

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
    'Vehicles'
  ];

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Name',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 230, 229, 246),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Surname',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 230, 229, 246),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.school),
                  hintText: 'Student ID',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 230, 229, 246),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  final result = await showDialog<List<String>>(
                    context: context,
                    builder: (BuildContext context) {
                      return MultiSelectDialog(
                        categories: categories,
                        initiallySelected: selectedCategories,
                      );
                    },
                  );

                  if (result != null) {
                    setState(() {
                      selectedCategories = result;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 230, 229, 246),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.category),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedCategories.isEmpty
                              ? "What object would you share?"
                              : selectedCategories.join(", "),
                          style: TextStyle(color: const Color.fromARGB(255, 27, 27, 27)),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Password',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 230, 229, 246),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: 'Confirm Password',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 230, 229, 246),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedCategories.isNotEmpty) {
                    // Navigate to HomePage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    // Show error if no categories are selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select at least one category"),
                      ),
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
                  'Sign up',
                  style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> categories;
  final List<String> initiallySelected;

  MultiSelectDialog({required this.categories, required this.initiallySelected});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> tempSelected;

  @override
  void initState() {
    super.initState();
    tempSelected = List.from(widget.initiallySelected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Categories"),
      content: SingleChildScrollView(
        child: Column(
          children: widget.categories.map((category) {
            return CheckboxListTile(
              title: Text(category),
              value: tempSelected.contains(category),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    tempSelected.add(category);
                  } else {
                    tempSelected.remove(category);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context, tempSelected);
          },
        ),
      ],
    );
  }
}