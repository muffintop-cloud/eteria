import 'package:eteria/styles/app_colors.dart';
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

  List<MapEntry<int, Quest>> _mainQuests = [];
  List<MapEntry<int, Quest>> _sideQuests = [];
  List<MapEntry<int, Quest>> _dailyQuests = [];

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

    // organize the quests into 3 sections by category:
    _mainQuests = _quests
        .where((entry) => entry.value.category == QuestCategory.main)
        .toList();
    _sideQuests = _quests
        .where((entry) => entry.value.category == QuestCategory.side)
        .toList();
    _dailyQuests = _quests
        .where((entry) => entry.value.category == QuestCategory.daily)
        .toList();
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
              style: AppStyles.description,
            ),
          )
        else
          ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: _questSections(),
          ),

        // add quest button
        Positioned(
          right: AppStyles.mediumPadding,
          bottom: AppStyles.mediumPadding,
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppStyles.mediumRadius)),
              border: Border.all(
                color: AppColors.mainBrown,
                width: 1.5,
              ),
              boxShadow: AppStyles.panelShadow,
            ),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppStyles.mediumRadius)
              ),
              backgroundColor: AppColors.green,
              foregroundColor: AppColors.panel,
              onPressed: () {
                AddQuestDialog.show(context);
              },
              child: const Icon(Icons.add, size: 35),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _questSections() {
    List<Widget> widgets = [];

    // MAIN QUESTS
    if (_mainQuests.isNotEmpty) {
      widgets.add(_SectionHeader(title: 'MAIN QUESTS'));
      for (MapEntry<int, Quest> entry in _mainQuests) {
        widgets.add(_buildQuestTile(entry));
      }
    }

    // SIDE QUESTS
    if (_sideQuests.isNotEmpty) {
      widgets.add(_SectionHeader(title: 'SIDE QUESTS'));
      for (MapEntry<int, Quest> entry in _sideQuests) {
        widgets.add(_buildQuestTile(entry));
      }
    }

    // DAILY QUESTS
    if (_dailyQuests.isNotEmpty) {
      widgets.add(_SectionHeader(title: 'DAILY QUESTS'));
      for (MapEntry<int, Quest> entry in _dailyQuests) {
        widgets.add(_buildQuestTile(entry));
      }
    }
    return widgets;
  }

  Widget _buildQuestTile(MapEntry<int, Quest> entry) {
    int key = entry.key;
    Quest quest = entry.value;

    return QuestTile(
      quest: quest,
      onToggle: () {
        _toggleComplete(key);
      },
      onDelete: () {
        _deleteQuest(key);
      },
      onToggleObjective: (int objectiveIndex) {
        QuestService.toggleObjective(key, objectiveIndex);
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppStyles.mediumPadding,
        AppStyles.mediumPadding,
        AppStyles.mediumPadding,
        AppStyles.smallPadding,
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(title, style: AppStyles.titleMedium),
        ],
      ),
    );
  }
}
