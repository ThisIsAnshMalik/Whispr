import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class AuthInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const AuthInputField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: label,
          fontSize: 0.016.sh,
          fontWeight: FontWeight.w500,
          color: AppPallete.whiteColor,
        ),
        SizedBox(height: 0.01.sh),
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 0.065.sh,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppPallete.whiteColor.withOpacity(0.25),
                    AppPallete.whiteColor.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppPallete.whiteColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style: TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 0.018.sh,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0.04.sw,
                    vertical: 0.02.sh,
                  ),
                  border: InputBorder.none,
                  suffixIcon: suffixIcon,
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 0.1.sw,
                    minHeight: 0.05.sh,
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
