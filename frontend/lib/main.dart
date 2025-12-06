import 'package:flutter/material.dart';
import 'landing_page.dart';

void main() {
  runApp(const MedTrackApp());
}

class MedTrackApp extends StatelessWidget {
  const MedTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E7C86),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5FAFA),
        textTheme: Theme.of(context).textTheme.apply(
          displayColor: const Color(0xFF0E7C86),
          bodyColor: const Color(0xFF12333A),
        ),
      ),
      home: const LandingPage(),
    );
  }
}
