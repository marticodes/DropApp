import 'package:drop_app/api/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Donate extends StatefulWidget {
  const Donate({super.key});

  @override
  State<Donate> createState() => _DonateState();
}

Color purpleDrop = const Color.fromRGBO(108, 106, 157, 1);

class _DonateState extends State<Donate> {
  String productName = '';
  String? productCategory;
  String? status;
  String productDescription = '';
  String productPicture = '';
  int donorId = 1; // Example donor ID, replace with actual value in production

  final List<String> categoryList = [
    'Books', 'Clothing', 'Decoration', 'Electronics', 'Food', 'Health',
    'Kitchenware', 'Linens', 'Miscellaneous', 'Sports', 'Stationery',
    'Storage', 'Vehicles',
  ];

  final List<String> conditionList = ['New', 'Good conditions', 'Used'];

  Future<void> insertDonation(
    String productName,
    String productDescription,
    String? productCategory,
    String productPicture,
    int donorId,
    String? status,
  ) async {
    if (productName.isEmpty || productCategory == null || status == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    try {
      int productId = await ApiService.insertDonation(
        productName,
        productDescription,
        productCategory,
        productPicture,
        donorId,
        status,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Donation inserted successfully!')),
      );

      Navigator.pop(context); // Navigate back after successful insertion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

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
              onChanged: (value) => productName = value,
              ),
            ),
            const SizedBox(height: 10),

          // Category
          getLabel("Category"),
          const SizedBox(height: 5),
          SizedBox(
            width: 200,  // Set width to 200
            child: DropdownButtonFormField<String>(
              value: productCategory,
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
              onChanged: (value) => setState(() {
                productCategory = value;
              }),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 10),

          // Item Condition
          getLabel("Item Condition"),
          const SizedBox(height: 5),
          SizedBox(
            width: 200,  // Set width to 200
            child: DropdownButtonFormField<String>(
              value: status,
              hint: Text('Select Condition', style: hintTextStyle),
              items: conditionList.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => setState(() {
                status = value;
              }),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 10),


            
        // Add Image
        getLabel("Add Image"),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            // final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
            // if (pickedImage != null) {
            //   setState(() {
            //     image = pickedImage;
            //   });
            // }
          },
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Center(
              child: Text(
                "Image uploading not available yet",
                style: TextStyle(
                  color: Colors.grey, 
                  fontSize: 16,        
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center, 
              ),
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
              onChanged: (value) => productDescription = value,
            ),
            const SizedBox(height: 15),

            // Post Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: purpleDrop,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                ),
                onPressed: () {
                  insertDonation(productName, productDescription, productCategory, productPicture, donorId, status);
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

