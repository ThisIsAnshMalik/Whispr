// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/common/common_user_avatar.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class PostCard extends StatelessWidget {
  final bool videoCard;
  const PostCard({super.key, required this.videoCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.02.sh),
      width: 1.sw,
      decoration: BoxDecoration(
        color: AppPallete.whiteColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: Color(0xffF4F1FF).withOpacity(0.6),
          width: 1.17,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              UserAvatar(),
              SizedBox(width: 0.02.sw),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: "Anonymous",
                    fontWeight: FontWeight.w600,
                    fontSize: 0.01446.sh,
                  ),
                  CommonText(
                    text: "5 hours ago",
                    fontWeight: FontWeight.w600,
                    fontSize: 0.01084.sh,
                  ),
                ],
              ),
              Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Container(
                  padding: EdgeInsets.all(0.02.sh),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppPallete.whiteColor.withOpacity(0.1),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 00),
                    child: SvgPicture.asset(IconAssets.flagIcon),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.01.sh),
          Align(
            alignment: Alignment.centerLeft,
            child: CommonText(
              text: "Today, I experienced the most blissful ride outside.",
              fontWeight: FontWeight.w600,
              fontSize: 0.01446.sh,
            ),
          ),
          SizedBox(height: 0.01.sh),
          Container(
            height: 0.2.sh,
            width: 1.sw,
            decoration: BoxDecoration(
              color: AppPallete.whiteColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15.r),
              image: DecorationImage(
                image: videoCard
                    ? AssetImage(ImageAssets.videoExImg)
                    : AssetImage(ImageAssets.audioExImg),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: Container(
                        padding: EdgeInsets.all(0.02.sh),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPallete.whiteColor.withOpacity(0.4),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 00),
                          child: SvgPicture.asset(IconAssets.playIcon),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
                    width: 1.sw,
                    height: 0.04.sh,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.r),
                        bottomRight: Radius.circular(15.r),
                      ),
                      color: Color(0xff323232).withOpacity(0.4),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(IconAssets.favIcon),
                        SizedBox(width: 0.015.sw),
                        CommonText(
                          text: "4.2k",
                          fontWeight: FontWeight.w600,
                          fontSize: 0.014.sh,
                        ),
                        SizedBox(width: 0.04.sw),
                        SvgPicture.asset(IconAssets.commentIcon),
                        SizedBox(width: 0.015.sw),
                        CommonText(
                          text: "4.2k",
                          fontWeight: FontWeight.w600,
                          fontSize: 0.014.sh,
                        ),
                        SizedBox(width: 0.04.sw),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.01.sh),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
            width: 1.sw,
            height: 0.06.sh,
            decoration: BoxDecoration(
              color: AppPallete.whiteColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.4.r),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: Image.asset(
                    ImageAssets.userProfileImg,
                    height: 0.03.sh,
                    width: 0.06.sw,
                  ),
                ),
                SizedBox(width: 0.02.sw),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.zero, // optional, for tight layout
                    ),
                    style: const TextStyle(
                      // customize text style if needed
                    ),
                  ),
                ),
                SizedBox(width: 0.02.sw),
                CommonText(
                  text: "(273 Comments)",
                  fontWeight: FontWeight.w500,
                  fontSize: 0.012.sh,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
