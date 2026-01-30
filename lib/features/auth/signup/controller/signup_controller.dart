import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/common/common_snackbar.dart';
import 'package:whispr_app/core/controllers/session_controller.dart';
import 'package:whispr_app/core/helpers/validation_helper.dart';
import 'package:whispr_app/features/auth/login/screen/login_screen.dart';
import 'package:whispr_app/features/dashboard/dashboard_screen.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final emailError = Rx<String?>(null);
  final passwordError = Rx<String?>(null);
  final confirmPasswordError = Rx<String?>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_onEmailChanged);
    passwordController.addListener(_onPasswordChanged);
    confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void onClose() {
    emailController.removeListener(_onEmailChanged);
    passwordController.removeListener(_onPasswordChanged);
    confirmPasswordController.removeListener(_onConfirmPasswordChanged);
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void _onEmailChanged() {
    emailError.value = ValidationHelper.validateEmail(emailController.text);
  }

  void _onPasswordChanged() {
    passwordError.value = ValidationHelper.validatePasswordSignup(
      passwordController.text,
    );
    confirmPasswordError.value = ValidationHelper.validateConfirmPassword(
      confirmPasswordController.text,
      passwordController.text,
    );
  }

  void _onConfirmPasswordChanged() {
    confirmPasswordError.value = ValidationHelper.validateConfirmPassword(
      confirmPasswordController.text,
      passwordController.text,
    );
  }

  bool get isEmailValid => ValidationHelper.isEmailValid(emailController.text);

  void toggleObscurePassword() {
    obscurePassword.toggle();
  }

  void toggleObscureConfirmPassword() {
    obscureConfirmPassword.toggle();
  }

  Future<void> handleSignup(BuildContext context) async {
    final emailErr = ValidationHelper.validateEmail(emailController.text);
    final passwordErr = ValidationHelper.validatePasswordSignup(
      passwordController.text,
    );
    final confirmErr = ValidationHelper.validateConfirmPassword(
      confirmPasswordController.text,
      passwordController.text,
    );

    emailError.value = emailErr;
    passwordError.value = passwordErr;
    confirmPasswordError.value = confirmErr;

    if (emailErr != null || passwordErr != null || confirmErr != null) {
      CommonSnackbar.showError(
        context,
        message:
            emailErr ?? passwordErr ?? confirmErr ?? 'Please fix the errors',
      );
      return;
    }

    isLoading.value = true;
    final success = await SessionController.to.signup(
      context,
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    isLoading.value = false;

    if (success) {
      Get.offAll(() => const DashboardScreen());
    }
  }

  void goToLogin() {
    Get.off(() => const LoginScreen());
  }

  void handleSocialSignup(BuildContext context, String provider) {
    // Social signup not implemented for local-only mode
    CommonSnackbar.showError(
      context,
      message: 'Social signup is not available in offline mode',
    );
  }
}
