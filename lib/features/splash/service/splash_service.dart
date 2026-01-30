// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/controllers/session_controller.dart';
import 'package:whispr_app/features/dashboard/dashboard_screen.dart';
import 'package:whispr_app/features/onboarding/screen/onboarding_screen.dart';

class SplashService {
  static void navigateToOnboarding(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      // Wait for session to initialize
      final sessionController = SessionController.to;

      // Wait until session is initialized
      while (!sessionController.isInitialized.value) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Check if user is already logged in
      if (sessionController.isLoggedIn) {
        Get.offAll(() => const DashboardScreen());
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }
}
