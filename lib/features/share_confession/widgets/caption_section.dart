// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class _DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dotSpacing;

  _DottedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.radius = 16,
    this.dotSpacing = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );
    final pathMetric = path.computeMetrics().first;
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var i = 0.0; i < pathMetric.length; i += strokeWidth + dotSpacing) {
      final tangent = pathMetric.getTangentForOffset(i)!;
      canvas.drawCircle(tangent.position, strokeWidth / 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DottedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dotSpacing != dotSpacing;
}

class CaptionSection extends StatelessWidget {
  final TextEditingController controller;

  const CaptionSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Add caption',
          fontSize: 0.015.sh,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 0.01.sh),
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: CustomPaint(
              painter: _DottedBorderPainter(
                color: AppPallete.whiteColor.withOpacity(0.4),
                strokeWidth: 1.5,
                radius: 16.r,
                dotSpacing: 4,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppPallete.whiteColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: 4,
                  style: GoogleFonts.montserrat(
                    color: AppPallete.whiteColor,
                    fontSize: 0.015.sh,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Say as much or as little as you want...',
                    hintStyle: GoogleFonts.montserrat(
                      color: AppPallete.whiteColor.withOpacity(0.5),
                      fontSize: 0.015.sh,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0.04.sw,
                      vertical: 0.015.sh,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
