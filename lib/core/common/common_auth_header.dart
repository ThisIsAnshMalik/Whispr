import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class CommonAuthHeader extends StatelessWidget {
  final String title;

  const CommonAuthHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 0.01.sh),
        // Logo
        Image.asset(ImageAssets.whisprImage, height: 0.23.sh),

        SizedBox(height: 0.02.sh),
        // Title
        CommonText(
          text: title,
          fontSize: 0.022.sh,
          fontWeight: FontWeight.w600,
          color: AppPallete.whiteColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
