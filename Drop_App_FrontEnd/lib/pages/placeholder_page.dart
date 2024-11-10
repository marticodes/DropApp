import 'package:flutter/material.dart';
import 'package:drop_app/top_bar/top_bar_go_back.dart';

class PlaceholderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackTopBar(),
      body: Center(
        child: Text(
          'This is the placeholder for item details.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}