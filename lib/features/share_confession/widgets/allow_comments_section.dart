// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class AllowCommentsSection extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AllowCommentsSection({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: 'Allow Comments',
          fontSize: 0.015.sh,
          fontWeight: FontWeight.w600,
        ),
        _GradientSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _GradientSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _GradientSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const trackWidth = 50.0;
    const trackHeight = 22.0;
    const thumbSize = 24.0;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: trackWidth,
        height: trackHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(trackHeight / 2),
          gradient: value
              ? LinearGradient(
                  colors: [AppPallete.primaryColor, AppPallete.secondaryColor],
                )
              : null,
          color: value ? null : AppPallete.whiteButtonColor,
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.003.sw,
              vertical: 0.004.sh,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? AppPallete.whiteColor : null,
                gradient: value
                    ? null
                    : LinearGradient(
                        colors: [
                          AppPallete.primaryColor,
                          AppPallete.secondaryColor,
                        ],
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
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
