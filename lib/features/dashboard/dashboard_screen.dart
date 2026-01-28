// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whispr_app/core/common/common_filter_box.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/home/home_screen.dart';
import 'package:whispr_app/features/dashboard/share_confession_screen.dart';
import 'package:whispr_app/features/dashboard/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.index = 0});
  final int index;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  StreamSubscription? _sub;
  Uri? initialUri;
  late int _currentIndex;

  List<Widget> screens = <Widget>[
    const HomeScreen(),
    const ShareConfessionScreen(),
    const ProfileScreen(),
  ];

  Widget getCurrentScreen(int idxVal) {
    switch (idxVal) {
      case 0:
        return screens[0];

      case 1:
        return screens[1];

      case 2:
        return screens[2];

      default:
        return Container();
    }
  }

  @override
  void initState() {
    _currentIndex = widget.index;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: false,
        child: Stack(
          children: [
            // Main content that fills the entire screen
            Positioned.fill(child: getCurrentScreen(_currentIndex)),
            // Floating bottom navigation bar
            Positioned(
              bottom: 0.0.sh,
              left: 0.0.sw,
              right: 0.0.sw,
              child: FrostedGlassBox(
                theWidth: double.infinity,
                theHeight: 0.11.sh,
                theChild: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DashboardValue(
                        currentIndex: _currentIndex,
                        value: 0,
                        selectedIcon: IconAssets.homeIcon,
                        unSelectedIcon: IconAssets.homeIcon,
                        lable: "Home",
                        onTap: () {
                          debugPrint('Home tapped');
                          setState(() {
                            _currentIndex = 0;
                          });
                        },
                      ),
                      DashboardValue(
                        currentIndex: _currentIndex,
                        value: 1,
                        selectedIcon: IconAssets.addIcon,
                        unSelectedIcon: IconAssets.addIcon,
                        lable: "Share",
                        onTap: () {
                          debugPrint('Home tapped');
                          setState(() {
                            _currentIndex = 1;
                          });
                        },
                      ),
                      DashboardValue(
                        currentIndex: _currentIndex,
                        value: 2,
                        selectedIcon: IconAssets.profileIcon,
                        unSelectedIcon: IconAssets.profileIcon,
                        lable: "Profile",
                        onTap: () {
                          debugPrint('Home tapped');
                          setState(() {
                            _currentIndex = 2;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardValue extends StatelessWidget {
  const DashboardValue({
    super.key,
    required this.currentIndex,
    required this.value,
    required this.selectedIcon,
    required this.lable,
    required this.unSelectedIcon,
    required this.onTap,
    this.isNotifi = false,
  });

  final int currentIndex;
  final int value;
  final String selectedIcon;
  final String unSelectedIcon;
  final String lable;
  final bool isNotifi;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == value;
    return InkWell(
      onTap: onTap,

      child: Container(
        width: 0.15.sw,
        height: 0.07.sh,
        padding: EdgeInsets.symmetric(vertical: 0.008.sh),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppPallete.primaryColor, AppPallete.secondaryColor],
                )
              : null,
        ),
        child: Center(
          child: SvgPicture.asset(
            isSelected ? selectedIcon : unSelectedIcon,
            height: 0.028.sh,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class AppColors {}
