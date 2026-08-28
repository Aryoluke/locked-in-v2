import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_state.dart';
import 'core/theme.dart';
import 'features/onboarding/onboarding_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/train/training_page.dart';
import 'features/mind/mind_page.dart';
import 'features/life/life_page.dart';
import 'features/squad/squad_page.dart';
import 'features/settings/settings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  runApp(LockedInApp(state: state));
}

class LockedInApp extends StatelessWidget {
  final AppState state;
  const LockedInApp({super.key, required this.state});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: state,
    builder: (_, __) => MaterialApp(
      title: 'LOCKED IN', debugShowCheckedModeBanner: false,
      theme: buildTheme(), home: state.hasProfile ? AppShell(state: state) : OnboardingPage(state: state),
    ),
  );
}

class AppShell extends StatefulWidget {
  final AppState state;
  const AppShell({super.key, required this.state});
  @override State<AppShell> createState() => _AppShellState();
}
class _AppShellState extends State<AppShell> {
  int index = 0;
  late final List<Widget> pages = [
    DashboardPage(state: widget.state), TrainingPage(state: widget.state), MindPage(state: widget.state),
    LifePage(state: widget.state), SquadPage(state: widget.state),
  ];
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('LOCKED IN'),
      actions: [IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage(state: widget.state))))],
    ),
    body: IndexedStack(index: index, children: pages),
    bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (i) => setState(() => index = i), destinations: const [
      NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.fitness_center_outlined), selectedIcon: Icon(Icons.fitness_center), label: 'Train'),
      NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Mind'),
      NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'Life'),
      NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Squad'),
    ]),
  );
}
