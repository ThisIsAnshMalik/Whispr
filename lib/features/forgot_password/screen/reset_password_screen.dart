// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_app_bar.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_snackbar.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/controllers/session_controller.dart';
import 'package:whispr_app/core/helpers/validation_helper.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/auth/login/screen/login_screen.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_action_button.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_input_field.dart';
import 'package:whispr_app/features/auth/login/widgets/password_visibility_toggle.dart';

class ResetPasswordScreen extends StatefulWidget {
  final int userId;
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_onPasswordChanged);
    _confirmPasswordController.removeListener(_onConfirmPasswordChanged);
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    if (_passwordError != null) {
      setState(() {
        _passwordError = ValidationHelper.validatePasswordSignup(
          _newPasswordController.text,
        );
      });
    }
    // Also revalidate confirm password
    if (_confirmPasswordError != null) {
      setState(() {
        _confirmPasswordError = ValidationHelper.validateConfirmPassword(
          _confirmPasswordController.text,
          _newPasswordController.text,
        );
      });
    }
  }

  void _onConfirmPasswordChanged() {
    if (_confirmPasswordError != null) {
      setState(() {
        _confirmPasswordError = ValidationHelper.validateConfirmPassword(
          _confirmPasswordController.text,
          _newPasswordController.text,
        );
      });
    }
  }

  Future<void> _handleResetPassword() async {
    final passwordErr = ValidationHelper.validatePasswordSignup(
      _newPasswordController.text,
    );
    final confirmErr = ValidationHelper.validateConfirmPassword(
      _confirmPasswordController.text,
      _newPasswordController.text,
    );

    setState(() {
      _passwordError = passwordErr;
      _confirmPasswordError = confirmErr;
    });

    if (passwordErr != null || confirmErr != null) {
      CommonSnackbar.showError(
        context,
        message: passwordErr ?? confirmErr ?? 'Please fix the errors',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await SessionController.to.resetPassword(
        context,
        userId: widget.userId,
        newPassword: _newPasswordController.text,
      );

      if (success && mounted) {
        // Navigate to login screen
        Get.offAll(() => const LoginScreen());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = Get.overlayContext;
          if (ctx != null && ctx.mounted) {
            CommonSnackbar.showSuccess(
              ctx,
              message: 'Password reset successful. Please login.',
            );
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgWidget(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
          child: Column(
            children: [
              CommonAppBar(title: 'Reset Password', isBackButton: true),
              SizedBox(height: 0.04.sh),
              Image.asset(ImageAssets.whisprImage, height: 0.18.sh),
              SizedBox(height: 0.03.sh),
              CommonText(
                text: 'Create new password',
                fontSize: 0.022.sh,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 0.01.sh),
              CommonText(
                text: 'for ${widget.email}',
                fontSize: 0.014.sh,
                fontWeight: FontWeight.w400,
                color: AppPallete.whiteColor.withOpacity(0.7),
              ),
              SizedBox(height: 0.04.sh),
              AuthInputField(
                label: 'New Password',
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                errorText: _passwordError,
                suffixIcon: PasswordVisibilityToggle(
                  onTap: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
              SizedBox(height: 0.02.sh),
              AuthInputField(
                label: 'Confirm New Password',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                errorText: _confirmPasswordError,
                suffixIcon: PasswordVisibilityToggle(
                  onTap: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              SizedBox(height: 0.01.sh),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
                child: CommonText(
                  text:
                      'Password must be at least 8 characters with uppercase, lowercase, and number',
                  fontSize: 0.011.sh,
                  color: AppPallete.whiteColor.withOpacity(0.5),
                  maxLine: 2,
                ),
              ),
              SizedBox(height: 0.04.sh),
              AuthActionButton(
                text: _isLoading ? 'Resetting...' : 'Reset Password',
                onTap: _isLoading ? () {} : _handleResetPassword,
                isGradient: false,
              ),
              SizedBox(height: 0.05.sh),
            ],
          ),
        ),
      ),
    );
  }
}
