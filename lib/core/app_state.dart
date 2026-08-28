import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  SharedPreferences? _prefs;
  Map<String, dynamic> profile = {};
  List<Map<String, dynamic>> workouts = [];
  List<Map<String, dynamic>> foods = [];
  Map<String, bool> habits = {'Water goal': false, 'Creatine': false, 'Skincare AM': false, 'Study block': false, 'Cold shower': false};
  int waterMl = 0, xp = 0, streak = 0;
  double calories = 0, protein = 0, carbs = 0, fats = 0;
  String lastActiveDay = '';
  bool get hasProfile => profile.isNotEmpty;
  int get level => (xp ~/ 250) + 1;
  String get levelName => level < 3 ? 'IRON' : level < 6 ? 'STEEL' : 'TITAN';
  double get waterGoal => ((double.tryParse('${profile['weight'] ?? 70}') ?? 70) * 35).clamp(1500, 4500);
  double get proteinGoal => ((double.tryParse('${profile['weight'] ?? 70}') ?? 70) * 1.6);
  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString('profile'); if (raw != null) profile = jsonDecode(raw).cast<String, dynamic>();
    workouts = _readList('workouts'); foods = _readList('foods');
    final habitRaw = _prefs!.getString('habits'); if (habitRaw != null) habits = Map<String, bool>.from(jsonDecode(habitRaw));
    waterMl = _prefs!.getInt('waterMl') ?? 0; xp = _prefs!.getInt('xp') ?? 0; streak = _prefs!.getInt('streak') ?? 0; lastActiveDay = _prefs!.getString('lastActiveDay') ?? '';
    calories = _prefs!.getDouble('calories') ?? 0; protein = _prefs!.getDouble('protein') ?? 0; carbs = _prefs!.getDouble('carbs') ?? 0; fats = _prefs!.getDouble('fats') ?? 0;
  }
  List<Map<String, dynamic>> _readList(String key) => ((_prefs?.getString(key) == null) ? <dynamic>[] : jsonDecode(_prefs!.getString(key)!)).map<Map<String, dynamic>>((x) => Map<String, dynamic>.from(x)).toList();
  Future<void> _save() async { if (_prefs == null) return; await _prefs!.setString('profile', jsonEncode(profile)); await _prefs!.setString('workouts', jsonEncode(workouts)); await _prefs!.setString('foods', jsonEncode(foods)); await _prefs!.setString('habits', jsonEncode(habits)); await _prefs!.setInt('waterMl', waterMl); await _prefs!.setInt('xp', xp); await _prefs!.setInt('streak', streak); await _prefs!.setString('lastActiveDay', lastActiveDay); await _prefs!.setDouble('calories', calories); await _prefs!.setDouble('protein', protein); await _prefs!.setDouble('carbs', carbs); await _prefs!.setDouble('fats', fats); }
  Future<void> saveProfile(Map<String, dynamic> value) async { profile = value; await _save(); notifyListeners(); }
  Future<void> earn(int amount) async { xp += amount * (profile['lockIn'] == 'FULL' ? 3 : profile['lockIn'] == 'STANDARD' ? 2 : 1); final today = DateTime.now().toIso8601String().substring(0, 10); if (today != lastActiveDay) { streak = lastActiveDay.isEmpty ? 1 : streak + 1; lastActiveDay = today; } await _save(); notifyListeners(); }
  Future<void> addWorkout({required String exercise, required String variation, required int sets, required int reps, required double weight}) async { workouts.insert(0, {'exercise': exercise, 'variation': variation, 'sets': sets, 'reps': reps, 'weight': weight, 'date': DateTime.now().toIso8601String()}); await earn(40); }
  Future<void> addWater(int amount) async { waterMl = (waterMl + amount).clamp(0, 10000); if (waterMl >= waterGoal) habits['Water goal'] = true; await earn(5); }
  Future<void> toggleHabit(String name) async { habits[name] = !(habits[name] ?? false); if (habits[name]!) await earn(15); else { await _save(); notifyListeners(); } }
  Future<void> addFood(String name, double kcal, double p, double c, double f) async { foods.insert(0, {'name': name, 'kcal': kcal, 'protein': p, 'carbs': c, 'fats': f, 'date': DateTime.now().toIso8601String()}); calories += kcal; protein += p; carbs += c; fats += f; await earn(10); }
  Future<void> resetDay() async { waterMl = 0; calories = 0; protein = 0; carbs = 0; fats = 0; for (final key in habits.keys) habits[key] = false; await _save(); notifyListeners(); }
}
