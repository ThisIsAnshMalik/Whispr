import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/auth/login_screen.dart';
import 'package:whispr_app/features/onboarding/screen/platform_rules_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    // Pre-fill with example data as shown in the design
    _emailController.text = 'john_lesly10@gmail.com';
    _validateEmail();
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      _isEmailValid =
          email.isNotEmpty && email.contains('@') && email.contains('.');
    });
  }

  void _handleSignup(BuildContext context) {
    // Validate email and password
    if (!_isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Add actual authentication logic here
    // For now, navigate to platform rules screen
    _navigateToPlatformRules(context);
  }

  void _handleSocialSignup(BuildContext context, String provider) {
    // TODO: Add actual social authentication logic here
    // For now, navigate to platform rules screen
    _navigateToPlatformRules(context);
  }

  void _navigateToPlatformRules(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PlatformRulesScreen()),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
          child: Column(
            children: [
              SizedBox(height: 0.05.sh),
              // Logo
              Image.asset(
                ImageAssets.whisprImage,
                width: 0.25.sw,
                height: 0.25.sw,
              ),
              SizedBox(height: 0.02.sh),
              // App Name
              CommonText(
                text: 'WHISPR',
                fontSize: 0.04.sh,
                fontWeight: FontWeight.w700,
                color: AppPallete.whiteColor,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.015.sh),
              // Title
              CommonText(
                text: 'Create an account',
                fontSize: 0.024.sh,
                fontWeight: FontWeight.w700,
                color: AppPallete.whiteColor,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.01.sh),
              // Subtitle
              CommonText(
                text: 'Share only when you\'re ready',
                fontSize: 0.018.sh,
                fontWeight: FontWeight.w500,
                color: AppPallete.whiteColor,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.05.sh),
              // Email Input Field
              _buildInputField(
                label: 'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                suffixIcon: _isEmailValid
                    ? Container(
                        margin: EdgeInsets.only(right: 0.02.sw),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPallete.blackColor.withOpacity(0.3),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(0.015.sw),
                          child: SvgPicture.asset(
                            IconAssets.checkIcon,
                            width: 0.03.sw,
                            height: 0.03.sw,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(height: 0.025.sh),
              // Password Input Field
              _buildInputField(
                label: 'Enter your password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(0.02.sw),
                    child: SvgPicture.asset(
                      IconAssets.visibilityIcon,
                      width: 0.04.sw,
                      height: 0.04.sw,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.04.sh),
              // Create Account Button
              GestureDetector(
                onTap: () {
                  _handleSignup(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 0.065.sh,
                  decoration: BoxDecoration(
                    color: AppPallete.whiteColor,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Center(
                    child: CommonText(
                      text: 'Create Account',
                      fontSize: 0.02.sh,
                      fontWeight: FontWeight.w700,
                      color: AppPallete.blackTextColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.025.sh),
              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonText(
                    text: 'Already have an account? ',
                    fontSize: 0.016.sh,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.whiteColor,
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigateToLogin(context);
                    },
                    child: CommonText(
                      text: 'Sign In',
                      fontSize: 0.016.sh,
                      fontWeight: FontWeight.w600,
                      color: AppPallete.whiteColor.withOpacity(0.9),
                      textDecoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.04.sh),
              // OR Separator
              Row(
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
              ),
              SizedBox(height: 0.04.sh),
              // Google Sign Up Button
              _buildSocialButton(
                icon: IconAssets.googleIcon,
                text: 'Sign up with Google',
                backgroundColor: AppPallete.whiteColor,
                textColor: AppPallete.blackTextColor,
                onTap: () {
                  _handleSocialSignup(context, 'Google');
                },
              ),
              SizedBox(height: 0.02.sh),
              // Apple Sign Up Button
              _buildSocialButton(
                icon: IconAssets.appleIcon,
                text: 'Sign up with Apple',
                backgroundColor: AppPallete.blackColor.withOpacity(0.8),
                textColor: AppPallete.whiteColor,
                onTap: () {
                  _handleSocialSignup(context, 'Apple');
                },
              ),
              SizedBox(height: 0.05.sh),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: label,
          fontSize: 0.016.sh,
          fontWeight: FontWeight.w500,
          color: AppPallete.whiteColor,
        ),
        SizedBox(height: 0.01.sh),
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 0.065.sh,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppPallete.whiteColor.withOpacity(0.25),
                    AppPallete.whiteColor.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppPallete.whiteColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style: TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 0.018.sh,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0.04.sw,
                    vertical: 0.02.sh,
                  ),
                  border: InputBorder.none,
                  suffixIcon: suffixIcon,
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 0.1.sw,
                    minHeight: 0.05.sh,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 0.065.sh,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 0.05.sw, height: 0.05.sw),
            SizedBox(width: 0.03.sw),
            CommonText(
              text: text,
              fontSize: 0.018.sh,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
