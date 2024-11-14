import 'package:flutter/material.dart';
//import 'package:drop_app/pages/placeholder_page.dart';
import 'package:drop_app/pages/page_item_donation.dart';

class PostCard extends StatelessWidget {
  final String user_id;
  final String itemName;
  final String picture;
  final int coin_value;

  const PostCard({
    Key? key,
    required this.user_id,
    required this.itemName,
    required this.picture,
    required this.coin_value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the placeholder page on tap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ItemDetailPage()),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0), //no curcular
        ),
        elevation: 0,  //should we add elevation?
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
                    child: Icon(Icons.person, color: Colors.white), //CHANGE THIS WITH USER_ID.PICTURE
                  ),
                  const SizedBox(width: 6),
                  Text(
                    user_id,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: Image.network(
                picture,
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
                    itemName,
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
                        '$coin_value',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
