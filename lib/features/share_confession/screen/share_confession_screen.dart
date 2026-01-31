// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whispr_app/core/common/common_app_bar.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_snackbar.dart';
import 'package:whispr_app/core/controllers/posts_controller.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/dashboard/dashboard_screen.dart';
import 'package:whispr_app/features/share_confession/widgets/allow_comments_section.dart';
import 'package:whispr_app/features/share_confession/widgets/agreement_checkboxes.dart';
import 'package:whispr_app/features/share_confession/widgets/caption_section.dart';
import 'package:whispr_app/features/share_confession/widgets/share_confession_button.dart';
import 'package:whispr_app/features/share_confession/widgets/upload_confession_section.dart'
    show ConfessionMediaType, UploadConfessionSection;
import 'package:whispr_app/features/share_confession/widgets/visibility_section.dart'
    show VisibilityOption, VisibilitySection;

class ShareConfessionScreen extends StatefulWidget {
  const ShareConfessionScreen({super.key});

  @override
  State<ShareConfessionScreen> createState() => _ShareConfessionScreenState();
}

class _ShareConfessionScreenState extends State<ShareConfessionScreen> {
  VisibilityOption _visibility = VisibilityOption.blurFace;
  bool _allowComments = true;
  final TextEditingController _captionController = TextEditingController();
  bool _agreeRules = false;
  bool _acceptResponsibility = false;
  bool _consentModeration = false;
  XFile? _selectedFile;
  ConfessionMediaType? _mediaType;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _onShareConfession() async {
    // Validate terms agreement
    if (!_agreeRules || !_acceptResponsibility || !_consentModeration) {
      CommonSnackbar.showError(
        context,
        message: 'Please agree to all terms before sharing',
      );
      return;
    }

    // Validate caption
    if (_captionController.text.trim().isEmpty) {
      CommonSnackbar.showError(
        context,
        message: 'Please add a caption for your confession',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final success = await PostsController.to.createPost(
        context: context,
        caption: _captionController.text.trim(),
        mediaPath: _selectedFile?.path,
        mediaType: _mediaType?.name,
        visibility: _visibility.name,
        allowComments: _allowComments,
      );

      if (success && mounted) {
        // Reset form
        setState(() {
          _captionController.clear();
          _selectedFile = null;
          _mediaType = null;
          _visibility = VisibilityOption.blurFace;
          _allowComments = true;
          _agreeRules = false;
          _acceptResponsibility = false;
          _consentModeration = false;
        });
        // Navigate to home tab
        Get.offAll(() => const DashboardScreen(index: 0));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
        child: Column(
          children: [
            CommonAppBar(title: 'Share Confession', isNotification: true),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.02.sh),
                    UploadConfessionSection(
                      selectedFile: _selectedFile,
                      mediaType: _mediaType,
                      onMediaSelected: (value) => setState(() {
                        _selectedFile = value.$1;
                        _mediaType = value.$2;
                      }),
                    ),
                    SizedBox(height: 0.02.sh),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.04.sw,
                        vertical: 0.02.sh,
                      ),
                      decoration: BoxDecoration(
                        color: AppPallete.whiteColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        children: [
                          if (_mediaType == ConfessionMediaType.video) ...[
                            VisibilitySection(
                              value: _visibility,
                              onChanged: (v) => setState(() => _visibility = v),
                            ),
                            SizedBox(height: 0.02.sh),
                            Divider(
                              color: AppPallete.whiteColor.withOpacity(0.2),
                              height: 1,
                            ),
                            SizedBox(height: 0.02.sh),
                          ],
                          AllowCommentsSection(
                            value: _allowComments,
                            onChanged: (v) =>
                                setState(() => _allowComments = v),
                          ),
                          SizedBox(height: 0.02.sh),
                          CaptionSection(controller: _captionController),
                          SizedBox(height: 0.02.sh),
                          AgreementCheckboxes(
                            agreeRules: _agreeRules,
                            acceptResponsibility: _acceptResponsibility,
                            consentModeration: _consentModeration,
                            onAgreeRulesChanged: (v) =>
                                setState(() => _agreeRules = v ?? false),
                            onAcceptResponsibilityChanged: (v) => setState(
                              () => _acceptResponsibility = v ?? false,
                            ),
                            onConsentModerationChanged: (v) =>
                                setState(() => _consentModeration = v ?? false),
                          ),
                          SizedBox(height: 0.025.sh),
                          _isSubmitting
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppPallete.whiteColor,
                                  ),
                                )
                              : ShareConfessionButton(
                                  onTap: _onShareConfession,
                                ),
                        ],
                      ),
                    ),
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
