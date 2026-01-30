// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

enum ReportReason {
  harassment,
  sexualContent,
  selfHarm,
  misinformation,
  spam,
  somethingElse,
}

extension ReportReasonExtension on ReportReason {
  String get label {
    switch (this) {
      case ReportReason.harassment:
        return 'Harassment or hate speech';
      case ReportReason.sexualContent:
        return 'Sexual or explicit content';
      case ReportReason.selfHarm:
        return 'Self harm or harmful behaviour';
      case ReportReason.misinformation:
        return 'Misinformation';
      case ReportReason.spam:
        return 'Spam or promotion';
      case ReportReason.somethingElse:
        return 'Something else';
    }
  }
}

void showReportContentBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => const _ReportContentBottomSheet(),
  );
}

class _ReportContentBottomSheet extends StatefulWidget {
  const _ReportContentBottomSheet();

  @override
  State<_ReportContentBottomSheet> createState() =>
      _ReportContentBottomSheetState();
}

class _ReportContentBottomSheetState extends State<_ReportContentBottomSheet> {
  ReportReason _selectedReason = ReportReason.somethingElse;
  final TextEditingController _contextController = TextEditingController();

  @override
  void dispose() {
    _contextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 0.025.sh,
            horizontal: 0.05.sw,
          ),
          decoration: BoxDecoration(
            color: AppPallete.bottomSheetColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CommonText(
                    text: 'Report Content',
                    fontSize: 0.022.sh,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.whiteColor,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 0.006.sh),
                  CommonText(
                    text: 'Help us keep this space safe and respectful.',
                    fontSize: 0.016.sh,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.whiteColor.withOpacity(0.9),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 0.02.sh),
                  Divider(
                    color: AppPallete.whiteColor.withOpacity(0.3),
                    height: 1,
                  ),
                  SizedBox(height: 0.02.sh),
                  CommonText(
                    text: 'Why are you reporting this?',
                    fontSize: 0.02.sh,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.whiteColor,
                  ),
                  SizedBox(height: 0.01.sh),
                  ...ReportReason.values.map(
                    (reason) => _RadioOption(
                      label: reason.label,
                      value: reason,
                      groupValue: _selectedReason,
                      onChanged: (value) {
                        setState(() => _selectedReason = value!);
                      },
                    ),
                  ),
                  SizedBox(height: 0.02.sh),
                  CommonText(
                    text: 'Would you like to add more context?',
                    fontSize: 0.015.sh,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.whiteColor,
                  ),
                  SizedBox(height: 0.008.sh),
                  _DashedBorder(
                    strokeWidth: 1.5,
                    color: AppPallete.whiteColor.withOpacity(0.3),
                    borderRadius: 12.r,
                    child: TextField(
                      controller: _contextController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                            'You can share more details if you feel comfortable',
                        hintStyle: TextStyle(
                          color: AppPallete.whiteColor.withOpacity(0.5),
                          fontSize: 0.012.sh,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0.03.sw,
                          vertical: 0.015.sh,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 0.013.sh,
                        color: AppPallete.whiteColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.025.sh),
                  SizedBox(
                    height: 0.06.sh,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: CommonText(
                        text: 'Submit Report',
                        fontSize: 0.015.sh,
                        fontWeight: FontWeight.w600,
                        color: AppPallete.blackTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.012.sh),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: CommonText(
                      text: 'Cancel',
                      fontSize: 0.016.sh,
                      fontWeight: FontWeight.w600,
                      color: AppPallete.whiteColor.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final ReportReason value;
  final ReportReason groupValue;
  final ValueChanged<ReportReason?> onChanged;

  const _RadioOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.008.sh),
        child: Row(
          children: [
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppPallete.whiteButtonColor
                      : AppPallete.whiteColor.withOpacity(0.4),
                  width: 2,
                ),
                color: isSelected
                    ? AppPallete.primaryColor
                    : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPallete.primaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 0.03.sw),
            Expanded(
              child: CommonText(
                text: label,
                fontSize: 0.014.sh,
                fontWeight: FontWeight.w600,
                color: AppPallete.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorder extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Color color;
  final double borderRadius;

  const _DashedBorder({
    required this.child,
    this.strokeWidth = 1,
    this.color = Colors.grey,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        strokeWidth: strokeWidth,
        color: color,
        borderRadius: borderRadius,
      ),
      child: Padding(padding: EdgeInsets.all(strokeWidth), child: child),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double borderRadius;

  _DashedBorderPainter({
    required this.strokeWidth,
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final half = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      half,
      half,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    const dashWidth = 4.0;
    const dashGap = 3.0;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));

    _drawDashedPath(canvas, path, paint, dashWidth, dashGap);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double dashWidth,
    double dashGap,
  ) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final segment = metric.extractPath(
          distance,
          (distance + dashWidth).clamp(0, metric.length),
        );
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
