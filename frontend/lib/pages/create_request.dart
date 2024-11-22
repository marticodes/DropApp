import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/models/sharing_post_model.dart';
import 'package:drop_app/tabs/share.dart';
import 'package:flutter/material.dart';
import 'package:drop_app/components/calendar.dart';
import 'package:drop_app/components/clock.dart';
import 'package:drop_app/pages/homepage.dart';


class Share extends StatefulWidget {
  const Share({super.key});

  @override
  State<Share> createState() => _ShareState();
}

Color purpleDrop = const Color.fromRGBO(108, 106, 157, 1);

class _ShareState extends State<Share> {
  String sproductName = '';
  String? sproductCategory;
  DateTime sproductStartDay = DateTime.now();
  TimeOfDay sproductStartShigan = TimeOfDay.now();
  DateTime sproductEndDay = DateTime.now();
  TimeOfDay sproductEndShigan = TimeOfDay.now();
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
                value: sproductCategory,
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
                    sproductCategory = value!;
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
                              date: sproductStartDay,
                              onDateChanged: (newDate) {
                                setState(() {
                                  sproductStartDay = newDate;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TimePickerComponent(
                              isFromTime: true,
                              time: sproductStartShigan,
                              onTimeChanged: (newTime) {
                                setState(() {
                                  sproductStartShigan = newTime!;
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
                              date: sproductEndDay,
                              onDateChanged: (newDate) {
                                setState(() {
                                  sproductEndDay = newDate;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TimePickerComponent(
                              isFromTime: false,
                              time: sproductEndShigan,
                              onTimeChanged: (newTime) {
                                setState(() {
                                  sproductEndShigan = newTime!;
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
                  DateTime combinedStart = DateTime(sproductStartDay.year,sproductStartDay.month, sproductStartDay.day,sproductStartShigan.hour,sproductStartShigan.minute,);
                  DateTime combinedEnd = DateTime(sproductStartDay.year,sproductStartDay.month, sproductStartDay.day,sproductStartShigan.hour,sproductStartShigan.minute,);

                  insertSharing(sproductName, sproductCategory, sproductDescription, combinedStart.toString(), combinedEnd.toString(),1, "New");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Home', initialTabIndex: 1), // Set the Profile tab index
                    ),
                  );
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