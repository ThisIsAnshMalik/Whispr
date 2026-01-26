// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/features/splash/service/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SplashService.navigateToOnboarding(context);
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(child: Image.asset(ImageAssets.whisprImage));
  }
}
