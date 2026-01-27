// ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:ui';

class FrostedGlassBox extends StatelessWidget {
  const FrostedGlassBox({
    super.key,
    required this.theWidth,
    required this.theHeight,
    required this.theChild,
  });

  final theWidth;
  final theHeight;
  final theChild;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Container(
        width: double.infinity,
        height: theHeight,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.32),
              blurRadius: 124,
              // spreadRadius: -30,
              offset: Offset(0, 24),
            ),
          ],
        ),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 44.0, sigmaY: 44.0),
              child: Center(child: theChild),
            ),
          ],
        ),
      ),
    );
  }
}
