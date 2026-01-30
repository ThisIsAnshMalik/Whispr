import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/common/common_snackbar.dart';
import 'package:whispr_app/core/helpers/validation_helper.dart';
import 'package:whispr_app/features/dashboard/dashboard_screen.dart';
import 'package:whispr_app/features/auth/signup/screen/signup_screen.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final emailError = Rx<String?>(null);
  final passwordError = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_onEmailChanged);
    passwordController.addListener(_onPasswordChanged);
  }

  @override
  void onClose() {
    emailController.removeListener(_onEmailChanged);
    passwordController.removeListener(_onPasswordChanged);
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _onEmailChanged() {
    emailError.value = ValidationHelper.validateEmail(emailController.text);
  }

  void _onPasswordChanged() {
    passwordError.value = ValidationHelper.validatePasswordLogin(
      passwordController.text,
    );
  }

  bool get isEmailValid => ValidationHelper.isEmailValid(emailController.text);

  void toggleObscurePassword() {
    obscurePassword.toggle();
  }

  void handleLogin(BuildContext context) {
    final emailErr = ValidationHelper.validateEmail(emailController.text);
    final passwordErr = ValidationHelper.validatePasswordLogin(
      passwordController.text,
    );

    emailError.value = emailErr;
    passwordError.value = passwordErr;

    if (emailErr != null || passwordErr != null) {
      CommonSnackbar.showError(
        context,
        message: emailErr ?? passwordErr ?? 'Please fix the errors',
      );
      return;
    }

    CommonSnackbar.showSuccess(context, message: 'Login successful');
    Get.offAll(() => const DashboardScreen());
  }

  void goToSignup() {
    Get.off(() => const SignupScreen());
  }

  void handleSocialLogin(BuildContext context, String provider) {
    CommonSnackbar.showSuccess(context, message: 'Signed in with $provider');
    Get.offAll(() => const DashboardScreen());
  }
}
