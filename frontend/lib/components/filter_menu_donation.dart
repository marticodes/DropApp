import 'package:flutter/material.dart';

class FilterMenu extends StatefulWidget {
  final Function(List<String>, int?, int?) onApplyFilters;

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
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 10),
                  Text("Coins:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minController,
                          decoration: InputDecoration(
                            labelText: "Min",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("—"),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: maxController,
                          decoration: InputDecoration(
                            labelText: "Max",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Extract selected categories and coin range
                  List<String> selectedCategories = categories.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();
                  int minCoins = int.tryParse(minController.text) ?? 1;
                  int maxCoins = int.tryParse(maxController.text) ?? 10;

                  widget.onApplyFilters(selectedCategories, minCoins, maxCoins);
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
