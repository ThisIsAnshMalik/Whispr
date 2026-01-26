// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:whispr_app/features/onboarding/screen/onboarding_screen.dart';

class SplashService {
  static void navigateToOnboarding(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }
}
