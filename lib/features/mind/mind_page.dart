import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_state.dart';

class MindPage extends StatefulWidget {
  final AppState state;
  const MindPage({super.key, required this.state});
  @override
  State<MindPage> createState() => _MindPageState();
}

class _MindPageState extends State<MindPage> {
  Timer? timer;
  int seconds = 1500;
  bool running = false;
  String subject = 'Maths';
  final note = TextEditingController();

  @override
  void dispose() { timer?.cancel(); note.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final display = '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('MIND', style: Theme.of(context).textTheme.headlineMedium),
      const Text('Study lock-in, Pomodoro and reflection — one streak.'),
      const SizedBox(height: 18),
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('POMODORO', style: TextStyle(color: Color(0xFFFFD4AF), fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(display, style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900)), Text(subject), const SizedBox(height: 12), Wrap(spacing: 8, children: [FilledButton.icon(onPressed: _toggle, icon: Icon(running ? Icons.pause : Icons.play_arrow), label: Text(running ? 'PAUSE' : 'START')), OutlinedButton(onPressed: () => setState(() => seconds = 1500), child: const Text('RESET'))])]))),
      const SizedBox(height: 12),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [DropdownButtonFormField<String>(value: subject, items: const ['Maths', 'Physics', 'English', 'Languages', 'Other'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => setState(() => subject = value ?? subject), decoration: const InputDecoration(labelText: 'Subject')), const SizedBox(height: 10), TextField(controller: note, decoration: const InputDecoration(labelText: 'Reflection / topic covered')), const SizedBox(height: 10), FilledButton(onPressed: () async { await widget.state.toggleHabit('Study block'); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Study block saved · +15 XP'))); }, child: const Text('MARK STUDY COMPLETE'))]))),
      const SizedBox(height: 12),
      const Card(child: ListTile(leading: Icon(Icons.lightbulb, color: Colors.amber), title: Text('Learn why'), subtitle: Text('Active recall and spaced repetition beat rereading because retrieval strengthens memory access.'))),
    ]);
  }

  void _toggle() {
    timer?.cancel();
    if (running) { setState(() => running = false); return; }
    setState(() => running = true);
    timer = Timer.periodic(const Duration(seconds: 1), (_) { if (seconds <= 1) { timer?.cancel(); setState(() { seconds = 0; running = false; }); widget.state.earn(30); } else { setState(() => seconds--); } });
  }
}
