import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_app_bar.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_post_card.dart';

class MyConfessionsScreen extends StatelessWidget {
  const MyConfessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.01.sh),
        child: Column(
          children: [
            CommonAppBar(title: 'My Confessions', isBackButton: true),
            SizedBox(height: 0.02.sh),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PostCard(videoCard: true, isMyPost: true),
                    SizedBox(height: 0.02.sh),
                    PostCard(videoCard: false, isMyPost: true),
                    SizedBox(height: 0.05.sh),
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
