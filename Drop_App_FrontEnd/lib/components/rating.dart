import 'package:flutter/material.dart';


class RatingPopup extends StatefulWidget {
  @override
  _RatingPopupState createState() => _RatingPopupState();
}

class _RatingPopupState extends State<RatingPopup> {
  double rating = 3.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Rate this return"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Select a rating:"),
          Slider(
            value: rating,
            min: 1.0,
            max: 5.0,
            divisions: 4,
            label: rating.toString(),
            onChanged: (value) {
              setState(() {
                rating = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Close the popup
            Navigator.of(context).pop();
          },
          child: Text("Close"),
        ),
      ],
    );
  }
}
