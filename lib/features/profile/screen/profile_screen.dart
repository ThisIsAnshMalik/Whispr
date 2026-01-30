// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/common/common_app_bar.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_snackbar.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/common/common_user_avatar.dart';
import 'package:whispr_app/core/controllers/session_controller.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/auth/login/screen/login_screen.dart';
import 'package:whispr_app/features/change_password/screen/change_password_screen.dart';
import 'package:whispr_app/features/my_confession/screen/my_confessions_screen.dart';
import 'package:whispr_app/features/profile/widgets/profile_nav_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _handleLogout(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppPallete.blackColor,
        title: CommonText(
          text: 'Logout',
          color: AppPallete.whiteColor,
          fontWeight: FontWeight.w600,
        ),
        content: CommonText(
          text: 'Are you sure you want to logout?',
          color: AppPallete.whiteColor,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CommonText(text: 'Cancel', color: AppPallete.whiteColor),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await SessionController.to.logout();
              Get.offAll(() => const LoginScreen());
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final ctx = Get.overlayContext;
                if (ctx != null && ctx.mounted) {
                  CommonSnackbar.showSuccess(
                    ctx,
                    message: 'You have been logged out',
                  );
                }
              });
            },
            child: CommonText(
              text: 'Logout',
              color: AppPallete.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _handleDeleteAccount(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppPallete.blackColor,
        title: CommonText(
          text: 'Delete Account',
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
        content: CommonText(
          text:
              'Are you sure you want to delete your account? This action cannot be undone and all your data will be lost.',
          color: AppPallete.whiteColor,
          maxLine: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CommonText(text: 'Cancel', color: AppPallete.whiteColor),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              final success = await SessionController.to.deleteAccount(context);
              if (success) {
                Get.offAll(() => const LoginScreen());
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final ctx = Get.overlayContext;
                  if (ctx != null && ctx.mounted) {
                    CommonSnackbar.showSuccess(
                      ctx,
                      message: 'Account deleted successfully',
                    );
                  }
                });
              }
            },
            child: CommonText(
              text: 'Delete',
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.01.sh),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonAppBar(title: 'Profile'),
            SizedBox(height: 0.03.sh),
            SizedBox(height: 0.1.sh, child: UserAvatar()),
            SizedBox(height: 0.012.sh),
            Obx(
              () => CommonText(
                text: SessionController.to.displayName,
                fontSize: 0.018.sh,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 0.005.sh),
            Obx(
              () => CommonText(
                text: SessionController.to.userEmail,
                fontSize: 0.012.sh,
                fontWeight: FontWeight.w400,
                color: AppPallete.whiteColor.withOpacity(0.7),
              ),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyConfessionsScreen(),
                        ),
                      );
                    },
                    title: 'My Confessions',
                    icon: IconAssets.confessionIcon,
                  ),

                  ProfileNavButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(),
                        ),
                      );
                    },
                    title: 'Change Password',
                    icon: IconAssets.lockIcon,
                  ),
                  ProfileNavButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(),
                        ),
                      );
                    },
                    title: 'About',
                    icon: IconAssets.aboutIcon,
                  ),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppPallete.whiteColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => _handleLogout(context),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15.r),
                          ),
                          child: Padding(
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
                        ),
                        Divider(
                          color: AppPallete.blackTextColor.withOpacity(0.2),
                          height: 1,
                        ),
                        InkWell(
                          onTap: () => _handleDeleteAccount(context),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(15.r),
                          ),
                          child: Padding(
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
