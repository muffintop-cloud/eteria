import 'package:eteria/models/quest.dart';
import 'package:eteria/models/skill.dart';
import 'package:eteria/services/quest_service.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';

class AddQuestDialog extends StatefulWidget {
  const AddQuestDialog({super.key});
  
  static Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (context){
      return const AddQuestDialog();
    });
  } // allows AddQuestDialog.show(context) in quests_screen

  @override
  State<AddQuestDialog> createState() {
    return _AddQuestDialogState();
  }
}

class _AddQuestDialogState extends State<AddQuestDialog> {
  final TextEditingController _titleController = TextEditingController();

  Difficulty _difficulty = Difficulty.low;
  QuestCategory _category = QuestCategory.side;
  DateTime? _deadline;

  final Set<Skill> _selectedSkills = {}; // set prevents duplicates
  final List<TextEditingController> _objectiveControllers = [];

  @override
  void dispose(){
    _titleController.dispose();
    for (TextEditingController x in _objectiveControllers) { x.dispose(); }
    super.dispose();
  }

  // submit
  Future<void> _submit() async {
    String title = _titleController.text.trim();
    if (title.isEmpty) { return; } // can't save a quest without a title
    
    List<String> objectives = [];
    for (TextEditingController x in _objectiveControllers) {
      String text = x.text.trim();
      if (text.isNotEmpty) {
        objectives.add(text);
      }
    } // collect non empty objective texts

    Navigator.of(context).pop(); // close the dialog

    await QuestService.addQuest(
      title: title,
      difficulty: _difficulty,
      category: _category,
      deadline: _deadline,
      objectives: objectives.isEmpty ? null : objectives,
      skillIndices: _selectedSkills.map((Skill s) {
        return s.index;
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Quest'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            TextField(
              controller: _titleController,
              autofocus: true, 
              decoration: const InputDecoration(hintText: 'Enter quest title'),
            ),
            const SizedBox(height: 20),

            // category
            _buildSectionLabel('Category'),
            const SizedBox(height: 6),
            _buildCategoryRow(),
            const SizedBox(height: 4),
            Text(
              _category.description,
              style: AppStyles.labelSmall),
            const SizedBox(height: 16),

            // objectives
            if (_category == QuestCategory.main) ...[
              _buildSectionLabel('Objectives'),
              const SizedBox(height: 6),
              _buildObjectivesList(),
              const SizedBox(height: 16),
            ],
            
            // difficulty
            _buildSectionLabel('Difficulty'),
            const SizedBox(height: 6),
            _buildDifficultyRow(),
            const SizedBox(height: 4),
            Text(
              '+${_difficulty.xpReward} XP   '
              '+${_difficulty.coinReward} coins',
              style: AppStyles.bodyText.copyWith(color: AppStyles.difficultyColor(_difficulty),
              ),
            ),
            const SizedBox(height: 16),

            // skills
            _buildSectionLabel('Skills rewarded'),
            const SizedBox(height: 4),
            const Text('Which skills gain XP on completion?',
            style: AppStyles.description),
            const SizedBox(height: 8),
            _buildSkillsRow(),

            // deadline
            if (_category != QuestCategory.daily) ...[
              const SizedBox(height: 16),
              _buildSectionLabel('Deadline'),
              const SizedBox(height: 6),
              _buildDeadlineRow(context),
            ],
          ],
        ),
      ),
      
      actions: [
        TextButton(
          onPressed: () { Navigator.of(context).pop(); }, // close without saving
          child: const Text('Cancel'),
        ),
        
        ElevatedButton(
          onPressed: _submit, 
          child: const Text('Add'),
        ),
      ],
    );
  }

  // == section builders ==

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  // category button row
  Widget _buildCategoryRow() {
    return Row(
      children: [
        for (QuestCategory c in QuestCategory.values)
          _CategoryButton(
            category: c,
            isSelected: _category == c,
            onTap: () {
              setState(() {
                _category = c;
                if (c == QuestCategory.daily) { _deadline = null; }
              });
            }
          ),
      ],
    );
  }

  // difficulty button row
  Widget _buildDifficultyRow() {
    return Row(
      children: [
        for (Difficulty d in Difficulty.values)
          _DifficultyButton(
            difficulty: d,
            isSelected: _difficulty == d,
            onTap: () {
              setState(() {
                _difficulty = d;
              });
            },
          ),
      ],
    );
  }

  // objectives list
  Widget _buildObjectivesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _objectiveControllers.length; i++) // one text field per objective
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _objectiveControllers[i],
                    decoration: InputDecoration(
                      hintText: 'Objective ${i + 1}',
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    size: 20,
                  ), // remove button
                  onPressed: () {
                    setState(() {
                      _objectiveControllers[i].dispose();
                      _objectiveControllers.removeAt(i);
                    });
                  }
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _objectiveControllers.add(TextEditingController());
              });
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add objective'),
          ),
      ],
    );
  }

  // skill selection
  Widget _buildSkillsRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (Skill s in Skill.values)
          _SkillOption(
            skill: s,
            isSelected: _selectedSkills.contains(s),
            onTap: () {
              setState(() {
                if (_selectedSkills.contains(s)) {
                  _selectedSkills.remove(s);
                } else {
                  _selectedSkills.add(s);
                }
              });
            }
          ),
      ],
    );
  }

  // deadline
  Widget _buildDeadlineRow(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: Text(
            _deadline == null
              ? 'No deadline'
              : '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
            style: TextStyle(
              color: _deadline == null ? Colors.grey : Colors.blue,
            ),
          ),
        ),

        TextButton(
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              setState(() {
                _deadline = picked;
              });
            }
          },
          child: const Text('Pick date'),
        ),

        if (_deadline != null)
          IconButton(
            icon: const Icon(Icons.clear, size: 18),
            onPressed: () {
              setState(() {
                _deadline = null;
              });
            },
          ),
      ],
    );
  }
}

// == widgets == 

// category button
class _CategoryButton extends StatelessWidget {
  final QuestCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = AppStyles.categoryColor(category);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? color: Colors.transparent,
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
            ),
            child: Text(
              category.label,
              style: AppStyles.titleSmall.copyWith(color: isSelected ? Colors.white : color,),
            ),
          ),
        ),
      ),
    );
  }
}

// difficulty button
class _DifficultyButton extends StatelessWidget {
  final Difficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyButton({
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = AppStyles.difficultyColor(difficulty);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? color: Colors.transparent,
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
            ),
            child: Text(
              difficulty.label,
              style: AppStyles.titleSmall.copyWith(color: isSelected ? Colors.white : color,),
            ),
          ),
        ),
      )
    );
  }
}

// skill button
class _SkillOption extends StatelessWidget {
  final Skill skill;
  final bool isSelected;
  final VoidCallback onTap;

  const _SkillOption({
    required this.skill,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = AppStyles.skillColor(skill);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
            ? color.withValues(alpha: 0.15)
            : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.grey,
            width: isSelected ? 1.5 : 0.8,
          ),
          borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppStyles.skillIcon(skill),
              color: isSelected ? color : Colors.grey,
              size: 15,
            ),
            const SizedBox(width: 5),
            Text(
              skill.label,
              style: AppStyles.skillName.copyWith(
                fontSize: 12,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}