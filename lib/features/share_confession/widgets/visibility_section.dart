// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

enum VisibilityOption { blurFace, showFace }

class VisibilitySection extends StatelessWidget {
  final VisibilityOption value;
  final ValueChanged<VisibilityOption> onChanged;

  const VisibilitySection({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Your Visibility',
          fontSize: 0.015.sh,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 0.012.sh),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppPallete.whiteColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            children: [
              _VisibilityTile(
                option: VisibilityOption.blurFace,
                label: 'Blur my face (recommended)',
                isSelected: value == VisibilityOption.blurFace,
                onTap: () => onChanged(VisibilityOption.blurFace),
              ),
              Divider(
                height: 1,
                color: AppPallete.blackTextColor.withOpacity(0.2),
              ),
              _VisibilityTile(
                option: VisibilityOption.showFace,
                label: 'Show my face',
                isSelected: value == VisibilityOption.showFace,
                onTap: () => onChanged(VisibilityOption.showFace),
              ),
            ],
          ),
        ),
        SizedBox(height: 0.008.sh),
        CommonText(
          text: 'You decide how much of yourself to share',
          fontSize: 0.011.sh,
          fontWeight: FontWeight.w600,
          color: AppPallete.whiteColor.withOpacity(0.85),
        ),
      ],
    );
  }
}

class _VisibilityTile extends StatelessWidget {
  final VisibilityOption option;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VisibilityTile({
    required this.option,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.02.sh),
        child: Row(
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                colors: [AppPallete.primaryColor, AppPallete.secondaryColor],
              ).createShader(bounds),
              child: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                size: 0.028.sh,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 0.02.sw),

            isSelected
                ? CommonText(
                    text: label,
                    fontSize: 0.015.sh,
                    fontWeight: FontWeight.w700,
                    color: AppPallete.blackTextColor,
                  )
                : CommonText(
                    text: label,
                    fontSize: 0.015.sh,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.blackTextColor,
                  ),
          ],
        ),
      ),
    );
  }
}
