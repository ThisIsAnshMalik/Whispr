// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/common/common_app_bar.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_post_card.dart';
import 'package:whispr_app/core/controllers/posts_controller.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

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
              child: Obx(() {
                final controller = PostsController.to;

                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppPallete.whiteColor,
                    ),
                  );
                }

                // All posts are considered user's posts (local-only storage)
                final myPosts = controller.posts;

                if (myPosts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_note_outlined,
                          size: 0.1.sh,
                          color: AppPallete.whiteColor.withOpacity(0.4),
                        ),
                        SizedBox(height: 0.02.sh),
                        Text(
                          'No confessions yet',
                          style: TextStyle(
                            color: AppPallete.whiteColor.withOpacity(0.6),
                            fontSize: 0.018.sh,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.01.sh),
                        Text(
                          'Share your first confession',
                          style: TextStyle(
                            color: AppPallete.whiteColor.withOpacity(0.4),
                            fontSize: 0.014.sh,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadPosts,
                  color: AppPallete.primaryColor,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemCount: myPosts.length + 1, // +1 for bottom padding
                    separatorBuilder: (_, __) => SizedBox(height: 0.02.sh),
                    itemBuilder: (context, index) {
                      if (index == myPosts.length) {
                        return SizedBox(height: 0.05.sh);
                      }
                      final post = myPosts[index];
                      return PostCard(
                        post: post,
                        isMyPost: true, // In my confessions, all are mine
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
