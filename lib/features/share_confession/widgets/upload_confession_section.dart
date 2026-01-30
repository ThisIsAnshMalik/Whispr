// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class _DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dotSpacing;

  _DottedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.radius = 20,
    this.dotSpacing = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );
    final pathMetric = path.computeMetrics().first;
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var i = 0.0; i < pathMetric.length; i += strokeWidth + dotSpacing) {
      final tangent = pathMetric.getTangentForOffset(i)!;
      canvas.drawCircle(tangent.position, strokeWidth / 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DottedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dotSpacing != dotSpacing;
}

class UploadConfessionSection extends StatelessWidget {
  final XFile? selectedVideo;
  final ValueChanged<XFile?>? onVideoSelected;

  const UploadConfessionSection({
    super.key,
    this.selectedVideo,
    this.onVideoSelected,
  });

  Future<void> _pickVideo(BuildContext context, ImageSource source) async {
    Navigator.of(context).pop();
    try {
      final picker = ImagePicker();
      final file = await picker.pickVideo(source: source);
      onVideoSelected?.call(file);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick video: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.symmetric(vertical: 0.02.sh, horizontal: 0.04.sw),
        decoration: BoxDecoration(
          color: AppPallete.whiteColor.withOpacity(0.95),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 0.01.sh),
              CommonText(
                text: 'Upload Video',
                fontSize: 0.018.sh,
                fontWeight: FontWeight.w700,
                color: AppPallete.blackTextColor,
              ),
              SizedBox(height: 0.02.sh),
              _OptionTile(
                icon: Icons.photo_library_outlined,
                label: 'Choose from gallery',
                onTap: () => _pickVideo(context, ImageSource.gallery),
              ),
              _OptionTile(
                icon: Icons.videocam_outlined,
                label: 'Record video',
                onTap: () => _pickVideo(context, ImageSource.camera),
              ),
              SizedBox(height: 0.02.sh),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = selectedVideo != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasVideo) ...[
          _VideoPreviewTile(
            file: selectedVideo!,
            onClear: () => onVideoSelected?.call(null),
          ),
          SizedBox(height: 0.01.sh),
        ],
        GestureDetector(
          onTap: () => _showUploadOptions(context),
          child: CustomPaint(
            painter: _DottedBorderPainter(
              color: AppPallete.whiteColor.withOpacity(0.4),
              strokeWidth: 1.5,
              radius: 20.r,
              dotSpacing: 4,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 0.03.sh,
                horizontal: 0.04.sw,
              ),
              decoration: BoxDecoration(
                color: AppPallete.whiteColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  SvgPicture.asset(IconAssets.uploadIcon),
                  SizedBox(height: 0.01.sh),
                  CommonText(
                    text: hasVideo ? 'Change video' : 'Upload Your Confession',
                    fontSize: 0.014.sh,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 0.004.sh),
                  CommonText(
                    text: 'Audio or Video',
                    fontSize: 0.013.sh,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 0.002.sh),
                  CommonText(
                    text: 'Record now or choose from your device',
                    fontSize: 0.012.sh,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.whiteColor.withOpacity(0.85),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppPallete.primaryColor, size: 0.03.sh),
      title: CommonText(
        text: label,
        fontSize: 0.016.sh,
        fontWeight: FontWeight.w600,
        color: AppPallete.blackTextColor,
      ),
      onTap: onTap,
    );
  }
}

class _VideoPreviewTile extends StatelessWidget {
  final XFile file;
  final VoidCallback onClear;

  const _VideoPreviewTile({required this.file, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final name = file.name;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.015.sh),
      decoration: BoxDecoration(
        color: AppPallete.whiteColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppPallete.whiteColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.videocam, color: AppPallete.whiteColor, size: 0.035.sh),
          SizedBox(width: 0.03.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText(
                  text: 'Video selected',
                  fontSize: 0.012.sh,
                  fontWeight: FontWeight.w500,
                  color: AppPallete.whiteColor.withOpacity(0.85),
                ),
                CommonText(
                  text: name.isNotEmpty ? name : 'Video file',
                  fontSize: 0.014.sh,
                  fontWeight: FontWeight.w600,
                  maxLine: 1,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClear,
            icon: Icon(
              Icons.close,
              color: AppPallete.whiteColor.withOpacity(0.9),
              size: 0.025.sh,
            ),
          ),
        ],
      ),
    );
  }
}
