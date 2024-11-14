import 'package:flutter/material.dart';
import 'package:drop_app/components/filter_menu_donation.dart';

class CustomTopBar extends StatefulWidget implements PreferredSizeWidget {
  final int moneyCount;
  final Function(String) onSearchChanged;

  @override
  final Size preferredSize;

  CustomTopBar({Key? key, this.moneyCount = 7, required this.onSearchChanged}) 
      : preferredSize = const Size.fromHeight(64.0),
        super(key: key);

  @override
  _CustomTopBarState createState() => _CustomTopBarState();
}

class _CustomTopBarState extends State<CustomTopBar> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        widget.onSearchChanged(''); // Clear search when search mode is off
      }
    });
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
            InkWell(
              onTap: () {
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
                      onChanged: widget.onSearchChanged,
                    )
                  : InkWell(
                      onTap: _toggleSearch, // Toggle search mode when tapping the text
                      child: Text(
                        'Search Item',
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ),
            ),
            InkWell(
              onTap: _toggleSearch, // Toggle search mode when tapping the search icon
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
              '${widget.moneyCount}',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}
