import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/home/widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.01.sh),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(),
            SizedBox(height: 0.02.sh),
            Container(
              decoration: BoxDecoration(
                color: AppPallete.whiteColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [CommonText(text: "Share your thoughts")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
