// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whispr_app/core/common/common_app_bar.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

enum VisibilityOption { blurFace, showFace }

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

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _onShareConfession() {
    if (!_agreeRules || !_acceptResponsibility || !_consentModeration) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please agree to all terms before sharing'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Confession shared successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.04.sw,
              vertical: 0.01.sh,
            ),
            child: CommonAppBar(
              title: 'Share Confession',
              isNotification: true,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUploadSection(),
                  SizedBox(height: 0.025.sh),
                  _buildVisibilitySection(),
                  SizedBox(height: 0.02.sh),
                  _buildAllowCommentsSection(),
                  SizedBox(height: 0.02.sh),
                  _buildCaptionSection(),
                  SizedBox(height: 0.02.sh),
                  _buildAgreementCheckboxes(),
                  SizedBox(height: 0.025.sh),
                  _buildShareButton(),
                  SizedBox(height: 0.04.sh),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 0.04.sh, horizontal: 0.04.sw),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppPallete.whiteColor.withOpacity(0.5),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 0.06.sh,
              color: AppPallete.whiteColor,
            ),
            SizedBox(height: 0.01.sh),
            CommonText(
              text: 'Upload Your Confession',
              fontSize: 0.018.sh,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 0.004.sh),
            CommonText(
              text: 'Audio or Video',
              fontSize: 0.014.sh,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 0.002.sh),
            CommonText(
              text: 'Record now or choose from your device',
              fontSize: 0.012.sh,
              fontWeight: FontWeight.w400,
              color: AppPallete.whiteColor.withOpacity(0.85),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Your Visibility',
          fontSize: 0.018.sh,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 0.012.sh),
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: AppPallete.whiteColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppPallete.whiteColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _visibilityTile(
                    option: VisibilityOption.blurFace,
                    label: 'Blur my face (recommended)',
                  ),
                  Divider(
                    height: 1,
                    color: AppPallete.whiteColor.withOpacity(0.2),
                  ),
                  _visibilityTile(
                    option: VisibilityOption.showFace,
                    label: 'Show my face',
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 0.008.sh),
        CommonText(
          text: 'You decide how much of yourself to share',
          fontSize: 0.012.sh,
          fontWeight: FontWeight.w400,
          color: AppPallete.whiteColor.withOpacity(0.85),
        ),
      ],
    );
  }

  Widget _visibilityTile({
    required VisibilityOption option,
    required String label,
  }) {
    final isSelected = _visibility == option;
    return InkWell(
      onTap: () => setState(() => _visibility = option),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.015.sh),
        decoration: BoxDecoration(
          color: isSelected
              ? AppPallete.primaryColor.withOpacity(0.4)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 0.028.sh,
              color: AppPallete.whiteColor,
            ),
            SizedBox(width: 0.03.sw),
            CommonText(
              text: label,
              fontSize: 0.015.sh,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllowCommentsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: 'Allow Comments',
          fontSize: 0.016.sh,
          fontWeight: FontWeight.w700,
        ),
        Switch(
          value: _allowComments,
          onChanged: (v) => setState(() => _allowComments = v),
          activeColor: AppPallete.whiteColor,
          activeTrackColor: AppPallete.primaryColor,
          inactiveThumbColor: AppPallete.whiteColor.withOpacity(0.7),
          inactiveTrackColor: AppPallete.whiteColor.withOpacity(0.2),
        ),
      ],
    );
  }

  Widget _buildCaptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Add caption',
          fontSize: 0.016.sh,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 0.01.sh),
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: AppPallete.whiteColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppPallete.whiteColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _captionController,
                maxLines: 4,
                style: GoogleFonts.montserrat(
                  color: AppPallete.whiteColor,
                  fontSize: 0.015.sh,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Say as much or as little as you want...',
                  hintStyle: GoogleFonts.montserrat(
                    color: AppPallete.whiteColor.withOpacity(0.5),
                    fontSize: 0.015.sh,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0.04.sw,
                    vertical: 0.015.sh,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreementCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _agreementCheckbox(
          value: _agreeRules,
          onChanged: (v) => setState(() => _agreeRules = v ?? false),
          label: 'I Agree to platform rules & policies',
        ),
        SizedBox(height: 0.01.sh),
        _agreementCheckbox(
          value: _acceptResponsibility,
          onChanged: (v) => setState(() => _acceptResponsibility = v ?? false),
          label: 'I Accept content responsibility',
        ),
        SizedBox(height: 0.01.sh),
        _agreementCheckbox(
          value: _consentModeration,
          onChanged: (v) => setState(() => _consentModeration = v ?? false),
          label: 'I consent to moderation and removal',
        ),
      ],
    );
  }

  Widget _agreementCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 0.05.sw,
            height: 0.05.sw,
            decoration: BoxDecoration(
              color: value ? AppPallete.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: AppPallete.whiteColor, width: 1.5),
            ),
            child: value
                ? Icon(
                    Icons.check,
                    size: 0.028.sh,
                    color: AppPallete.whiteColor,
                  )
                : null,
          ),
          SizedBox(width: 0.03.sw),
          Expanded(
            child: CommonText(
              text: label,
              fontSize: 0.014.sh,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: _onShareConfession,
      child: Container(
        width: double.infinity,
        height: 0.065.sh,
        decoration: BoxDecoration(
          color: AppPallete.whiteButtonColor,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: AppPallete.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: CommonText(
          text: 'Share Confession',
          fontSize: 0.02.sh,
          fontWeight: FontWeight.w700,
          color: AppPallete.primaryColor,
        ),
      ),
    );
  }
}
