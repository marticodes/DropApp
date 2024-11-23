import 'package:flutter/material.dart';

class FilterMenu extends StatefulWidget {
  final Function(List<String>) onApplyFilters; // Callback to pass selected filters

  FilterMenu({required this.onApplyFilters});

  @override
  _FilterMenuState createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  Map<String, bool> categories = {
    "Books": false,
    "Clothing": false,
    "Decoration": false,
    "Electronics": false,
    "Food": false,
    "Health": false,
    "Kitchenware": false,
    "Linens": false,
    "Miscellaneous": false,
    "Sports": false,
    "Stationery": false,
    "Storage": false,
    "Vehicles": false,
  };

  final TextEditingController minController = TextEditingController();
  final TextEditingController maxController = TextEditingController();

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Function not implemented yet.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text("Category:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Wrap(
                    children: categories.keys.map((category) {
                      return Row(
                        children: [
                          Checkbox(
                            value: categories[category],
                            onChanged: (bool? value) {
                              setState(() {
                                categories[category] = value ?? true;
                              });
                            },
                          ),
                          Text(category),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Extract selected categories
                  List<String> selectedCategories = categories.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();

                  widget.onApplyFilters(selectedCategories);
                  Navigator.pop(context); // Close the drawer
                },
                child: Text(
                  "Filter Items",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 108, 106, 157),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}