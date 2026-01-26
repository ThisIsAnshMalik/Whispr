// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class OnboardingPage1 extends StatelessWidget {
  final VoidCallback? onSkip;
  final VoidCallback? onNext;

  const OnboardingPage1({super.key, this.onSkip, this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.024.sw),
      child: Column(
        children: [
          SizedBox(height: 0.02.sh),
          // Circular image
          Container(
            width: double.infinity,
            height: 0.4.sh,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(ImageAssets.onBoardingImg1),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 0.02.sh),
          // Content card
          Expanded(
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
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppPallete.whiteColor,
                        AppPallete.whiteColor.withOpacity(0),
                      ],
                    ),

                    borderRadius: BorderRadius.circular(35.r),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 83, sigmaY: 83),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 0.02.sh),
                        // Title
                        CommonText(
                          text:
                              'You’re not alone — this is a safe space\nto share quietly.',
                          fontSize: 0.034.sh,
                          fontWeight: FontWeight.w700,
                          color: AppPallete.whiteColor,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 0.016.sh),
                        // Body text
                        CommonText(
                          text:
                              'Some thoughts are too heavy to carry by yourself. Take a moment. Speak when you’re ready.',
                          fontSize: 0.016.sh,
                          fontWeight: FontWeight.w600,
                          color: AppPallete.whiteColor,
                          textAlign: TextAlign.left,
                        ),

                        // Navigation buttons
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 0.02.sh,
                            horizontal: 0.03.sw,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: onSkip,
                                child: CommonText(
                                  text: 'Skip',
                                  fontSize: 0.018.sh,
                                  fontWeight: FontWeight.w600,
                                  color: AppPallete.whiteColor,
                                ),
                              ),
                              InkWell(
                                onTap: onNext,
                                child: Container(
                                  width: 0.2.sw,
                                  height: 0.07.sh,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppPallete.whiteColor.withOpacity(0.9),
                                        AppPallete.whiteColor.withOpacity(0.6),
                                      ],
                                    ),

                                    borderRadius: BorderRadius.circular(23.r),
                                  ),
                                  child: Center(
                                    child: CommonText(
                                      text: 'Next',
                                      fontSize: 0.018.sh,
                                      fontWeight: FontWeight.w700,
                                      color: AppPallete.blackTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 0.02.sh),
        ],
      ),
    );
  }
}
