import 'package:flutter/material.dart';

/// Common snackbar utility for success and error feedback.
/// Displays as a floating snackbar from the top of the screen.
class CommonSnackbar {
  CommonSnackbar._();

  static const double _horizontalMargin = 16;
  static const double _topMargin = 12;
  static const double _radius = 12;

  static void _showFromTop(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (_) => _FloatingSnackbar(
        message: message,
        backgroundColor: backgroundColor,
        duration: duration,
        onDismiss: () => overlayEntry.remove(),
      ),
    );
    overlay.insert(overlayEntry);
  }

  /// Shows a success message from the top with green styling.
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFromTop(
      context,
      message: message,
      backgroundColor: Colors.green.shade700,
      duration: duration,
    );
  }

  /// Shows an error/failure message from the top with red styling.
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showFromTop(
      context,
      message: message,
      backgroundColor: Colors.red.shade700,
      duration: duration,
    );
  }
}

class _FloatingSnackbar extends StatefulWidget {
  const _FloatingSnackbar({
    required this.message,
    required this.backgroundColor,
    required this.duration,
    required this.onDismiss,
  });

  final String message;
  final Color backgroundColor;
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(CommonSnackbar._radius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
