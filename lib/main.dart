import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xFF4CAF50),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
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
      home: const HomeScreen(),
    );
  }
}
