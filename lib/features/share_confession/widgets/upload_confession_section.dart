// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

enum ConfessionMediaType { video, audio }

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
  final XFile? selectedFile;
  final ConfessionMediaType? mediaType;
  final ValueChanged<(XFile?, ConfessionMediaType?)>? onMediaSelected;

  const UploadConfessionSection({
    super.key,
    this.selectedFile,
    this.mediaType,
    this.onMediaSelected,
  });

  Future<void> _pickVideo(BuildContext context, ImageSource source) async {
    Navigator.of(context).pop();
    try {
      final picker = ImagePicker();
      final file = await picker.pickVideo(source: source);
      onMediaSelected?.call((
        file,
        file != null ? ConfessionMediaType.video : null,
      ));
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

  Future<void> _pickAudio(BuildContext context) async {
    Navigator.of(context).pop();
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );
      if (result?.files.single.path != null) {
        final path = result!.files.single.path!;
        onMediaSelected?.call((XFile(path), ConfessionMediaType.audio));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick audio: $e'),
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
                text: 'Upload Video or Audio',
                fontSize: 0.018.sh,
                fontWeight: FontWeight.w700,
                color: AppPallete.blackTextColor,
              ),
              SizedBox(height: 0.02.sh),
              CommonText(
                text: 'Video',
                fontSize: 0.012.sh,
                fontWeight: FontWeight.w600,
                color: AppPallete.blackTextColor.withOpacity(0.7),
              ),
              SizedBox(height: 0.008.sh),
              _OptionTile(
                icon: Icons.photo_library_outlined,
                label: 'Choose video from gallery',
                onTap: () => _pickVideo(context, ImageSource.gallery),
              ),
              _OptionTile(
                icon: Icons.videocam_outlined,
                label: 'Record video',
                onTap: () => _pickVideo(context, ImageSource.camera),
              ),
              SizedBox(height: 0.015.sh),
              CommonText(
                text: 'Audio',
                fontSize: 0.012.sh,
                fontWeight: FontWeight.w600,
                color: AppPallete.blackTextColor.withOpacity(0.7),
              ),
              SizedBox(height: 0.008.sh),
              _OptionTile(
                icon: Icons.audiotrack_outlined,
                label: 'Choose audio from device',
                onTap: () => _pickAudio(context),
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
    final hasMedia = selectedFile != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasMedia && mediaType == ConfessionMediaType.video) ...[
          _VideoPreviewTile(
            file: selectedFile!,
            onClear: () => onMediaSelected?.call((null, null)),
          ),
          SizedBox(height: 0.01.sh),
        ],
        if (hasMedia && mediaType == ConfessionMediaType.audio) ...[
          _AudioPreviewTile(
            file: selectedFile!,
            onClear: () => onMediaSelected?.call((null, null)),
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
                    text: hasMedia ? 'Change media' : 'Upload Your Confession',
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
                    text: 'Record or choose from your device',
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

class _AudioPreviewTile extends StatelessWidget {
  final XFile file;
  final VoidCallback onClear;

  const _AudioPreviewTile({required this.file, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final name = file.path.split('/').last;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0.02.sh, horizontal: 0.04.sw),
        decoration: BoxDecoration(
          color: AppPallete.whiteColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppPallete.whiteColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 0.12.sh,
              height: 0.12.sh,
              decoration: BoxDecoration(
                color: AppPallete.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.audiotrack_rounded,
                color: AppPallete.primaryColor,
                size: 0.06.sh,
              ),
            ),
            SizedBox(width: 0.03.sw),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonText(
                    text: 'Audio confession',
                    fontSize: 0.014.sh,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.whiteColor,
                  ),
                  SizedBox(height: 0.004.sh),
                  CommonText(
                    text: name,
                    fontSize: 0.012.sh,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.whiteColor.withOpacity(0.8),
                    maxLine: 1,
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: onClear,
                icon: Icon(
                  Icons.close,
                  color: AppPallete.whiteColor,
                  size: 0.022.sh,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: 0.06.sw,
                  minHeight: 0.06.sw,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoPreviewTile extends StatefulWidget {
  final XFile file;
  final VoidCallback onClear;

  const _VideoPreviewTile({required this.file, required this.onClear});

  @override
  State<_VideoPreviewTile> createState() => _VideoPreviewTileState();
}

class _VideoPreviewTileState extends State<_VideoPreviewTile> {
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    final path = widget.file.path;
    if (path.isEmpty) return;
    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 512,
        quality: 75,
      );
      if (mounted) setState(() => _thumbnailBytes = bytes);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail background
            if (_thumbnailBytes != null)
              Image.memory(_thumbnailBytes!, fit: BoxFit.cover)
            else
              Container(
                color: AppPallete.primaryColor.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppPallete.whiteColor,
                    strokeWidth: 2,
                  ),
                ),
              ),
            // Dark gradient overlay for text readability
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                ),
              ),
            ),
            // Center play button
            Center(
              child: Container(
                width: 0.14.sh,
                height: 0.14.sh,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppPallete.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: AppPallete.primaryColor,
                  size: 0.08.sh,
                ),
              ),
            ),
            // Bottom text
            Positioned(
              left: 0,
              right: 0,
              bottom: 0.02.sh,
              child: Center(
                child: CommonText(
                  text: 'This is your confession',
                  fontSize: 0.016.sh,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.whiteColor,
                ),
              ),
            ),
            // Clear button
            Positioned(
              top: 0.01.sh,
              right: 0.02.sw,
              child: Material(
                color: Colors.black.withOpacity(0.4),
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: widget.onClear,
                  icon: Icon(
                    Icons.close,
                    color: AppPallete.whiteColor,
                    size: 0.022.sh,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 0.06.sw,
                    minHeight: 0.06.sw,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
