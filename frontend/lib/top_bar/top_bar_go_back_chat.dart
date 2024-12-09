import 'package:drop_app/pages/homepage.dart';
import 'package:drop_app/tabs/chat.dart';
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
  _BackTopBarrState createState() => _BackTopBarrState();
}

class _BackTopBarrState extends State<BackTopBar> {
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
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(
        title: 'Home',
        initialTabIndex: 2, // Set the Profile tab index
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0); // Start from the left
        const end = Offset.zero;         // End at the current position
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200), // Shorter animation duration

    ),
  );
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
              '$_moneyCount', // Display the money count
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}