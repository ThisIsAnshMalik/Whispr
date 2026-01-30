// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_app_bar.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/share_confession/widgets/allow_comments_section.dart';
import 'package:whispr_app/features/share_confession/widgets/agreement_checkboxes.dart';
import 'package:whispr_app/features/share_confession/widgets/caption_section.dart';
import 'package:whispr_app/features/share_confession/widgets/share_confession_button.dart';
import 'package:whispr_app/features/share_confession/widgets/upload_confession_section.dart';
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
                    UploadConfessionSection(),
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
                          ShareConfessionButton(onTap: _onShareConfession),
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
