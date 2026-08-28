import 'package:flutter/material.dart';
import '../../core/app_state.dart';

class DashboardPage extends StatelessWidget {
  final AppState state;
  const DashboardPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final done = state.habits.values.where((value) => value).length;
    final progress = state.habits.isEmpty ? 0.0 : done / state.habits.length;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('Good work, ${state.profile['name'] ?? 'athlete'}.', style: Theme.of(context).textTheme.headlineMedium),
      Text('${state.profile['bodyType'] ?? 'HYBRID'} mode · ${state.profile['lockIn'] ?? 'STANDARD'} intensity'),
      const SizedBox(height: 18),
      Row(children: [
        _metric('${state.streak}', 'DAY STREAK', Icons.local_fire_department, Colors.orange),
        const SizedBox(width: 8),
        _metric('${state.xp}', 'XP', Icons.bolt, Colors.greenAccent),
        const SizedBox(width: 8),
        _metric('LV ${state.level}', state.levelName, Icons.shield, const Color(0xFFFFD4AF)),
      ]),
      const SizedBox(height: 12),
      _card('TODAY\'S LOCK-IN', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Train · hydrate · study · reset', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        LinearProgressIndicator(value: progress, minHeight: 8),
        const SizedBox(height: 8),
        Text('$done/${state.habits.length} daily actions complete'),
      ])),
      const SizedBox(height: 12),
      _card('HYDRATION', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${state.waterMl} / ${state.waterGoal.round()} ml', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: (state.waterMl / state.waterGoal).clamp(0.0, 1.0)),
        const SizedBox(height: 8),
        FilledButton(onPressed: () => state.addWater(250), child: const Text('+250 ml')),
      ])),
      const SizedBox(height: 12),
      _card('NUTRITION', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${state.calories.round()} kcal · ${state.protein.round()}g protein', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        Text('Target: ${state.proteinGoal.round()}g protein'),
        OutlinedButton(onPressed: () => _foodDialog(context), child: const Text('QUICK-LOG FOOD')),
      ])),
      const SizedBox(height: 12),
      _card('FOUR GLOW-UP TRACKS', const Column(children: [
        ListTile(leading: Icon(Icons.fitness_center), title: Text('BODY'), subtitle: Text('Strength skeleton')),
        ListTile(leading: Icon(Icons.menu_book), title: Text('MIND'), subtitle: Text('Focus skeleton')),
        ListTile(leading: Icon(Icons.auto_awesome), title: Text('LIFE'), subtitle: Text('Habits skeleton')),
        ListTile(leading: Icon(Icons.groups), title: Text('SQUAD'), subtitle: Text('Accountability skeleton')),
      ])),
    ]);
  }

  Widget _metric(String value, String label, IconData icon, Color color) => Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(10), child: Column(children: [Icon(icon, color: color), const SizedBox(height: 4), Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(fontSize: 9, color: Colors.white60))]))));
  Widget _card(String title, Widget child) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Color(0xFFFFD4AF), fontWeight: FontWeight.w900, letterSpacing: 1.1)), const SizedBox(height: 10), child])));

  Future<void> _foodDialog(BuildContext context) async {
    final name = TextEditingController(text: 'Meal');
    final calories = TextEditingController(text: '400');
    final protein = TextEditingController(text: '25');
    await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(title: const Text('Quick food log'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: name, decoration: const InputDecoration(labelText: 'Food')), TextField(controller: calories, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Calories')), TextField(controller: protein, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Protein (g)'))]), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('CANCEL')), FilledButton(onPressed: () { state.addFood(name.text, double.tryParse(calories.text) ?? 0, double.tryParse(protein.text) ?? 0, 0, 0); Navigator.pop(dialogContext); }, child: const Text('LOG'))]));
  }
}
