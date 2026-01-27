// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/common/common_auth_header.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/auth/login/screen/login_screen.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_action_button.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_input_field.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_navigation_link.dart';
import 'package:whispr_app/features/auth/login/widgets/email_validation_icon.dart';
import 'package:whispr_app/features/auth/login/widgets/or_separator.dart';
import 'package:whispr_app/features/auth/login/widgets/password_visibility_toggle.dart';
import 'package:whispr_app/features/auth/login/widgets/social_button.dart';
import 'package:whispr_app/features/dashboard/dashboard_screen.dart';
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

    // Navigate to dashboard after successful signup
    _navigateToDashboard(context);
  }

  void _handleSocialSignup(BuildContext context, String provider) {
    // Navigate to dashboard after successful social signup
    _navigateToDashboard(context);
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
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
              CommonAuthHeader(
                title: 'Create an account\nShare only when you’re ready',
              ),
              SizedBox(height: 0.03.sh),
              AuthInputField(
                label: 'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                suffixIcon: _isEmailValid ? const EmailValidationIcon() : null,
              ),
              SizedBox(height: 0.02.sh),
              AuthInputField(
                label: 'Enter your password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                suffixIcon: PasswordVisibilityToggle(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              SizedBox(height: 0.03.sh),
              AuthActionButton(
                text: 'Create Account',
                onTap: () => _handleSignup(context),
                isGradient: false,
              ),
              SizedBox(height: 0.02.sh),
              AuthNavigationLink(
                prefixText: 'Already have an account? ',
                linkText: 'Sign In',
                onTap: () => _navigateToLogin(context),
              ),
              SizedBox(height: 0.01.sh),
              const OrSeparator(),
              SizedBox(height: 0.01.sh),
              SocialButton(
                icon: IconAssets.googleIcon,
                text: 'Sign up with Google',
                backgroundColor: AppPallete.whiteColor,
                textColor: AppPallete.blackTextColor,
                onTap: () => _handleSocialSignup(context, 'Google'),
              ),
              SizedBox(height: 0.01.sh),
              SocialButton(
                icon: IconAssets.appleIcon,
                text: 'Sign up with Apple',
                backgroundColor: AppPallete.blackColor.withOpacity(0.8),
                textColor: AppPallete.whiteColor,
                onTap: () => _handleSocialSignup(context, 'Apple'),
              ),
              SizedBox(height: 0.05.sh),
            ],
          ),
        ),
      ),
    );
  }
}
