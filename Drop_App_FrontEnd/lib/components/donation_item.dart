import 'package:flutter/material.dart';
import 'package:drop_app/models/donation_post_model.dart';
import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/models/user_model.dart';

class PostCard extends StatelessWidget {
  final DonationModel item;

  const PostCard({Key? key, required this.item}) : super(key: key);

  Future<UserModel> _fetchUser() async {
    return await ApiService.fetchUserById(item.donorId);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.grey[400],
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 6),
                FutureBuilder<UserModel>(
                  future: _fetchUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Loading...',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Unknown User',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      );
                    } else if (snapshot.hasData) {
                      final user = snapshot.data!;
                      return Text(
                        '${user.userName} ${user.userSurname}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      );
                    } else {
                      return Text(
                        'Unknown User',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
            child: Image.network(
              item.productPicture,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 251, 124, 45),
                      radius: 7.5,
                      child: CircleAvatar(
                        backgroundColor: Colors.yellow[700],
                        radius: 6.5,
                        child: CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 234, 157, 42),
                          radius: 4.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.coinValue}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

