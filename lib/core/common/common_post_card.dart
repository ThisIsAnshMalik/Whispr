// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/common/common_user_avatar.dart';
import 'package:whispr_app/core/common/comments_bottom_sheet.dart';
import 'package:whispr_app/core/common/media_player_screen.dart';
import 'package:whispr_app/core/common/report_content_bottom_sheet.dart';
import 'package:whispr_app/core/controllers/posts_controller.dart';
import 'package:whispr_app/core/models/post_model.dart';
import 'package:whispr_app/core/services/local_database_service.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final bool isMyPost;

  const PostCard({super.key, required this.post, this.isMyPost = false});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _commentCount = 0;
  Uint8List? _videoThumbnail;

  @override
  void initState() {
    super.initState();
    _loadCommentCount();
    _loadVideoThumbnail();
  }

  Future<void> _loadCommentCount() async {
    if (widget.post.id == null) return;
    final count = await LocalDatabaseService.instance.countCommentsForPost(
      widget.post.postIdString,
    );
    if (mounted) setState(() => _commentCount = count);
  }

  Future<void> _loadVideoThumbnail() async {
    if (widget.post.mediaType != 'video' || widget.post.mediaPath == null) {
      return;
    }
    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: widget.post.mediaPath!,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 512,
        quality: 75,
      );
      if (mounted && bytes != null) {
        setState(() => _videoThumbnail = bytes);
      }
    } catch (_) {}
  }

  String _formatTimeAgo(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  void _handleLike() {
    if (widget.post.id != null) {
      PostsController.to.toggleLike(context, widget.post.id!);
    }
  }

  void _showEditDialog() {
    final controller = TextEditingController(text: widget.post.caption);
    Get.dialog(
      AlertDialog(
        backgroundColor: AppPallete.blackTextColor,
        title: CommonText(
          text: 'Edit Confession',
          fontSize: 0.02.sh,
          fontWeight: FontWeight.w600,
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          style: TextStyle(color: AppPallete.whiteColor, fontSize: 0.014.sh),
          decoration: InputDecoration(
            hintText: 'Update your caption...',
            hintStyle: TextStyle(color: AppPallete.whiteColor.withOpacity(0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppPallete.whiteColor.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppPallete.primaryColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CommonText(text: 'Cancel', color: AppPallete.whiteColor),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty && widget.post.id != null) {
                Get.back();
                await PostsController.to.updateCaption(
                  context,
                  widget.post.id!,
                  controller.text.trim(),
                );
              }
            },
            child: CommonText(
              text: 'Save',
              color: AppPallete.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppPallete.blackTextColor,
        title: CommonText(
          text: 'Delete Confession',
          fontSize: 0.02.sh,
          fontWeight: FontWeight.w600,
        ),
        content: CommonText(
          text:
              'Are you sure you want to delete this confession? This action cannot be undone.',
          maxLine: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CommonText(text: 'Cancel', color: AppPallete.whiteColor),
          ),
          TextButton(
            onPressed: () async {
              if (widget.post.id != null) {
                Get.back();
                await PostsController.to.deletePost(context, widget.post.id!);
              }
            },
            child: CommonText(
              text: 'Delete',
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) {
    if (value == 'edit') {
      _showEditDialog();
    } else if (value == 'delete') {
      _showDeleteDialog();
    }
  }

  void _playMedia() {
    if (widget.post.mediaPath == null || widget.post.mediaPath!.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaPlayerScreen(
          mediaPath: widget.post.mediaPath!,
          isVideo: widget.post.mediaType == 'video',
          caption: widget.post.caption,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final hasMedia = post.mediaPath != null && post.mediaPath!.isNotEmpty;
    final isVideo = post.mediaType == 'video';
    final isAudio = post.mediaType == 'audio';

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
          // Header row
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
                    text: _formatTimeAgo(post.createdAt),
                    fontWeight: FontWeight.w600,
                    fontSize: 0.01084.sh,
                  ),
                ],
              ),
              Spacer(),
              if (!widget.isMyPost)
                GestureDetector(
                  onTap: () => showReportContentBottomSheet(context),
                  child: ClipRRect(
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
                ),
              if (widget.isMyPost)
                GestureDetector(
                  onTapDown: (details) {
                    final position = RelativeRect.fromLTRB(
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                      MediaQuery.of(context).size.width -
                          details.globalPosition.dx,
                      MediaQuery.of(context).size.height -
                          details.globalPosition.dy,
                    );
                    showMenu<String>(
                      context: context,
                      position: position,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      color: AppPallete.whiteColor,
                      elevation: 8,
                      items: [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              SvgPicture.asset(IconAssets.editConfessionIcon),
                              SizedBox(width: 0.02.sw),
                              CommonText(
                                text: 'Edit Confession',
                                fontSize: 0.012.sh,
                                fontWeight: FontWeight.w600,
                                color: AppPallete.blackTextColor,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              SvgPicture.asset(IconAssets.deleteConfessionIcon),
                              SizedBox(width: 0.02.sw),
                              CommonText(
                                text: 'Delete Confession',
                                fontSize: 0.012.sh,
                                fontWeight: FontWeight.w600,
                                color: AppPallete.blackTextColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).then((value) {
                      if (value != null) {
                        _handleMenuSelection(value);
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(0.01.sh),
                    child: SvgPicture.asset(IconAssets.menuIcon),
                  ),
                ),
            ],
          ),
          SizedBox(height: 0.01.sh),

          // Caption
          Align(
            alignment: Alignment.centerLeft,
            child: CommonText(
              text: post.caption,
              fontWeight: FontWeight.w600,
              fontSize: 0.01446.sh,
              maxLine: 5,
            ),
          ),

          // Media section
          if (hasMedia) ...[
            SizedBox(height: 0.01.sh),
            GestureDetector(
              onTap: _playMedia,
              child: Container(
                height: 0.2.sh,
                width: 1.sw,
                decoration: BoxDecoration(
                  color: AppPallete.whiteColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Media preview
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: _buildMediaPreview(isVideo, isAudio),
                    ),

                    // Play button
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

                    // Bottom stats bar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {}, // Prevent tap from bubbling to play
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
                              // Like button
                              GestureDetector(
                                onTap: _handleLike,
                                child: Row(
                                  children: [
                                    Icon(
                                      post.isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: post.isLiked
                                          ? Colors.red
                                          : AppPallete.whiteColor,
                                      size: 0.022.sh,
                                    ),
                                    SizedBox(width: 0.015.sw),
                                    CommonText(
                                      text: _formatCount(post.likes),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 0.014.sh,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 0.04.sw),
                              // Comments
                              SvgPicture.asset(IconAssets.commentIcon),
                              SizedBox(width: 0.015.sw),
                              CommonText(
                                text: _formatCount(_commentCount),
                                fontWeight: FontWeight.w600,
                                fontSize: 0.014.sh,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // No media - show stats inline
            SizedBox(height: 0.01.sh),
            Row(
              children: [
                GestureDetector(
                  onTap: _handleLike,
                  child: Row(
                    children: [
                      Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked
                            ? Colors.red
                            : AppPallete.whiteColor,
                        size: 0.022.sh,
                      ),
                      SizedBox(width: 0.015.sw),
                      CommonText(
                        text: _formatCount(post.likes),
                        fontWeight: FontWeight.w600,
                        fontSize: 0.014.sh,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 0.04.sw),
                SvgPicture.asset(IconAssets.commentIcon),
                SizedBox(width: 0.015.sw),
                CommonText(
                  text: _formatCount(_commentCount),
                  fontWeight: FontWeight.w600,
                  fontSize: 0.014.sh,
                ),
              ],
            ),
          ],

          // Comments section
          if (post.allowComments) ...[
            SizedBox(height: 0.01.sh),
            InkWell(
              onTap: () =>
                  showCommentsBottomSheet(context, postId: post.postIdString),
              child: Container(
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
                    CommonText(
                      text: "Add a comment...",
                      fontWeight: FontWeight.w500,
                      fontSize: 0.013.sh,
                      color: AppPallete.whiteColor.withOpacity(0.6),
                    ),
                    Spacer(),
                    CommonText(
                      text: "($_commentCount Comments)",
                      fontWeight: FontWeight.w500,
                      fontSize: 0.012.sh,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaPreview(bool isVideo, bool isAudio) {
    if (isVideo) {
      if (_videoThumbnail != null) {
        return Image.memory(
          _videoThumbnail!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } else if (widget.post.mediaPath != null) {
        return Container(
          color: AppPallete.primaryColor.withOpacity(0.3),
          child: Center(
            child: CircularProgressIndicator(
              color: AppPallete.whiteColor,
              strokeWidth: 2,
            ),
          ),
        );
      }
    }

    if (isAudio) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageAssets.audioExImg),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageAssets.videoExImg),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
