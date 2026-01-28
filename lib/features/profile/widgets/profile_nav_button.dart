// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class ProfileNavButton extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;
  const ProfileNavButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.02.sh),

        width: double.infinity,
        decoration: BoxDecoration(
          color: AppPallete.whiteColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            SizedBox(width: 0.02.sw),
            CommonText(
              text: title,
              fontSize: 0.016.sh,
              fontWeight: FontWeight.w600,
              color: AppPallete.blackTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
