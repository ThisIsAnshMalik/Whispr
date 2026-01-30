// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/common/report_content_bottom_sheet.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

void showCommentsBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => const _CommentsBottomSheet(),
  );
}

class _CommentsBottomSheet extends StatefulWidget {
  const _CommentsBottomSheet();

  @override
  State<_CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<_CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  static const List<Map<String, dynamic>> _sampleComments = [
    {
      'text': "It takes courage to say this out loud. I'm glad you shared.",
      'reply': {'text': 'reply first'},
    },
    {'text': "Thank you for trusting this space with something so personal."},
    {'text': "Your feelings make sense. I'm holding space for you."},
    {'text': "I'm glad you spoke instead of keeping it inside."},
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.7.sh,
      decoration: BoxDecoration(
        color: AppPallete.blackTextColor.withOpacity(0.95),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
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
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
              itemCount: _sampleComments.length,
              separatorBuilder: (_, __) => SizedBox(height: 0.02.sh),
              itemBuilder: (context, index) {
                final comment = _sampleComments[index];
                return _CommentTile(
                  text: comment['text']!,
                  reply: comment['reply'],
                  onReport: () {
                    Navigator.of(context).pop();
                    showReportContentBottomSheet(context);
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 0.04.sw,
              vertical: 0.03.sh,
            ),
            decoration: BoxDecoration(color: AppPallete.blackTextColor),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.03.sw,
                    vertical: 0.02.sh,
                  ),
                  child: SvgPicture.asset(IconAssets.sendIcon),
                ),
                hintText: 'Add a comment...',
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
                    color: Color(0xffF4F1FF).withOpacity(0.3),
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
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final String text;
  final Map<String, dynamic>? reply;
  final VoidCallback onReport;

  const _CommentTile({required this.text, required this.onReport, this.reply});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            SizedBox(width: 0.04.sw),
            CommonText(
              text: 'Anonymous',
              fontSize: 0.016.sh,
              fontWeight: FontWeight.w600,
              color: AppPallete.whiteColor,
            ),
            Spacer(),
            SvgPicture.asset(IconAssets.menuIcon),
          ],
        ),
        SizedBox(height: 0.004.sh),
        CommonText(
          text: text,
          fontSize: 0.014.sh,
          fontWeight: FontWeight.w500,
          color: AppPallete.whiteColor.withOpacity(0.9),
        ),
        SizedBox(height: 0.006.sh),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(IconAssets.replyIcon),
            SizedBox(width: 0.01.sw),
            CommonText(
              text: 'Reply',
              fontSize: 0.0115.sh,
              fontWeight: FontWeight.w400,
              color: AppPallete.whiteColor.withOpacity(0.8),
            ),
          ],
        ),

        if (reply != null) ...[
          SizedBox(height: 0.005.sh),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0.003.sw, right: 0.05.sw),
                  child: SizedBox(
                    width: 2.w,
                    child: CustomPaint(
                      painter: _VerticalDottedLinePainter(
                        color: AppPallete.whiteColor.withOpacity(0.5),
                        dashHeight: 4,
                        gap: 3,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _CommentTile(
                    text:
                        "I don’t have advice, just empathy — and I’m listening.",
                    // reply: comment['reply'],
                    onReport: () {
                      Navigator.of(context).pop();
                      showReportContentBottomSheet(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
