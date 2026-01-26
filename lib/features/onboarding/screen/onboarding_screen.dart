// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/features/onboarding/widgets/onboarding_page_1.dart';
import 'package:whispr_app/features/onboarding/widgets/onboarding_page_2.dart';
import 'package:whispr_app/features/onboarding/widgets/onboarding_page_3.dart';
import 'package:whispr_app/features/onboarding/screen/platform_rules_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToPlatformRules();
    }
  }

  void _skipOnboarding() {
    _navigateToPlatformRules();
  }

  void _navigateToPlatformRules() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const PlatformRulesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              OnboardingPage1(onSkip: _skipOnboarding, onNext: _nextPage),
              OnboardingPage2(onSkip: _skipOnboarding, onNext: _nextPage),
              OnboardingPage3(onSkip: _skipOnboarding, onNext: _nextPage),
            ],
          ),
          // Page indicators
          Positioned(
            bottom: 0.08.sh,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
