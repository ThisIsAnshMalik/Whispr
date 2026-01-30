// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class AgreementCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;

  const AgreementCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 0.05.sw,
            height: 0.05.sw,
            decoration: BoxDecoration(
              color: value ? Color(0xffd9d9d9) : Colors.transparent,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: AppPallete.whiteColor, width: 1.5),
            ),
            child: value
                ? Icon(Icons.check, size: 0.014.sh, color: Colors.black)
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
}
