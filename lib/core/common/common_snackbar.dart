import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

/// Common snackbar utility for success and error feedback.
/// Displays as a floating snackbar from the top, styled to match the app.
class CommonSnackbar {
  CommonSnackbar._();

  static const double _horizontalMargin = 16;
  static const double _topMargin = 12;
  static const double _radius = 14;

  /// Success green that complements the app's purple theme.
  static const Color _successColor = Color(0xFF2E7D32);

  /// Error red that fits the dark gradient background.
  static const Color _errorColor = Color(0xFFC62828);

  static void _showFromTop(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (_) => _FloatingSnackbar(
        message: message,
        backgroundColor: backgroundColor,
        icon: icon,
        duration: duration,
        onDismiss: () => overlayEntry.remove(),
      ),
    );
    overlay.insert(overlayEntry);
  }

  /// Shows a success message from the top with app-styled green.
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFromTop(
      context,
      message: message,
      backgroundColor: _successColor,
      icon: Icons.check_circle_rounded,
      duration: duration,
    );
  }

  /// Shows an error/failure message from the top with app-styled red.
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showFromTop(
      context,
      message: message,
      backgroundColor: _errorColor,
      icon: Icons.error_rounded,
      duration: duration,
    );
  }
}

class _FloatingSnackbar extends StatefulWidget {
  const _FloatingSnackbar({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.duration,
    required this.onDismiss,
  });

  final String message;
  final Color backgroundColor;
  final IconData icon;
  final Duration duration;
  final VoidCallback onDismiss;

  @override
  State<_FloatingSnackbar> createState() => _FloatingSnackbarState();
}

class _FloatingSnackbarState extends State<_FloatingSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    Future.delayed(widget.duration, () => _dismiss());
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) => widget.onDismiss());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            CommonSnackbar._horizontalMargin,
            CommonSnackbar._topMargin,
            CommonSnackbar._horizontalMargin,
            0,
          ),
          child: SlideTransition(
            position: _slideAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(CommonSnackbar._radius.r),
                  border: Border.all(
                    color: AppPallete.whiteColor.withOpacity(0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppPallete.primaryColor.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(widget.icon, color: AppPallete.whiteColor, size: 24.r),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: GoogleFonts.montserrat(
                          color: AppPallete.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
