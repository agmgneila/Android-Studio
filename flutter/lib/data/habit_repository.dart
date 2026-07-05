import '../models/habit.dart';

class HabitRepository {
  final List<Habit> _habits = [
    Habit(
      id: 1,
      title: 'Practicar Flutter',
      category: HabitCategory.programacion,
      targetDays: 5,
      completedDays: 3,
    ),
    Habit(
      id: 2,
      title: 'Leer apuntes de INSOD',
      category: HabitCategory.lectura,
      targetDays: 4,
      completedDays: 2,
    ),
    Habit(
      id: 3,
      title: 'Repasar navegación',
      category: HabitCategory.repaso,
      targetDays: 3,
      completedDays: 3,
    ),
  ];

  List<Habit> getAll() => List.unmodifiable(_habits);

  void add(Habit habit) => _habits.add(habit);

  void remove(int id) => _habits.removeWhere((habit) => habit.id == id);
}

