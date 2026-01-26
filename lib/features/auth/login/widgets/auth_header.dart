import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 0.05.sh),
        // Logo
        Image.asset(
          ImageAssets.whisprImage,
          width: 0.25.sw,
          height: 0.25.sw,
        ),
        SizedBox(height: 0.02.sh),
        // App Name
        CommonText(
          text: 'WHISPR',
          fontSize: 0.04.sh,
          fontWeight: FontWeight.w700,
          color: AppPallete.whiteColor,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.015.sh),
        // Title/Subtitle
        if (subtitle != null)
          CommonText(
            text: subtitle!,
            fontSize: 0.018.sh,
            fontWeight: FontWeight.w500,
            color: AppPallete.whiteColor,
            textAlign: TextAlign.center,
            maxLine: 2,
          ),
      ],
    );
  }
}
