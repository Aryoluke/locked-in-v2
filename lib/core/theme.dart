import 'package:flutter/material.dart';

ThemeData buildTheme() {
  const emerald = Color(0xFF10B981); const gold = Color(0xFFD4AF37); const charcoal = Color(0xFF141416);
  final scheme = ColorScheme.fromSeed(seedColor: emerald, brightness: Brightness.dark).copyWith(primary: emerald, secondary: gold, surface: const Color(0xFF1D1D21));
  return ThemeData(useMaterial3: true, colorScheme: scheme, scaffoldBackgroundColor: charcoal,
    appBarTheme: const AppBarTheme(backgroundColor: charcoal, foregroundColor: Colors.white, centerTitle: false),
    cardTheme: CardThemeData(color: Color(0xFF1D1D21), margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18)))),
    inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Color(0xFF242429), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14)), borderSide: BorderSide.none)),
    navigationBarTheme: NavigationBarThemeData(backgroundColor: Color(0xFF1A1A1E), indicatorColor: emerald.withValues(alpha: .25), labelTextStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w700)),),
    textTheme: const TextTheme(headlineMedium: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -1), titleLarge: TextStyle(fontWeight: FontWeight.w800), bodyMedium: TextStyle(color: Color(0xFFB8B8C2), height: 1.35)),
  );
}
