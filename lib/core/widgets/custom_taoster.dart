import 'package:flutter/material.dart';

// Toast positions
enum ToastGravity { top, center, bottom }

// Toast lengths
enum ToastLength { short, long }

class CustomToast {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show(
    String message, {
    required BuildContext context,
    ToastGravity gravity = ToastGravity.bottom,
    ToastLength length = ToastLength.short,
    Color backgroundColor = const Color(0xFF333333),
    Color textColor = Colors.white,
    double fontSize = 16.0,
    EdgeInsets margin = const EdgeInsets.all(50.0),
    BorderRadius? borderRadius,
    double opacity = 0.8,
  }) {
    // Remove existing toast if any
    if (_isVisible) {
      _removeToast();
    }

    // Get the overlay
    final overlay = Overlay.of(context);

    // Create the overlay entry
    _overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        gravity: gravity,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
        margin: margin,
        borderRadius: borderRadius ?? BorderRadius.circular(25.0),
        opacity: opacity,
      ),
    );

    // Insert the overlay
    overlay.insert(_overlayEntry!);
    _isVisible = true;

    // Auto remove after duration
    final duration = length == ToastLength.short
        ? const Duration(seconds: 2)
        : const Duration(seconds: 4);

    Future.delayed(duration, () {
      _removeToast();
    });
  }

  static void _removeToast() {
    if (_overlayEntry != null && _isVisible) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }

  // Cancel any existing toast
  static void cancel() {
    _removeToast();
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastGravity gravity;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final double opacity;

  const _ToastWidget({
    required this.message,
    required this.gravity,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    required this.margin,
    required this.borderRadius,
    required this.opacity,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Slide animation based on gravity
    Offset beginOffset;
    switch (widget.gravity) {
      case ToastGravity.top:
        beginOffset = const Offset(0.0, -1.0);
        break;
      case ToastGravity.center:
        beginOffset = const Offset(0.0, 0.0);
        break;
      case ToastGravity.bottom:
        beginOffset = const Offset(0.0, 1.0);
        break;
    }

    _slideAnimation = Tween<Offset>(begin: beginOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    // Start animation
    _animationController.forward();

    // Auto reverse animation before removal
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (mounted) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildToastContent(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildToastContent() {
    MainAxisAlignment alignment;
    switch (widget.gravity) {
      case ToastGravity.top:
        alignment = MainAxisAlignment.start;
        break;
      case ToastGravity.center:
        alignment = MainAxisAlignment.center;
        break;
      case ToastGravity.bottom:
        alignment = MainAxisAlignment.end;
        break;
    }

    return Column(
      mainAxisAlignment: alignment,
      children: [
        Container(
          margin: widget.margin,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: widget.backgroundColor.withValues(alpha: widget.opacity),
            borderRadius: widget.borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            widget.message,
            style: TextStyle(
              color: widget.textColor,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
