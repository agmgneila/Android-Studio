import 'package:flutter/material.dart';

import 'data/habit_repository.dart';
import 'models/habit.dart';
import 'widgets/habit_card.dart';
import 'widgets/progress_chart.dart';

void main() => runApp(const RitmoApp());

class RitmoApp extends StatefulWidget {
  const RitmoApp({super.key});

  @override
  State<RitmoApp> createState() => _RitmoAppState();
}

class _RitmoAppState extends State<RitmoApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xff465d44);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ritmo',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        useMaterial3: true,
        cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: RitmoHome(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: () => setState(() {
          _themeMode =
              _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        }),
      ),
    );
  }
}

class RitmoHome extends StatefulWidget {
  const RitmoHome({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<RitmoHome> createState() => _RitmoHomeState();
}

class _RitmoHomeState extends State<RitmoHome> {
  final HabitRepository _repository = HabitRepository();
  var _selectedIndex = 0;
  HabitCategory? _filter;
  var _nextId = 10;

  List<Habit> get _habits => _repository.getAll();
  List<Habit> get _visibleHabits => _filter == null
      ? _habits
      : _habits.where((habit) => habit.category == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final pages = [
      _habitsPage(),
      _statsPage(),
      _profilePage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ritmo'),
        actions: [
          IconButton(
            tooltip: 'Cambiar tema',
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: KeyedSubtree(
            key: ValueKey(_selectedIndex),
            child: pages[_selectedIndex],
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddHabit,
              icon: const Icon(Icons.add),
              label: const Text('Nuevo hábito'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Hábitos'),
          NavigationDestination(
              icon: Icon(Icons.insights), label: 'Progreso'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _habitsPage() {
    return CustomScrollView(
      key: const PageStorageKey('habits'),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tu semana, con intención',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text('${_habits.where((h) => h.isComplete).length} hábitos completados'),
                const SizedBox(height: 16),
                DropdownButtonFormField<HabitCategory?>(
                  initialValue: _filter,
                  decoration: const InputDecoration(
                    labelText: 'Filtrar categoría',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todas')),
                    ...HabitCategory.values.map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.label),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _filter = value),
                ),
              ],
            ),
          ),
        ),
        if (_visibleHabits.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('No hay hábitos en esta categoría')),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList.separated(
              itemCount: _visibleHabits.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final habit = _visibleHabits[index];
                return HabitCard(
                  habit: habit,
                  onProgress: () =>
                      setState(() => habit.completedDays++),
                  onDelete: () {
                    setState(() => _repository.remove(habit.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${habit.title} eliminado')),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _statsPage() {
    final average = _habits.isEmpty
        ? 0.0
        : _habits.map((h) => h.progress).reduce((a, b) => a + b) /
            _habits.length;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Progreso semanal',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('${(average * 100).round()}% de cumplimiento medio'),
        const SizedBox(height: 28),
        const ProgressChart(values: [.2, .45, .35, .7, .62, .88, 1]),
        const SizedBox(height: 28),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.local_fire_department)),
            title: const Text('Racha actual'),
            subtitle: const Text('5 días estudiando con constancia'),
            trailing: Text('5',
                style: Theme.of(context).textTheme.headlineMedium),
          ),
        ),
      ],
    );
  }

  Widget _profilePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const CircleAvatar(radius: 42, child: Text('AG')),
        const SizedBox(height: 16),
        Center(
          child: Text('Estudiante INSOD',
              style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 28),
        SwitchListTile(
          value: widget.isDark,
          onChanged: (_) => widget.onToggleTheme(),
          secondary: const Icon(Icons.dark_mode_outlined),
          title: const Text('Tema oscuro'),
          subtitle: const Text('Ajusta la interfaz a tu entorno'),
        ),
        const ListTile(
          leading: Icon(Icons.notifications_outlined),
          title: Text('Recordatorio diario'),
          subtitle: Text('18:30'),
          trailing: Icon(Icons.chevron_right),
        ),
        const AboutListTile(
          icon: Icon(Icons.info_outline),
          applicationName: 'Ritmo',
          applicationVersion: '1.0.0',
        ),
      ],
    );
  }

  Future<void> _showAddHabit() async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    var category = HabitCategory.programacion;
    var target = 3.0;
    final created = await showModalBottomSheet<Habit>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.viewInsetsOf(context).bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Crear hábito',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().length < 3
                      ? 'Escribe al menos 3 caracteres'
                      : null,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField(
                  initialValue: category,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(),
                  ),
                  items: HabitCategory.values
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value.label),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setModalState(() => category = value!),
                ),
                const SizedBox(height: 14),
                Text('Objetivo: ${target.round()} sesiones'),
                Slider(
                  value: target,
                  min: 1,
                  max: 7,
                  divisions: 6,
                  label: target.round().toString(),
                  onChanged: (value) =>
                      setModalState(() => target = value),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(
                          context,
                          Habit(
                            id: _nextId++,
                            title: titleController.text.trim(),
                            category: category,
                            targetDays: target.round(),
                          ),
                        );
                      }
                    },
                    child: const Text('Guardar hábito'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    titleController.dispose();
    if (created != null) setState(() => _repository.add(created));
  }
}
