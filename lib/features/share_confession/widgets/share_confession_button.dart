// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class ShareConfessionButton extends StatelessWidget {
  final VoidCallback onTap;

  const ShareConfessionButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 0.065.sh,
        decoration: BoxDecoration(
          color: AppPallete.whiteButtonColor,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: AppPallete.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: CommonText(
          text: 'Share Confession',
          fontSize: 0.016.sh,
          fontWeight: FontWeight.w600,
          color: AppPallete.blackTextColor,
        ),
      ),
    );
  }
}
