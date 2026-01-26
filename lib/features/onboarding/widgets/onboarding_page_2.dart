// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class OnboardingPage2 extends StatefulWidget {
  final VoidCallback? onSkip;
  final VoidCallback? onNext;

  const OnboardingPage2({super.key, this.onSkip, this.onNext});

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {
  double _blurValue = 0.7; // Closer to "Blur" side

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          // Circular frame with video preview
          Container(
            width: 300.w,
            height: 300.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppPallete.primaryColor.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppPallete.primaryColor.withOpacity(0.8),
                      AppPallete.secondaryColor.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 250.w,
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Stack(
                      children: [
                        // Blurred silhouette effect
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppPallete.primaryColor.withOpacity(0.6),
                                  AppPallete.secondaryColor.withOpacity(0.4),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                        ),
                        // Blur overlay based on slider
                        if (_blurValue > 0.3)
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: _blurValue * 20,
                                sigmaY: _blurValue * 20,
                              ),
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          // Blur/Clear slider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(
                      text: 'Blur',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppPallete.whiteColor,
                    ),
                    CommonText(
                      text: 'Clear',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppPallete.whiteColor,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.r),
                    gradient: LinearGradient(
                      colors: [
                        AppPallete.primaryColor,
                        AppPallete.secondaryColor,
                      ],
                    ),
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 6.h,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 12.r,
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 20.r,
                      ),
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                      thumbColor: Colors.white,
                      overlayColor: AppPallete.primaryColor.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _blurValue,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (value) {
                        setState(() {
                          _blurValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          // Camera and microphone icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppPallete.primaryColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppPallete.primaryColor, width: 2),
                ),
                child: Icon(
                  Icons.videocam,
                  color: AppPallete.primaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 24.w),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppPallete.primaryColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppPallete.primaryColor, width: 2),
                ),
                child: Icon(
                  Icons.mic,
                  color: AppPallete.primaryColor,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
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
                    text: 'Privacy protected —\nyou decide how much\nto share.',
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.whiteColor,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16.h),
                  // Body text
                  CommonText(
                    text:
                        'Record audio or video in a way that feels\nsafe to you. Choose to blur your face or\nremain visible.',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppPallete.whiteColor.withOpacity(0.9),
                    textAlign: TextAlign.left,
                  ),
                  const Spacer(),
                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: widget.onSkip,
                        child: CommonText(
                          text: 'Skip',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppPallete.whiteColor,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: widget.onNext,
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
                  SizedBox(height: 20.h),
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
