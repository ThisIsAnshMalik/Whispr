import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Home',
              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            // Add your home screen content here
          ],
        ),
      ),
    );
  }
}
