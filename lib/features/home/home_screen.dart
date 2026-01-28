import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_post_card.dart';
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
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    PostCard(videoCard: true),
                    SizedBox(height: 0.02.sh),
                    PostCard(videoCard: false),
                    SizedBox(height: 0.2.sh),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
