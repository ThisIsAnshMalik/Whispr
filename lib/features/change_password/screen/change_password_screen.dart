import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_app_bar.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_action_button.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_input_field.dart';
import 'package:whispr_app/features/auth/login/widgets/password_visibility_toggle.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleUpdatePassword(BuildContext context) {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in both password fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password updated successfully')),
    );
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
              SizedBox(height: 0.05.sh),
              Image.asset(ImageAssets.whisprImage, height: 0.23.sh),
              SizedBox(height: 0.04.sh),
              AuthInputField(
                label: 'Enter New Password',
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
                text: 'Update Password',
                onTap: () => _handleUpdatePassword(context),
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
