import 'package:flutter/material.dart';

import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.onProgress,
    required this.onDelete,
  });

  final Habit habit;
  final VoidCallback onProgress;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(habit.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(Icons.delete_outline, color: colors.onErrorContainer),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colors.secondaryContainer,
                    child: Icon(_iconFor(habit.category)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(habit.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        Text(habit.category.label),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'Sumar sesión',
                    onPressed: habit.isComplete ? null : onProgress,
                    icon: Icon(habit.isComplete ? Icons.done_all : Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LinearProgressIndicator(
                value: habit.progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 8),
              Text('${habit.completedDays} de ${habit.targetDays} sesiones'),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(HabitCategory category) => switch (category) {
        HabitCategory.programacion => Icons.code,
        HabitCategory.lectura => Icons.menu_book,
        HabitCategory.diseno => Icons.palette_outlined,
        HabitCategory.repaso => Icons.auto_awesome,
      };
}

