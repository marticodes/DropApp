import 'package:flutter/material.dart';

class UserProfileRow extends StatelessWidget {
  final String userName;
  final int rating;
  final ImageProvider<Object>? profileImage;

  const UserProfileRow({
    Key? key,
    required this.userName,
    required this.rating,
    this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 108, 106, 157),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 25,
            backgroundImage: profileImage,
            child: profileImage == null
                ? Icon(Icons.person, color: Colors.white, size: 30)
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < rating ? Colors.amber : Colors.grey,
                    size: 20,
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
