import 'package:flutter/material.dart';

class BackTopBar extends StatelessWidget implements PreferredSizeWidget {
  final int moneyCount;

  @override
  final Size preferredSize;

  BackTopBar({Key? key, this.moneyCount = 7})
      : preferredSize = const Size.fromHeight(64.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 30, 30, 30)),
        onPressed: () {
          GO BACK TO CHAT PAGE; // CHANGE THIS
        },
      ),
      actions: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 251, 124, 45),
              radius: 11,
              child: CircleAvatar(
                backgroundColor: Colors.yellow[700],
                radius: 9.5,
                child: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 234, 157, 42),
                  radius: 6.5,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$moneyCount', // Display the money count
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}
