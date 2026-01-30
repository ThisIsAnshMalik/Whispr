import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final bool isBackButton;
  final bool isNotification;
  const CommonAppBar({
    super.key,
    required this.title,
    this.isBackButton = false,
    this.isNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 0.05.sw,
          child: isBackButton
              ? InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios_new, size: 0.022.sh),
                )
              : SizedBox.shrink(),
        ),
        CommonText(
          text: title,
          fontSize: 0.022.sh,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(
          width: 0.05.sw,
          child: isNotification
              ? SvgPicture.asset(IconAssets.notificationIcon)
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
