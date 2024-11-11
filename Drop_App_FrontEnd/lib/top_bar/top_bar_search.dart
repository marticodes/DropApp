import 'package:flutter/material.dart';
import 'package:drop_app/filter_menu.dart';

class CustomTopBar extends StatefulWidget implements PreferredSizeWidget {
  final int moneyCount;

  @override
  final Size preferredSize;

  CustomTopBar({Key? key, this.moneyCount = 7}) // Set default to 7 for now
      : preferredSize = const Size.fromHeight(64.0),
        super(key: key);

  @override
  _CustomTopBarState createState() => _CustomTopBarState();
}

class _CustomTopBarState extends State<CustomTopBar> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

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
            // The menu icon is used to open the drawer
            InkWell(
              onTap: () {
                // Open the drawer when the menu icon is tapped
                Scaffold.of(context).openDrawer();
              },
              child: Icon(Icons.menu, color: Colors.grey[700]),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search Item...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        // Optionally trigger search when user presses enter
                        print("Search query: $value");
                      },
                    )
                  : Text(
                      'Search Item',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear(); // Clear text when switching back
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
              '${widget.moneyCount}', // Use the dynamic value here
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}

