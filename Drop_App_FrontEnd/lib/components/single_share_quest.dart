import 'package:flutter/material.dart';

class ShareQuestItem extends StatelessWidget {
  final String userName;
  final String itemName;
  final String itemDescription;
  final int coins;
  final String timeRemaining;
  final String date;

  const ShareQuestItem({
    required this.userName,
    required this.itemName,
    required this.itemDescription,
    required this.coins,
    required this.timeRemaining,
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         CircleAvatar(
                backgroundColor: Colors.blue, // Placeholder for user image color
                radius: 10,
                child: Center(
                  child: Text(
                    userName[0], // Use the first letter of the user name as avatar
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('$userName is looking for...',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(itemName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                Text('"$itemDescription"',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 251, 124, 45),
                    radius: 9,
                    child: CircleAvatar(
                      backgroundColor: Colors.yellow[700],
                      radius: 6,
                      child: const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 234, 157, 42),
                        radius: 3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('$coins'),
                ],
              ),
              const SizedBox(height: 5),
              Text(timeRemaining,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}