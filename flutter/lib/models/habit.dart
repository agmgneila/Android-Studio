enum HabitCategory { programacion, lectura, diseno, repaso }

class Habit {
  Habit({
    required this.id,
    required this.title,
    required this.category,
    required this.targetDays,
    this.completedDays = 0,
  });

  final int id;
  final String title;
  final HabitCategory category;
  final int targetDays;
  int completedDays;

  double get progress =>
      targetDays == 0 ? 0 : (completedDays / targetDays).clamp(0, 1);
  bool get isComplete => completedDays >= targetDays;
}

extension HabitCategoryText on HabitCategory {
  String get label => switch (this) {
        HabitCategory.programacion => 'Programación',
        HabitCategory.lectura => 'Lectura',
        HabitCategory.diseno => 'Diseño',
        HabitCategory.repaso => 'Repaso',
      };
}

