// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/common/common_auth_header.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/auth/login/controller/login_controller.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_action_button.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_input_field.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_navigation_link.dart';
import 'package:whispr_app/features/auth/login/widgets/email_validation_icon.dart';
import 'package:whispr_app/features/auth/login/widgets/forgot_password_link.dart';
import 'package:whispr_app/features/auth/login/widgets/or_separator.dart';
import 'package:whispr_app/features/auth/login/widgets/password_visibility_toggle.dart';
import 'package:whispr_app/features/auth/login/widgets/social_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) => CommonBgWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
            child: Column(
              children: [
                CommonAuthHeader(
                  title: 'Welcome back, it\'s safe to\nshare quietly',
                ),
                SizedBox(height: 0.03.sh),
                Obx(
                  () => AuthInputField(
                    label: 'Email Address',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: controller.isEmailValid
                        ? const EmailValidationIcon()
                        : null,
                    errorText: controller.emailError.value,
                  ),
                ),
                SizedBox(height: 0.02.sh),
                Obx(
                  () => AuthInputField(
                    label: 'Enter your password',
                    controller: controller.passwordController,
                    obscureText: controller.obscurePassword.value,
                    suffixIcon: PasswordVisibilityToggle(
                      onTap: controller.toggleObscurePassword,
                    ),
                    errorText: controller.passwordError.value,
                  ),
                ),
                SizedBox(height: 0.01.sh),
                ForgotPasswordLink(onTap: controller.goToForgotPassword),
                SizedBox(height: 0.02.sh),
                AuthActionButton(
                  text: 'Login',
                  onTap: () => controller.handleLogin(context),
                  isGradient: false,
                ),
                SizedBox(height: 0.02.sh),
                AuthNavigationLink(
                  prefixText: 'Don\'t have an account? ',
                  linkText: 'Sign Up',
                  onTap: controller.goToSignup,
                ),
                SizedBox(height: 0.01.sh),
                const OrSeparator(),
                SizedBox(height: 0.01.sh),
                SocialButton(
                  icon: IconAssets.googleIcon,
                  text: 'Sign up with Google',
                  backgroundColor: AppPallete.whiteColor,
                  textColor: AppPallete.blackTextColor,
                  onTap: () => controller.handleSocialLogin(context, 'Google'),
                ),
                SizedBox(height: 0.02.sh),
                SocialButton(
                  icon: IconAssets.appleIcon,
                  text: 'Sign up with Apple',
                  backgroundColor: AppPallete.blackColor.withOpacity(0.8),
                  textColor: AppPallete.whiteColor,
                  onTap: () => controller.handleSocialLogin(context, 'Apple'),
                ),
                SizedBox(height: 0.05.sh),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
