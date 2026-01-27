// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/common/common_auth_header.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_action_button.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_header.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_input_field.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_navigation_link.dart';
import 'package:whispr_app/features/auth/login/widgets/email_validation_icon.dart';
import 'package:whispr_app/features/auth/login/widgets/forgot_password_link.dart';
import 'package:whispr_app/features/auth/login/widgets/or_separator.dart';
import 'package:whispr_app/features/auth/login/widgets/password_visibility_toggle.dart';
import 'package:whispr_app/features/auth/login/widgets/social_button.dart';
import 'package:whispr_app/features/auth/signup/screen/signup_screen.dart';
import 'package:whispr_app/features/dashboard/dashboard_screen.dart';
import 'package:whispr_app/features/onboarding/screen/platform_rules_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  void _handleLogin(BuildContext context) {
    // Validate email and password
    if (!_isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to dashboard after successful login
    _navigateToDashboard(context);
  }

  void _handleSocialLogin(BuildContext context, String provider) {
    // Navigate to dashboard after successful social login
    _navigateToDashboard(context);
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
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
                title: 'Welcome back, it’s safe to\nshare quietly',
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
              SizedBox(height: 0.01.sh),
              ForgotPasswordLink(onTap: () {}),
              SizedBox(height: 0.02.sh),
              AuthActionButton(
                text: 'Login',
                onTap: () => _handleLogin(context),
                isGradient: false,
              ),
              SizedBox(height: 0.02.sh),
              // Sign Up Link
              AuthNavigationLink(
                prefixText: 'Don\'t have an account? ',
                linkText: 'Sign Up',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
              ),
              SizedBox(height: 0.01.sh),
              // OR Separator
              const OrSeparator(),
              SizedBox(height: 0.01.sh),
              // Google Sign Up Button
              SocialButton(
                icon: IconAssets.googleIcon,
                text: 'Sign up with Google',
                backgroundColor: AppPallete.whiteColor,
                textColor: AppPallete.blackTextColor,
                onTap: () => _handleSocialLogin(context, 'Google'),
              ),
              SizedBox(height: 0.02.sh),
              // Apple Sign Up Button
              SocialButton(
                icon: IconAssets.appleIcon,
                text: 'Sign up with Apple',
                backgroundColor: AppPallete.blackColor.withOpacity(0.8),
                textColor: AppPallete.whiteColor,
                onTap: () => _handleSocialLogin(context, 'Apple'),
              ),
              SizedBox(height: 0.05.sh),
            ],
          ),
        ),
      ),
    );
  }
}
