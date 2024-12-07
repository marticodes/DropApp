import 'package:drop_app/api/api_service.dart'; 
import 'package:drop_app/models/user_model.dart'; 
import 'package:drop_app/global.dart' as globals;
import 'package:flutter/material.dart';

class BackTopBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const BackTopBar({Key? key})
      : preferredSize = const Size.fromHeight(64.0),
        super(key: key);

  @override
  BackTopBarState createState() => BackTopBarState();
}

class BackTopBarState extends State<BackTopBar> {
  int? _moneyCount;

  @override
  void initState() {
    super.initState();
    _fetchUserCoins(); // Fetch coins when the app bar is initialized
  }

  Future<void> _fetchUserCoins() async {
    try {
      final user = await ApiService.fetchUserById(globals.userData);
      setState(() {
        _moneyCount = user.coinsNum; // Update the coin count
      });
    } catch (error) {
      setState(() {
        _moneyCount = 0; // Fallback to 0 on error
      });
      debugPrint('Error fetching user coins: $error');
    }
  }

  // New method to refresh the coin count
  void refreshCoins() {
    _fetchUserCoins(); // Call the existing method to fetch coins
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 30, 30, 30)),
        onPressed: () {
          Navigator.of(context).pop(); // Go back to the previous page
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
              _moneyCount == null ? '...' : '$_moneyCount', // Show '...' while loading
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}
