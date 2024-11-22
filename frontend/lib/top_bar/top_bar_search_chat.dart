//the only different is that this one has no filter working
import 'package:drop_app/api/api_service.dart'; 
import 'package:drop_app/models/user_model.dart'; 
import 'package:drop_app/global.dart' as globals;
import 'package:flutter/material.dart';

class CustomTopBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSearchChanged; // Callback for search input changes

  @override
  final Size preferredSize;

  const CustomTopBar({Key? key, required this.onSearchChanged})
      : preferredSize = const Size.fromHeight(64.0),
        super(key: key);

  @override
  _CustomTopBarState createState() => _CustomTopBarState();
}

class _CustomTopBarState extends State<CustomTopBar> {
  bool _isSearching = false;
  int? _moneyCount; // To store the coinsNum value
  TextEditingController _searchController = TextEditingController();

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
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Container(
        height: 45.0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(250, 245, 246, 248),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search Chat...',
                        border: InputBorder.none,
                      ),
                      onChanged: widget.onSearchChanged, // Trigger callback on text change
                    )
                  : Text(
                      'Search Chat',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    widget.onSearchChanged(''); // Clear search when search mode is off
                  }
                });
              },
              child: Icon(Icons.search, color: Colors.grey[700]),
            ),
          ],
        ),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}