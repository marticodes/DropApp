import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/models/sharing_post_model.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/components/calendar.dart';
import 'package:drop_app/components/clock.dart';


class Share extends StatefulWidget {
  const Share({super.key});

  @override
  State<Share> createState() => _ShareState();
}

Color purpleDrop = const Color.fromRGBO(108, 106, 157, 1);

class _ShareState extends State<Share> {
  String sproductName = '';
  String? sproducCategory;
  DateTime? sproductStartDate;
  TimeOfDay? sproductStartTime;
  DateTime? sproductEndDate;
  TimeOfDay? sproductEndTime;
  String sproductDescription = '';

  final List<String> categoryList = ['Books', 'Clothing', 'Decoration', 'Electronics', 'Food', 'Health', 'Kitchenware', 'Linens', 'Miscellaneous', 'Sports', 'Stationery', 'Storage', 'Vehicles'];

  Future<void> insertSharing(sproductName,
        sproducCategory,
        sproductDescription,
        sproductStartTime,
        sproductEndTime,
        borrowerId,
        status) async {
      int productId = await ApiService.insertSharing(
        sproductName,
        sproducCategory,
        sproductDescription,
        sproductStartTime,
        sproductEndTime,
        borrowerId,
        status
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sharing inserted! Product ID: $productId')),
      );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Sharing Quest"),
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
                    sproductName = value;
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
                value: sproducCategory,
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
                    sproducCategory = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // From Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getLabel("From"),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: CalendarComponent(
                              isFromDate: true,
                              date: sproductStartDate,
                              onDateChanged: (newDate) {
                                setState(() {
                                  sproductStartDate = newDate;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TimePickerComponent(
                              isFromTime: true,
                              time: sproductStartTime,
                              onTimeChanged: (newTime) {
                                setState(() {
                                  sproductStartTime = newTime;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Until Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getLabel("Until"),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: CalendarComponent(
                              isFromDate: false,
                              date: sproductEndDate,
                              onDateChanged: (newDate) {
                                setState(() {
                                  sproductEndDate = newDate;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TimePickerComponent(
                              isFromTime: false,
                              time: sproductEndTime,
                              onTimeChanged: (newTime) {
                                setState(() {
                                  sproductEndTime = newTime;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Description Part
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
                  sproductDescription = value;
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

                  insertSharing(sproductName, sproducCategory, sproductDescription, ' ', ' ',1, 1);
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