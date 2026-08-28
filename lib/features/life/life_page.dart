import 'package:flutter/material.dart';
import '../../core/app_state.dart';

class LifePage extends StatelessWidget {
  final AppState state;
  const LifePage({super.key, required this.state});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    Text('LIFE', style: Theme.of(context).textTheme.headlineMedium),
    const Text('Small daily actions compound into the glow-up.'),
    const SizedBox(height: 18),
    Card(child: Column(children: state.habits.keys.map((habit) => CheckboxListTile(value: state.habits[habit] ?? false, onChanged: (_) => state.toggleHabit(habit), title: Text(habit), subtitle: Text(_subtitle(habit)), secondary: Icon(_icon(habit), color: state.habits[habit] == true ? Colors.greenAccent : Colors.white54))).toList())),
    const SizedBox(height: 12),
    Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('FASTING (OPTIONAL)', style: TextStyle(color: Color(0xFFFFD4AF), fontWeight: FontWeight.w900)), const SizedBox(height: 8), const Text('Choose a window that supports your goals and wellbeing.'), OutlinedButton(onPressed: () => _showFast(context), child: const Text('SET CUSTOM WINDOW'))]))),
    const SizedBox(height: 12),
    const Card(child: ListTile(leading: Icon(Icons.auto_awesome, color: Colors.pinkAccent), title: Text('Skin, style and life skills'), subtitle: Text('Core habit hooks are ready for future roadmap modules.'))),
  ]);

  String _subtitle(String habit) => <String, String>{'Water goal': 'Personal hydration target', 'Creatine': 'Keep hydration up', 'Skincare AM': 'Cleanse · moisturise · SPF', 'Study block': 'Feeds the XP streak', 'Cold shower': 'Build exposure gradually'}[habit] ?? 'One small action, done consistently.';
  IconData _icon(String habit) => habit == 'Water goal' ? Icons.water_drop : habit == 'Study block' ? Icons.menu_book : habit == 'Cold shower' ? Icons.ac_unit : habit == 'Skincare AM' ? Icons.face : Icons.bolt;

  Future<void> _showFast(BuildContext context) async {
    var window = '16:8';
    await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(title: const Text('Fasting window'), content: DropdownButtonFormField<String>(value: window, items: const ['14:10', '16:8', '18:6', '20:4', 'OMAD'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => window = value ?? window), actions: [FilledButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('SAVE'))]));
  }
}
