// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class OnboardingPage3 extends StatelessWidget {
  final VoidCallback? onSkip;
  final VoidCallback? onNext;

  const OnboardingPage3({super.key, this.onSkip, this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          // Circular image
          Container(
            width: 300.w,
            height: 300.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(ImageAssets.onBoardingImg3),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 40.h),
          // Content card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // Title
                  CommonText(
                    text:
                        'You\'re not alone —\nthis is a safe space to\nshare quietly.',
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.whiteColor,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16.h),
                  // Body text
                  CommonText(
                    text:
                        'Some thoughts are too heavy to carry by\nyourself. Take a moment. Speak when\nyou\'re ready.',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppPallete.whiteColor.withOpacity(0.9),
                    textAlign: TextAlign.left,
                  ),

                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: onSkip,
                        child: CommonText(
                          text: 'Skip',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppPallete.whiteColor,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.grey[800],
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: CommonText(
                          text: 'Next',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800]!,
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
