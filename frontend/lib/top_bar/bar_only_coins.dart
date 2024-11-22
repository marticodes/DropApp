import 'package:drop_app/api/api_service.dart'; 
import 'package:drop_app/models/user_model.dart'; 
import 'package:drop_app/global.dart' as globals;
import 'package:flutter/material.dart';

class BackTopBarr extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const BackTopBarr({Key? key})
      : preferredSize = const Size.fromHeight(64.0),
        super(key: key);

  @override
  _BackTopBarrState createState() => _BackTopBarrState();
}

class _BackTopBarrState extends State<BackTopBarr> {
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
      //leading: null, // Explicitly remove the back button
      leading: Container(),
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
