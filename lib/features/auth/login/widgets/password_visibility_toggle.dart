import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';

class PasswordVisibilityToggle extends StatelessWidget {
  final VoidCallback onTap;

  const PasswordVisibilityToggle({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(0.02.sw),
        child: SvgPicture.asset(
          IconAssets.visibilityIcon,
          width: 0.04.sw,
          height: 0.04.sw,
        ),
      ),
    );
  }
}
