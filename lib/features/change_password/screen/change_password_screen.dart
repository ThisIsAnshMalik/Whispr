import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_app_bar.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_snackbar.dart';
import 'package:whispr_app/core/controllers/session_controller.dart';
import 'package:whispr_app/core/helpers/validation_helper.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_action_button.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_input_field.dart';
import 'package:whispr_app/features/auth/login/widgets/password_visibility_toggle.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdatePassword(BuildContext context) async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validate current password
    if (currentPassword.isEmpty) {
      CommonSnackbar.showError(
        context,
        message: 'Please enter your current password',
      );
      return;
    }

    // Validate new password
    final passwordError = ValidationHelper.validatePasswordSignup(newPassword);
    if (passwordError != null) {
      CommonSnackbar.showError(context, message: passwordError);
      return;
    }

    // Validate confirm password
    final confirmError = ValidationHelper.validateConfirmPassword(
      confirmPassword,
      newPassword,
    );
    if (confirmError != null) {
      CommonSnackbar.showError(context, message: confirmError);
      return;
    }

    setState(() => _isLoading = true);

    final success = await SessionController.to.changePassword(
      context,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    setState(() => _isLoading = false);

    if (success) {
      // Clear fields and go back
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      if (context.mounted) {
        Navigator.of(context).pop();
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
              CommonAppBar(title: 'Change Password', isBackButton: true),
              SizedBox(height: 0.03.sh),
              Image.asset(ImageAssets.whisprImage, height: 0.18.sh),
              SizedBox(height: 0.03.sh),
              AuthInputField(
                label: 'Current Password',
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                suffixIcon: PasswordVisibilityToggle(
                  onTap: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
              ),
              SizedBox(height: 0.02.sh),
              AuthInputField(
                label: 'New Password',
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
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
                suffixIcon: PasswordVisibilityToggle(
                  onTap: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              SizedBox(height: 0.04.sh),
              AuthActionButton(
                text: _isLoading ? 'Updating...' : 'Update Password',
                onTap: _isLoading
                    ? () {}
                    : () => _handleUpdatePassword(context),
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
