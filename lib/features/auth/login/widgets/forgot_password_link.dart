// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class ForgotPasswordLink extends StatelessWidget {
  final VoidCallback? onTap;

  const ForgotPasswordLink({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onTap,
        child: CommonText(
          text: 'forgot password?',
          fontSize: 0.016.sh,
          fontWeight: FontWeight.w500,
          color: AppPallete.whiteColor,
          // textDecoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
