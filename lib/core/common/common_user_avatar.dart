import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppPallete.whiteColor, width: 2.w),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        child: Image.asset(ImageAssets.userProfileImg, height: 0.05.sh),
      ),
    );
  }
}
