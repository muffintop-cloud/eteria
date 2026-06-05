import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:eteria/models/quest.dart';
import 'package:eteria/services/quest_service.dart';
import 'package:eteria/widgets/add_quest_dialog.dart';
import 'package:eteria/widgets/quest_tile.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});

  @override
  State<QuestsScreen> createState() {
    return _QuestsScreenState();
  }
}

class _QuestsScreenState extends State<QuestsScreen> {
  List<MapEntry<int, Quest>> _quests = []; // list of all quests stored in hive

  @override
  void initState() {
    super.initState();
    _loadQuests();
    QuestService.notifier.addListener(_loadQuests);
  }

  @override
  void dispose() {
    QuestService.notifier.removeListener(_loadQuests);
    super.dispose();
  }

  void _loadQuests() {
    if (!mounted) return;
    setState(() {
      _quests = QuestService.getAllQuests();
    });
  } // reads quests from hive, stores them in quests, setState rebuilds so the list of quests shows on screen

  Future<void> _toggleComplete(int key) async {
    await QuestService.toggleComplete(key);
  } // makes a quest toggle-able

  Future<void> _deleteQuest(int key) async {
    await QuestService.deleteQuest(key);
  } // delete quest

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_quests.isEmpty)
          const Center(
            child: Text(
              'No quests yet.\nTap + to add one.',
              textAlign: TextAlign.center,
              style: AppStyles.description),
          )
        else 
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: _quests.length,
            itemBuilder: (context, index) {
              int key = _quests[index].key;
              Quest quest = _quests[index].value;

              return QuestTile(
                quest: quest,
                onToggle: () { _toggleComplete(key); },
                onDelete: () { _deleteQuest(key); },
                onToggleObjective: (int objectiveIndex) {
                  QuestService.toggleObjective(key, objectiveIndex);
                },
              );
            },
          ),
        
        // add quest button
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () {
              AddQuestDialog.show(context); },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}