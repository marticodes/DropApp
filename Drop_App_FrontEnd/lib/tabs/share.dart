import 'package:flutter/material.dart';
import 'package:drop_app/components/single_share_quest.dart';
import 'package:drop_app/top_bar/top_bar_search.dart';
import 'package:drop_app/top_bar/top_bar_go_back.dart';

class ShareQuest {
  final String userName;
  final String itemName;
  final String itemDescription;
  final int coins;
  final String timeRemaining;
  final String date;

  ShareQuest({
    required this.userName,
    required this.itemName,
    required this.itemDescription,
    required this.coins,
    required this.timeRemaining,
    required this.date,
  });
}

class ShareQuestList extends StatelessWidget {
  final List<ShareQuest> shareQuests;

  const ShareQuestList({required this.shareQuests, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackTopBar(), // MUST CHANGE THIS TO SEARCH BAR INSTEAD OF BACKTOPBAR 
      //the issue why i cant use the normal search bar is that share quests are not widget but list
      //to make the search bar to work the seatchquestlist has to become a widget (CHECK HOW I DID FOR DONATION)
      body: ListView.builder(
        itemCount: shareQuests.length,
        itemBuilder: (context, index) {
          final quest = shareQuests[index];
          return ShareQuestItem(
            userName: quest.userName,
            itemName: quest.itemName,
            itemDescription: quest.itemDescription,
            coins: quest.coins,
            timeRemaining: quest.timeRemaining,
            date: quest.date,
          );
        },
      ),
    );
  }
}