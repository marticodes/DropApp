import 'package:drop_app/models/sharing_post_model.dart';
import 'package:drop_app/models/user_model.dart';
import 'package:drop_app/pages/request_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShareQuestItem extends StatefulWidget {
 final SharingModel post;
 final Map<int, UserModel> userCache;
 const ShareQuestItem({super.key, required this.post, required this.userCache});

  @override
  ShareQuestItemState createState() => ShareQuestItemState();}
  
  class  ShareQuestItemState extends State< ShareQuestItem> {
  bool _isLoading = true;

    String formatDuration(Duration duration){
      int days = duration.inDays;
      int hours = duration.inHours % 24;
      int minutes = duration.inMinutes % 60;
      

      String result = '';
      if (days > 0) result += '$days day${days > 1 ? 's' : ''}';
      if (hours > 0) {
        if (result.isNotEmpty) result += ' and ';
        result += '$hours hour${hours > 1 ? 's' : ''}';
      }
      if (minutes > 0 && days == 0) { // Only show minutes if less than a day
        if (result.isNotEmpty) result += ' and ';
        result += '$minutes minute${minutes > 1 ? 's' : ''}';
      }

      return result.isNotEmpty ? result : 'Less than a minute';
    }

    UserModel usery = UserModel(userId: 3, userName: 'Conan', userSurname: 'Gray', userCardNum: 20200888, coinsNum: 9, userPicture: 'userPicture', userRating: 5, userLocation: 'Areum Hall', userGraduated: 0, hash: '123', salt: '123', active: 1, numRev: 2);
  
  @override
  Widget build(BuildContext context) {
    SharingModel sharepost = widget.post;
    int borrowerID = widget.post.borrowerID;
    UserModel user = widget.userCache[borrowerID]?? usery;
    String pickDate = DateFormat('d MMM').format(DateTime.parse(sharepost.sproductStartTime));
    DateTime endTime = DateTime.parse(sharepost.sproductEndTime);
    DateTime startTime = DateTime.parse(sharepost.sproductStartTime);
    String duration = formatDuration(endTime.difference(startTime));

    return GestureDetector(
      onTap: () {
        // Navigate to the placeholder page on tap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ShareDetailPage(post:widget.post, user:user)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           ClipOval(
  child: Image.network(
    user.userPicture!,
    width: 25,
    height: 25,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        // Image has finished loading
        return child;
      } else {
        // Show a loading indicator
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        );
      }
    },
    errorBuilder: (context, error, stackTrace) {
      // Fallback for when the image fails to load
      return const Icon(
        Icons.person,
        size: 25,
        color: Colors.grey,
      );
    },
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
                      Text('${user.userName} is looking for...',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(sharepost.sproductName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('"${sharepost.sproductDescription}"',
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
                    Text('${sharepost.coinValue}'),
                  ],
                ),
                const SizedBox(height: 5),
                Text("When: ${pickDate}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text("For: ${duration}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}