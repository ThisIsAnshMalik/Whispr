// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/assets/icon_assets.dart';
import 'package:whispr_app/core/common/common_auth_header.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_action_button.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_input_field.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_navigation_link.dart';
import 'package:whispr_app/features/auth/login/widgets/email_validation_icon.dart';
import 'package:whispr_app/features/auth/login/widgets/or_separator.dart';
import 'package:whispr_app/features/auth/login/widgets/password_visibility_toggle.dart';
import 'package:whispr_app/features/auth/login/widgets/social_button.dart';
import 'package:whispr_app/features/auth/signup/controller/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      init: SignupController(),
      builder: (controller) => CommonBgWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
            child: Column(
              children: [
                CommonAuthHeader(
                  title: 'Create an account\nShare only when you\'re ready',
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
                SizedBox(height: 0.02.sh),
                Obx(
                  () => AuthInputField(
                    label: 'Confirm password',
                    controller: controller.confirmPasswordController,
                    obscureText: controller.obscureConfirmPassword.value,
                    suffixIcon: PasswordVisibilityToggle(
                      onTap: controller.toggleObscureConfirmPassword,
                    ),
                    errorText: controller.confirmPasswordError.value,
                  ),
                ),
                SizedBox(height: 0.03.sh),
                AuthActionButton(
                  text: 'Create Account',
                  onTap: () => controller.handleSignup(context),
                  isGradient: false,
                ),
                SizedBox(height: 0.02.sh),
                AuthNavigationLink(
                  prefixText: 'Already have an account? ',
                  linkText: 'Sign In',
                  onTap: controller.goToLogin,
                ),
                SizedBox(height: 0.01.sh),
                const OrSeparator(),
                SizedBox(height: 0.01.sh),
                SocialButton(
                  icon: IconAssets.googleIcon,
                  text: 'Sign up with Google',
                  backgroundColor: AppPallete.whiteColor,
                  textColor: AppPallete.blackTextColor,
                  onTap: () => controller.handleSocialSignup(context, 'Google'),
                ),
                SizedBox(height: 0.01.sh),
                SocialButton(
                  icon: IconAssets.appleIcon,
                  text: 'Sign up with Apple',
                  backgroundColor: AppPallete.blackColor.withOpacity(0.8),
                  textColor: AppPallete.whiteColor,
                  onTap: () => controller.handleSocialSignup(context, 'Apple'),
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
