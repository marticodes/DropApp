import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  const RatingWidget({super.key, required Null Function() onPressed});

  @override
  RatingWidgetState createState() => RatingWidgetState();
}

class RatingWidgetState extends State<RatingWidget> {
  int _currentRating = 0; // Keeps track of the selected rating
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row with Icon and Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 251, 124, 45),
                  radius: 22,
                  child: CircleAvatar(
                    backgroundColor: Colors.yellow[700],
                    radius: 19,
                    child: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 234, 157, 42),
                      radius: 13,
                    ),
                  ),
                ),
                    const SizedBox(width: 8),
                    const Text(
                      "Quest completed!",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'inter',
                        color: Color.fromRGBO(84, 89, 94, 1)
                        // color: Color(),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 20,
                  height: 22,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom( // styling the button
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(0),
                            backgroundColor: const Color.fromARGB(255, 233, 233, 233)
                          ),
                    child: const Icon(Icons.close, size: 12,),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Award Message
            const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(width: 56),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Align text to the left
                    children: [
                      Text(
                        "You have been awarded 1 coin.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Rate the borrower:",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            // Star Rating Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _currentRating ? Icons.star : Icons.star_border,
                    color: index < _currentRating ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentRating = index + 1; // Update rating
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(108, 106, 157, 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
