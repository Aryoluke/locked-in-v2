import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_state.dart';

class TrainingPage extends StatefulWidget {
  final AppState state;
  const TrainingPage({super.key, required this.state});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  final exercise = TextEditingController(text: 'Pull-up');
  final sets = TextEditingController(text: '3');
  final reps = TextEditingController(text: '8');
  final weight = TextEditingController(text: '0');
  String variation = 'Bodyweight';
  Timer? timer;
  int seconds = 0;

  final variations = const [
    'Bodyweight',
    'Weighted',
    'Neutral grip',
    'Wide grip',
    'Negative',
    'Tempo',
  ];

  @override
  void dispose() {
    timer?.cancel();
    exercise.dispose();
    sets.dispose();
    reps.dispose();
    weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.state,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('TRAIN', style: Theme.of(context).textTheme.headlineMedium),
          const Text('Gym + calisthenics, logged locally and ready to sync.'),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: exercise,
                    decoration: const InputDecoration(labelText: 'Exercise'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: variation,
                    items: variations
                        .map(
                          (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => variation = value);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Variation / progression',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: sets,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Sets'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: reps,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Reps'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: weight,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Kg'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _logWorkout,
                          icon: const Icon(Icons.check),
                          label: const Text('LOG WORKOUT'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: _toggleRest,
                        icon: const Icon(Icons.timer_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (seconds > 0)
            Card(
              child: ListTile(
                leading: const Icon(Icons.timer, color: Colors.orange),
                title: Text(
                  'Rest timer  ${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
                ),
                trailing: TextButton(
                  onPressed: () {
                    timer?.cancel();
                    setState(() => seconds = 0);
                  },
                  child: const Text('STOP'),
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text('RECENT LOGS', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...widget.state.workouts.take(12).map(
                (workout) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center,
                        color: Colors.greenAccent),
                    title: Text(
                      '${workout['exercise']} — ${workout['variation']}',
                    ),
                    subtitle: Text(
                      '${workout['sets']} sets × ${workout['reps']} reps @ ${workout['weight']} kg',
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline, color: Color(0xFFFFD4AF)),
              title: Text('Coach note'),
              subtitle: Text(
                'Progressive overload works because repeated exposure plus manageable increases drives adaptation. AI coaching and form analysis are roadmap integrations.',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logWorkout() async {
    await widget.state.addWorkout(
      exercise: exercise.text.trim().isEmpty ? 'Exercise' : exercise.text.trim(),
      variation: variation,
      sets: int.tryParse(sets.text) ?? 1,
      reps: int.tryParse(reps.text) ?? 1,
      weight: double.tryParse(weight.text) ?? 0,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout logged • +40 XP')),
    );
  }

  void _toggleRest() {
    timer?.cancel();
    setState(() => seconds = seconds > 0 ? 0 : 90);
    if (seconds == 0) return;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds <= 1) {
        timer?.cancel();
        if (!mounted) return;
        setState(() => seconds = 0);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('REST COMPLETE')),
        );
      } else if (mounted) {
        setState(() => seconds--);
      }
    });
  }
}
