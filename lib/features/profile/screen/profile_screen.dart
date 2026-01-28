// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/common/common_app_bar.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/common/common_user_avatar.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/profile/widgets/profile_nav_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw, vertical: 0.01.sh),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonAppBar(),
            SizedBox(height: 0.03.sh),
            SizedBox(height: 0.1.sh, child: UserAvatar()),
            SizedBox(height: 0.012.sh),
            CommonText(
              text: 'Anonymous',
              fontSize: 0.018.sh,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 0.005.sh),
            CommonText(
              text: 'Your identity is hidden. Stay and speak freely',
              fontSize: 0.014.sh,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.025.sh),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 0.04.sw,
                vertical: 0.02.sh,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppPallete.whiteColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                spacing: 0.01.sh,
                children: [
                  ProfileNavButton(
                    title: 'My Confessions',
                    icon: IconAssets.confessionIcon,
                  ),

                  ProfileNavButton(
                    title: 'Change Password',
                    icon: IconAssets.lockIcon,
                  ),
                  ProfileNavButton(title: 'About', icon: IconAssets.aboutIcon),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppPallete.whiteColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0.04.sw,
                            vertical: 0.02.sh,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(IconAssets.logoutIcon),
                              SizedBox(width: 0.02.sw),
                              CommonText(
                                text: "Logout Account",
                                fontSize: 0.016.sh,
                                fontWeight: FontWeight.w600,
                                color: AppPallete.blackTextColor,
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: AppPallete.blackTextColor.withOpacity(0.2),
                          height: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0.04.sw,
                            vertical: 0.02.sh,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(IconAssets.deleteIcon),
                              SizedBox(width: 0.02.sw),
                              CommonText(
                                text: "Delete Account",
                                fontSize: 0.016.sh,
                                fontWeight: FontWeight.w600,
                                color: AppPallete.blackTextColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.1.sh),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
