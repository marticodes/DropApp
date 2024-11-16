import 'package:flutter/material.dart';
import 'package:drop_app/components/rating.dart';


class MessageWidget extends StatelessWidget {
  final String message;
  final bool isConfirmed;
  final VoidCallback onConfirm;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.isConfirmed,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(message),
      trailing: isConfirmed
          ? ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => RatingPopup(),
              ),
              child: Text("Returned"),
            )
          : ElevatedButton(
              onPressed: onConfirm,
              child: Text("Confirm"),
            ),
    );
  }
}
