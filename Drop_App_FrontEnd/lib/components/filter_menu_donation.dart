import 'package:flutter/material.dart';

class FilterMenu extends StatefulWidget {
  @override
  _FilterMenuState createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  // State for categories checkboxes
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

  // Controllers for the min and max coin range
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
                    spacing: 0, // Horizontal space between items
                    runSpacing: -12, // Adjust this for vertical spacing
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
                  TextButton(
                    onPressed: () {
                      setState(() {
                        categories.updateAll((key, value) => false);
                      });
                    },
                    child: Text("Uncheck All"),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 1),
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
                          decoration: InputDecoration(    //Min 0 e Max 10
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
              width: double.infinity, // Makes the button take full width of the drawer
              child: ElevatedButton(
                onPressed: () {
                  print("Filter items with selected options");
                  Navigator.pop(context); // Close the drawer
                },
                child: Text(
                  "Filter Items",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 108, 106, 157),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // BORDER RADIUS
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

