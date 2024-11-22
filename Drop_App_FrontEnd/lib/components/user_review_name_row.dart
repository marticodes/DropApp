import 'package:flutter/material.dart';
import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/models/user_model.dart';

class UserProfileRow extends StatelessWidget {
  final int userId;

  final serverUrl = 'http://143.248.198.42:3001/';

  const UserProfileRow({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: ApiService.fetchUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while data is being fetched
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Display an error message if fetching data fails
          return Container(
            padding: const EdgeInsets.all(10.0),
            color: const Color.fromARGB(255, 108, 106, 157),
            child: const Text(
              'Failed to load user data.',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Fallback if no data is available
          return Container(
            padding: const EdgeInsets.all(10.0),
            color: const Color.fromARGB(255, 108, 106, 157),
            child: const Text(
              'User not found.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        // Data has been successfully fetched
        final user = snapshot.data!;

        String userName = user.userName;
        String userSurname = user.userSurname;
        String userPicture = serverUrl + user.userPicture;
        String userLocation = user.userLocation ?? 'Unknown';
        int rating = user.userRating;

        return Container(
          color: const Color.fromARGB(255, 108, 106, 157),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 25,
                child: Image.network(
                userPicture, // Add your image in the assets folder and update pubspec.yaml
                height: 35,
              ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '$userName $userSurname',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.white, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              userLocation,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
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
              ),
            ],
          ),
        );
      },
    );
  }
}
