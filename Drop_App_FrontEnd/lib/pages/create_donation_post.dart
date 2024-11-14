import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Donate extends StatefulWidget {
  const Donate({super.key});

  @override
  State<Donate> createState() => _DonateState();
}

Color purpleDrop = const Color.fromRGBO(108, 106, 157, 1);

class _DonateState extends State<Donate> {
  String itemName = '';
  String? category;
  String? condition;
  String description = '';
  XFile? image;
  int coinValue = 0;

  final List<String> categoryList = ['Books', 'Clothing', 'Decoration', 'Electronics', 'Food', 'Health', 'Kitchenware', 'Linens', 'Miscellaneous', 'Sports', 'Stationery', 'Storage', 'Vehicles'];
  final List<String> conditionList = ['New', 'Good', 'Fair', 'Poor'];

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Donation Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Name
            getLabel("Item Name"),
            const SizedBox(height: 5),
            SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Item Name',
                  hintStyle: hintTextStyle,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    itemName = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 15),

            // Category
            getLabel("Category"),
            const SizedBox(height: 5),
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                value: category,
                hint: Text(
                  'Select Category',
                  style: hintTextStyle,
                ),
                items: categoryList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    category = value;
                    calculateCoinValue();
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Item Condition
            getLabel("Item Condition"),
            const SizedBox(height: 5),
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                value: condition,
                hint: Text(
                  'Select Condition',
                  style: hintTextStyle,
                ),
                items: conditionList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    condition = value;
                    calculateCoinValue();
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Calculated Coin Value
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getLabel("Calculated coin value:"),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.amber),
                    Text(
                      coinValue.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Add Image
            getLabel("Add Image"),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () async {
                final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    image = pickedImage;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                          Text("Click to add image from Gallery"),
                        ],
                      )
                    : Image.file(
                        File(image!.path),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 15),

            // Description
            getLabel("Description"),
            const SizedBox(height: 5),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter any specification of item',
                hintStyle: hintTextStyle,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Post Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: purpleDrop,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                ),
                onPressed: () {
                  // Handle post action
                },
                child: const Text(
                  "Post",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateCoinValue() {
    // Logic to calculate coin value based on category and condition
    setState(() {
      coinValue = (category != null ? 10 : 0) + (condition != null ? 5 : 0); // Example calculation
    });
  }
}

Text getLabel(String labelName) {
  return Text(
    labelName,
    style: const TextStyle(
      fontSize: 16, 
      fontWeight: FontWeight.w500, 
      fontFamily: 'Roboto', 
      color: Colors.black,
    ),
  );
}

TextStyle hintTextStyle = const TextStyle(
  fontSize: 16, 
  fontWeight: FontWeight.normal, 
  fontFamily: 'Roboto', 
  color: Color.fromARGB(255, 148, 147, 147),
);
