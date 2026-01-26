import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class AuthActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isGradient;

  const AuthActionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 0.065.sh,
        decoration: BoxDecoration(
          gradient: isGradient
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppPallete.whiteColor.withOpacity(0.35),
                    AppPallete.whiteColor.withOpacity(0.25),
                  ],
                )
              : null,
          color: isGradient ? null : AppPallete.whiteColor,
          borderRadius: BorderRadius.circular(25.r),
          border: isGradient
              ? Border.all(
                  color: AppPallete.whiteColor.withOpacity(0.5),
                  width: 1.5,
                )
              : null,
        ),
        child: Center(
          child: CommonText(
            text: text,
            fontSize: 0.02.sh,
            fontWeight: FontWeight.w700,
            color: isGradient
                ? AppPallete.whiteColor
                : AppPallete.blackTextColor,
          ),
        ),
      ),
    );
  }
}
