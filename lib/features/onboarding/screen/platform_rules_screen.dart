// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class PlatformRulesScreen extends StatelessWidget {
  const PlatformRulesScreen({super.key});

  void _completeOnboarding(BuildContext context) {
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.024.sw),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.024.sw,
            vertical: 0.02.sh,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35.r),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: 0.035.sw,
                vertical: 0.015.sh,
              ),
              decoration: BoxDecoration(
                color: AppPallete.whiteColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.04.sw,
                  vertical: 0.01.sh,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 0.02.sh),
                    // Title
                    CommonText(
                      text: 'Platform Rules',
                      fontSize: 0.024.sh,
                      fontWeight: FontWeight.w700,
                      color: AppPallete.whiteColor,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 0.03.sh),
                    // Body text
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text:
                                  'WHISPR is a space for honest expression and emotional release.\nTo protect this space and everyone in it, please note:',
                              fontSize: 0.016.sh,
                              fontWeight: FontWeight.w600,
                              color: AppPallete.whiteColor,
                              textAlign: TextAlign.left,
                              maxLine: 10,
                            ),
                            SizedBox(height: 0.02.sh),
                            // Bullet points
                            _buildBulletPoint(
                              'Confessions shared on this platform are not verified for accuracy.',
                            ),
                            SizedBox(height: 0.015.sh),
                            _buildBulletPoint(
                              'WHISPR does not encourage or support illegal, violent, or harmful behavior of any kind.',
                            ),
                            SizedBox(height: 0.015.sh),
                            _buildBulletPoint(
                              'Content may be moderated, hidden, or removed if it violates platform guidelines.',
                            ),
                            SizedBox(height: 0.015.sh),
                            _buildBulletPoint(
                              'WHISPR may cooperate with lawful authorities when required by applicable law.',
                            ),
                            SizedBox(height: 0.02.sh),
                            CommonText(
                              text:
                                  'By continuing, you acknowledge and accept these terms. These measures exist to ensure safety, transparency, and trust for all users.',
                              fontSize: 0.016.sh,
                              fontWeight: FontWeight.w600,
                              color: AppPallete.whiteColor,
                              textAlign: TextAlign.left,
                              maxLine: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 0.02.sh),
                    // Agree & Continue button
                    InkWell(
                      onTap: () => _completeOnboarding(context),
                      child: Container(
                        width: double.infinity,
                        height: 0.07.sh,
                        decoration: BoxDecoration(
                          color: AppPallete.whiteButtonColor,
                          borderRadius: BorderRadius.circular(23.r),
                        ),
                        child: Center(
                          child: CommonText(
                            text: 'Agree & Continue',
                            fontSize: 0.018.sh,
                            fontWeight: FontWeight.w700,
                            color: AppPallete.blackTextColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.02.sh),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0.005.sh, right: 0.02.sw),
          child: CommonText(
            text: '•',
            fontSize: 0.016.sh,
            fontWeight: FontWeight.w600,
            color: AppPallete.whiteColor,
          ),
        ),
        Expanded(
          child: CommonText(
            text: text,
            fontSize: 0.016.sh,
            fontWeight: FontWeight.w600,
            color: AppPallete.whiteColor,
            textAlign: TextAlign.left,
            maxLine: 10,
          ),
        ),
      ],
    );
  }
}
