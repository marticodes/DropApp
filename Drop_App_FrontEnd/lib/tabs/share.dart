import 'package:flutter/material.dart';
import 'package:drop_app/components/single_share_quest.dart';

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
    return ListView.builder(
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
    );
  }
}
