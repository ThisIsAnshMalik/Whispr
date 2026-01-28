import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/common/common_user_avatar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatar(),
        SizedBox(width: 0.025.sw),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: "Welcome!",
              fontSize: 0.016.sh,
              fontWeight: FontWeight.w600,
            ),
            CommonText(
              text: "You’re anonymous here.",
              fontSize: 0.013.sh,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        Spacer(),
        SvgPicture.asset(IconAssets.notificationIcon),
      ],
    );
  }
}
