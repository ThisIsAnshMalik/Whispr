import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

class OrSeparator extends StatelessWidget {
  const OrSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppPallete.whiteColor.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
          child: CommonText(
            text: 'OR',
            fontSize: 0.016.sh,
            fontWeight: FontWeight.w500,
            color: AppPallete.whiteColor,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppPallete.whiteColor.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
