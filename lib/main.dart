import 'package:airsoftplanner/screens/inlog_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xFF4CAF50),
  ),
  textTheme: GoogleFonts.latoTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme.copyWith(
              labelMedium: const TextStyle(color: Colors.white),
              bodyMedium: const TextStyle(color: Colors.white70),
              displayMedium: const TextStyle(color: Colors.white),
              headlineMedium: const TextStyle(color: Colors.white70),
              titleMedium: const TextStyle(color: Colors.white70),
              titleLarge: const TextStyle(color: Colors.white54),
              labelLarge: const TextStyle(color: Colors.white60, fontSize: 20),
              displayLarge: const TextStyle(color: Colors.white),
            ),
  )
);

void main() {
  runApp(const AirsoftEventPlannerApp());
}

class AirsoftEventPlannerApp extends StatelessWidget {
  const AirsoftEventPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const InlogScreen(),
    );
  }
}
