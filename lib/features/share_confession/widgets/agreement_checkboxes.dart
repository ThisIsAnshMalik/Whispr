// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/features/share_confession/widgets/agreement_checkbox.dart';

class AgreementCheckboxes extends StatelessWidget {
  final bool agreeRules;
  final bool acceptResponsibility;
  final bool consentModeration;
  final ValueChanged<bool?> onAgreeRulesChanged;
  final ValueChanged<bool?> onAcceptResponsibilityChanged;
  final ValueChanged<bool?> onConsentModerationChanged;

  const AgreementCheckboxes({
    super.key,
    required this.agreeRules,
    required this.acceptResponsibility,
    required this.consentModeration,
    required this.onAgreeRulesChanged,
    required this.onAcceptResponsibilityChanged,
    required this.onConsentModerationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AgreementCheckbox(
          value: agreeRules,
          onChanged: onAgreeRulesChanged,
          label: 'I Agree to platform rules & policies',
        ),
        SizedBox(height: 0.01.sh),
        AgreementCheckbox(
          value: acceptResponsibility,
          onChanged: onAcceptResponsibilityChanged,
          label: 'I Accept content responsibility',
        ),
        SizedBox(height: 0.01.sh),
        AgreementCheckbox(
          value: consentModeration,
          onChanged: onConsentModerationChanged,
          label: 'I consent to moderation and removal',
        ),
      ],
    );
  }
}
