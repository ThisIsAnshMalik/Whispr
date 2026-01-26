import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class AuthNavigationLink extends StatelessWidget {
  final String prefixText;
  final String linkText;
  final VoidCallback onTap;

  const AuthNavigationLink({
    super.key,
    required this.prefixText,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonText(
          text: prefixText,
          fontSize: 0.016.sh,
          fontWeight: FontWeight.w500,
          color: AppPallete.whiteColor,
        ),
        GestureDetector(
          onTap: onTap,
          child: CommonText(
            text: linkText,
            fontSize: 0.016.sh,
            fontWeight: FontWeight.w600,
            color: AppPallete.whiteColor.withOpacity(0.9),
            textDecoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
