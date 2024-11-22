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
  _BackTopBarState createState() => _BackTopBarState();
}

class _BackTopBarState extends State<BackTopBar> {
  int? _moneyCount; // To store the coinsNum value

  @override
  void initState() {
    super.initState();
    _fetchUserCoins(); // Fetch coins when the widget initializes
  }

  Future<void> _fetchUserCoins() async {
    try {
      final user = await ApiService.fetchUserById(globals.userData); // Fetch user data
      setState(() {
        _moneyCount = user.coinsNum; // Update the state with fetched coinsNum
      });
    } catch (error) {
      setState(() {
        _moneyCount = 0; // Fallback to 0 on error
      });
      debugPrint('Error fetching user coins: $error');
    }
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