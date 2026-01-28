import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 0.05.sw),
        CommonText(
          text: 'John Doe',
          fontSize: 0.022.sh,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(
          width: 0.05.sw,
          child: SvgPicture.asset(IconAssets.notificationIcon),
        ),
      ],
    );
  }
}
