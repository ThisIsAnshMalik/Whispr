// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
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
    this.radius = 20,
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

class UploadConfessionSection extends StatelessWidget {
  final VoidCallback? onTap;

  const UploadConfessionSection({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DottedBorderPainter(
          color: AppPallete.whiteColor.withOpacity(0.4),
          strokeWidth: 1.5,
          radius: 20.r,
          dotSpacing: 4,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 0.03.sh, horizontal: 0.04.sw),
          decoration: BoxDecoration(
            color: AppPallete.whiteColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              SvgPicture.asset(IconAssets.uploadIcon),
              SizedBox(height: 0.01.sh),
              CommonText(
                text: 'Upload Your Confession',
                fontSize: 0.014.sh,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 0.004.sh),
              CommonText(
                text: 'Audio or Video',
                fontSize: 0.013.sh,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 0.002.sh),
              CommonText(
                text: 'Record now or choose from your device',
                fontSize: 0.012.sh,
                fontWeight: FontWeight.w500,
                color: AppPallete.whiteColor.withOpacity(0.85),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
