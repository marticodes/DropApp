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
  String itemName = '';
  String? category;
  DateTime? fromDate;
  TimeOfDay? fromTime;
  DateTime? untilDate;
  TimeOfDay? untilTime;
  String description = '';

  final List<String> categoryList = ['Books', 'Clothing', 'Decoration', 'Electronics', 'Food', 'Health', 'Kitchenware', 'Linens', 'Miscellaneous', 'Sports', 'Stationery', 'Storage', 'Vehicles'];

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
                              date: fromDate,
                              onDateChanged: (newDate) {
                                setState(() {
                                  fromDate = newDate;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TimePickerComponent(
                              isFromTime: true,
                              time: fromTime,
                              onTimeChanged: (newTime) {
                                setState(() {
                                  fromTime = newTime;
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
                              date: untilDate,
                              onDateChanged: (newDate) {
                                setState(() {
                                  untilDate = newDate;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TimePickerComponent(
                              isFromTime: false,
                              time: untilTime,
                              onTimeChanged: (newTime) {
                                setState(() {
                                  untilTime = newTime;
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
