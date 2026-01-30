import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_app_bar.dart';
import 'package:whispr_app/core/common/common_bg_widget.dart';
import 'package:whispr_app/core/common/common_snackbar.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/helpers/validation_helper.dart';
import 'package:whispr_app/core/services/local_database_service.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_action_button.dart';
import 'package:whispr_app/features/auth/login/widgets/auth_input_field.dart';
import 'package:whispr_app/features/auth/login/widgets/email_validation_icon.dart';
import 'package:whispr_app/features/forgot_password/screen/reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    if (_emailError != null) {
      setState(() {
        _emailError = ValidationHelper.validateEmail(_emailController.text);
      });
    }
  }

  bool get _isEmailValid =>
      ValidationHelper.isEmailValid(_emailController.text);

  Future<void> _handleContinue() async {
    final emailErr = ValidationHelper.validateEmail(_emailController.text);
    setState(() => _emailError = emailErr);

    if (emailErr != null) {
      CommonSnackbar.showError(context, message: emailErr);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim().toLowerCase();
      final user = await LocalDatabaseService.instance.getUserByEmail(email);

      if (user == null) {
        if (mounted) {
          CommonSnackbar.showError(
            context,
            message: 'No account found with this email',
          );
        }
      } else {
        // Navigate to reset password screen with user id
        Get.to(() => ResetPasswordScreen(userId: user.id!, email: user.email));
      }
    } catch (e) {
      if (mounted) {
        CommonSnackbar.showError(
          context,
          message: 'Something went wrong. Please try again.',
        );
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
              CommonAppBar(title: 'Forgot Password', isBackButton: true),
              SizedBox(height: 0.05.sh),
              Image.asset(ImageAssets.whisprImage, height: 0.2.sh),
              SizedBox(height: 0.04.sh),
              CommonText(
                text: 'Enter your email address',
                fontSize: 0.022.sh,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 0.01.sh),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
                child: CommonText(
                  text:
                      'We\'ll verify your email and let you reset your password',
                  fontSize: 0.014.sh,
                  fontWeight: FontWeight.w400,
                  color: AppPallete.whiteColor.withOpacity(0.7),
                  textAlign: TextAlign.center,
                  maxLine: 2,
                ),
              ),
              SizedBox(height: 0.04.sh),
              AuthInputField(
                label: 'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                suffixIcon: _isEmailValid ? const EmailValidationIcon() : null,
                errorText: _emailError,
              ),
              SizedBox(height: 0.04.sh),
              AuthActionButton(
                text: _isLoading ? 'Verifying...' : 'Continue',
                onTap: _isLoading ? () {} : _handleContinue,
                isGradient: false,
              ),
              SizedBox(height: 0.02.sh),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: CommonText(
                  text: 'Back to Login',
                  fontSize: 0.014.sh,
                  color: AppPallete.whiteColor.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 0.05.sh),
            ],
          ),
        ),
      ),
    );
  }
}
