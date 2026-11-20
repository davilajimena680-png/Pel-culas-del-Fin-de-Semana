import 'package:flutter/material.dart';

import '../../domain/entities/mood.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final Mood selected;
  final ValueChanged<Mood> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: Mood.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final mood = Mood.values[index];
          return ChoiceChip(
            label: Text('${mood.emoji} ${mood.label}'),
            selected: mood == selected,
            onSelected: (_) => onSelected(mood),
          );
        },
      ),
    );
  }
}
