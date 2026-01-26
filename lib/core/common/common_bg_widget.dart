// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class CommonBgWidget extends StatelessWidget {
  final Widget child;
  const CommonBgWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.blackColor,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 77.18, sigmaY: 77.18),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppPallete.primaryColor.withOpacity(0.8),
                AppPallete.secondaryColor.withOpacity(0.4),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF452A7C).withOpacity(0.1),
                offset: const Offset(0, 1.32),
                blurRadius: 32.98,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: child,
          ),
        ),
      ),
    );

    // child:;
  }
}
