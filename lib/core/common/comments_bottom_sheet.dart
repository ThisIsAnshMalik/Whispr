// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/common/report_content_bottom_sheet.dart';
import 'package:whispr_app/core/controllers/comments_controller.dart';
import 'package:whispr_app/core/models/comment_model.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

/// Shows the comments bottom sheet for a given post.
void showCommentsBottomSheet(BuildContext context, {required String postId}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => _CommentsBottomSheet(postId: postId),
  );
}

class _CommentsBottomSheet extends StatelessWidget {
  final String postId;
  const _CommentsBottomSheet({required this.postId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentsController>(
      init: CommentsController(postId: postId),
      builder: (controller) => Container(
        height: 0.75.sh,
        decoration: BoxDecoration(
          color: AppPallete.blackTextColor.withOpacity(0.95),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            // Drag handle
            SizedBox(height: 0.01.sh),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppPallete.whiteColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 0.015.sh),
            CommonText(
              text: 'Comments',
              fontSize: 0.022.sh,
              fontWeight: FontWeight.w600,
              color: AppPallete.whiteColor,
            ),
            SizedBox(height: 0.015.sh),

            // Comments list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppPallete.whiteColor,
                      strokeWidth: 2,
                    ),
                  );
                }
                if (controller.comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: AppPallete.whiteColor.withOpacity(0.4),
                          size: 0.08.sh,
                        ),
                        SizedBox(height: 0.015.sh),
                        CommonText(
                          text: 'No comments yet',
                          fontSize: 0.016.sh,
                          color: AppPallete.whiteColor.withOpacity(0.6),
                        ),
                        SizedBox(height: 0.005.sh),
                        CommonText(
                          text: 'Be the first to comment',
                          fontSize: 0.014.sh,
                          color: AppPallete.whiteColor.withOpacity(0.4),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.comments.length,
                  separatorBuilder: (_, __) => SizedBox(height: 0.02.sh),
                  itemBuilder: (ctx, index) {
                    final item = controller.comments[index];
                    return _CommentTile(
                      comment: item.comment,
                      replies: item.replies,
                      onReply: () => controller.startReply(item.comment),
                      onReport: () {
                        Navigator.of(context).pop();
                        showReportContentBottomSheet(context);
                      },
                      onDelete: () =>
                          controller.deleteComment(context, item.comment.id!),
                      controller: controller,
                    );
                  },
                );
              }),
            ),

            // Reply indicator + input
            Obx(() {
              final replying = controller.replyingTo.value;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(
                  left: 0.04.sw,
                  right: 0.04.sw,
                  top: replying != null ? 0.01.sh : 0,
                  bottom: 0.03.sh,
                ),
                decoration: BoxDecoration(color: AppPallete.blackTextColor),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (replying != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.01.sh),
                        child: Row(
                          children: [
                            Icon(
                              Icons.reply,
                              color: AppPallete.whiteColor.withOpacity(0.7),
                              size: 0.018.sh,
                            ),
                            SizedBox(width: 0.02.sw),
                            Expanded(
                              child: CommonText(
                                text:
                                    'Replying to: ${replying.text.length > 30 ? '${replying.text.substring(0, 30)}...' : replying.text}',
                                fontSize: 0.012.sh,
                                color: AppPallete.whiteColor.withOpacity(0.7),
                                maxLine: 1,
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.cancelReply,
                              child: Icon(
                                Icons.close,
                                color: AppPallete.whiteColor.withOpacity(0.7),
                                size: 0.02.sh,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.textController,
                            focusNode: controller.focusNode,
                            maxLines: 3,
                            minLines: 1,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => controller.sendComment(context),
                            decoration: InputDecoration(
                              hintText: replying != null
                                  ? 'Write a reply...'
                                  : 'Add a comment...',
                              hintStyle: TextStyle(
                                color: AppPallete.whiteColor.withOpacity(0.5),
                                fontSize: 0.013.sh,
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17.r),
                                borderSide: BorderSide(
                                  width: 1.w,
                                  color: const Color(
                                    0xffF4F1FF,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17.r),
                                borderSide: BorderSide(
                                  width: 1.w,
                                  color: const Color(
                                    0xffF4F1FF,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17.r),
                                borderSide: BorderSide(
                                  width: 1.5.w,
                                  color: AppPallete.primaryColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 0.04.sw,
                                vertical: 0.012.sh,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 0.013.sh,
                              color: AppPallete.whiteColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 0.02.sw),
                        Obx(
                          () => GestureDetector(
                            onTap: controller.isSending.value
                                ? null
                                : () => controller.sendComment(context),
                            child: Container(
                              padding: EdgeInsets.all(0.012.sh),
                              decoration: BoxDecoration(
                                color: AppPallete.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: controller.isSending.value
                                  ? SizedBox(
                                      width: 0.02.sh,
                                      height: 0.02.sh,
                                      child: CircularProgressIndicator(
                                        color: AppPallete.whiteColor,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      IconAssets.sendIcon,
                                      width: 0.02.sh,
                                      height: 0.02.sh,
                                      colorFilter: const ColorFilter.mode(
                                        AppPallete.whiteColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommentModel comment;
  final List<CommentModel> replies;
  final VoidCallback onReply;
  final VoidCallback onReport;
  final VoidCallback onDelete;
  final CommentsController controller;

  const _CommentTile({
    required this.comment,
    required this.replies,
    required this.onReply,
    required this.onReport,
    required this.onDelete,
    required this.controller,
  });

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.symmetric(vertical: 0.02.sh),
        decoration: BoxDecoration(
          color: AppPallete.blackTextColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.flag_outlined,
                  color: AppPallete.whiteColor.withOpacity(0.8),
                ),
                title: CommonText(
                  text: 'Report',
                  fontSize: 0.016.sh,
                  color: AppPallete.whiteColor,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onReport();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red.shade400),
                title: CommonText(
                  text: 'Delete',
                  fontSize: 0.016.sh,
                  color: Colors.red.shade400,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onDelete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comment header
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: Image.asset(
                ImageAssets.userProfileImg,
                height: 0.04.sh,
                width: 0.08.sw,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 0.03.sw),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: 'Anonymous',
                    fontSize: 0.014.sh,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.whiteColor,
                  ),
                  CommonText(
                    text: _formatTime(comment.createdAt),
                    fontSize: 0.011.sh,
                    color: AppPallete.whiteColor.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showOptions(context),
              child: Padding(
                padding: EdgeInsets.all(0.01.sh),
                child: SvgPicture.asset(IconAssets.menuIcon),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.008.sh),

        // Comment text
        Padding(
          padding: EdgeInsets.only(left: 0.11.sw),
          child: CommonText(
            text: comment.text,
            fontSize: 0.014.sh,
            fontWeight: FontWeight.w400,
            color: AppPallete.whiteColor.withOpacity(0.9),
            maxLine: 10,
          ),
        ),
        SizedBox(height: 0.008.sh),

        // Reply button
        Padding(
          padding: EdgeInsets.only(left: 0.11.sw),
          child: GestureDetector(
            onTap: onReply,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  IconAssets.replyIcon,
                  width: 0.015.sh,
                  height: 0.015.sh,
                ),
                SizedBox(width: 0.015.sw),
                CommonText(
                  text: 'Reply',
                  fontSize: 0.012.sh,
                  fontWeight: FontWeight.w500,
                  color: AppPallete.whiteColor.withOpacity(0.7),
                ),
                if (replies.isNotEmpty) ...[
                  SizedBox(width: 0.03.sw),
                  CommonText(
                    text:
                        '${replies.length} ${replies.length == 1 ? 'reply' : 'replies'}',
                    fontSize: 0.011.sh,
                    color: AppPallete.primaryColor.withOpacity(0.8),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Replies
        if (replies.isNotEmpty) ...[
          SizedBox(height: 0.012.sh),
          ...replies.map(
            (reply) => Padding(
              padding: EdgeInsets.only(left: 0.06.sw),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 0.03.sw),
                      child: SizedBox(
                        width: 2.w,
                        child: CustomPaint(
                          painter: _VerticalDottedLinePainter(
                            color: AppPallete.whiteColor.withOpacity(0.3),
                            dashHeight: 4,
                            gap: 3,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _ReplyTile(
                        reply: reply,
                        onReply: () => controller.startReply(reply),
                        onReport: onReport,
                        onDelete: () =>
                            controller.deleteComment(context, reply.id!),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ReplyTile extends StatelessWidget {
  final CommentModel reply;
  final VoidCallback onReply;
  final VoidCallback onReport;
  final VoidCallback onDelete;

  const _ReplyTile({
    required this.reply,
    required this.onReply,
    required this.onReport,
    required this.onDelete,
  });

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.012.sh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Image.asset(
                  ImageAssets.userProfileImg,
                  height: 0.03.sh,
                  width: 0.06.sw,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 0.02.sw),
              Expanded(
                child: Row(
                  children: [
                    CommonText(
                      text: 'Anonymous',
                      fontSize: 0.012.sh,
                      fontWeight: FontWeight.w600,
                      color: AppPallete.whiteColor,
                    ),
                    SizedBox(width: 0.02.sw),
                    CommonText(
                      text: _formatTime(reply.createdAt),
                      fontSize: 0.01.sh,
                      color: AppPallete.whiteColor.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 0.005.sh),
          Padding(
            padding: EdgeInsets.only(left: 0.08.sw),
            child: CommonText(
              text: reply.text,
              fontSize: 0.013.sh,
              color: AppPallete.whiteColor.withOpacity(0.85),
              maxLine: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDottedLinePainter extends CustomPainter {
  final Color color;
  final double dashHeight;
  final double gap;

  _VerticalDottedLinePainter({
    required this.color,
    this.dashHeight = 4,
    this.gap = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width
      ..style = PaintingStyle.fill;

    double y = 0;
    while (y < size.height) {
      final segmentHeight = (y + dashHeight).clamp(0, size.height) - y;
      if (segmentHeight > 0) {
        canvas.drawRect(Rect.fromLTWH(0, y, size.width, segmentHeight), paint);
      }
      y += dashHeight + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
