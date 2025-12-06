import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                SizedBox(
                  width: 180,
                  height: 180,
                  child: SvgPicture.asset(
                    'assets/logo/logo medtrack.svg',
                    semanticsLabel: 'MedTrack logo',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                // App Name
                const Text(
                  'MedTrack',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4DB8AC),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Tagline
                const Text(
                  'Your everyday medicine companion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
