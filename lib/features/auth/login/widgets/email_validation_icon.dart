import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class EmailValidationIcon extends StatelessWidget {
  const EmailValidationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 0.02.sw),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppPallete.blackColor.withOpacity(0.3),
      ),
      child: Padding(
        padding: EdgeInsets.all(0.015.sw),
        child: SvgPicture.asset(
          IconAssets.checkIcon,
          width: 0.03.sw,
          height: 0.03.sw,
        ),
      ),
    );
  }
}
