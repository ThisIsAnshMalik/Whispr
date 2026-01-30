import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_post_card.dart';
import 'package:whispr_app/core/controllers/posts_controller.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
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
              child: Obx(() {
                final controller = PostsController.to;

                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppPallete.whiteColor,
                    ),
                  );
                }

                if (controller.posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.article_outlined,
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
                          'Be the first to share your story',
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
                    itemCount:
                        controller.posts.length + 1, // +1 for bottom padding
                    separatorBuilder: (_, __) => SizedBox(height: 0.02.sh),
                    itemBuilder: (context, index) {
                      if (index == controller.posts.length) {
                        return SizedBox(height: 0.15.sh);
                      }
                      final post = controller.posts[index];
                      return PostCard(
                        post: post,
                        isMyPost: false, // In home, show all posts as not mine
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
