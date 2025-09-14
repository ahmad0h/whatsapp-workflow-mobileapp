import 'package:flutter/material.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/connectivity_service.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper>
    with SingleTickerProviderStateMixin {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    _connectivityService.initialize();

    // Add a small delay to ensure the widget is properly mounted
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    // Check initial connectivity
    final initialConnection = await _connectivityService.isConnected;
    if (!mounted) return;

    setState(() {
      _isConnected = initialConnection;
    });

    if (!_isConnected) {
      _showPersistentBanner();
    }

    // Listen to connectivity changes
    _connectivityService.connectivityStream.listen((hasConnection) {
      final wasConnected = _isConnected;

      setState(() {
        _isConnected = hasConnection;
      });

      if (!hasConnection && wasConnected) {
        // Lost connection
        _showPersistentBanner();
      } else if (hasConnection && !wasConnected) {
        // Connection restored
        _hidePersistentBanner();
      }
    });
  }

  void _showPersistentBanner() {
    if (_overlayEntry != null || !mounted) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value * 80),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'No internet connection',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Pulsing dot to indicate it's checking
                        _buildPulsingDot(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  Widget _buildPulsingDot() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.3, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        // Restart the animation for continuous pulsing
        if (mounted && !_isConnected) {
          setState(() {}); // Trigger rebuild to restart animation
        }
      },
    );
  }

  void _hidePersistentBanner() async {
    if (_overlayEntry == null) return;

    await _animationController.reverse();

    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    // Show brief success message
    _showSuccessToast();
  }

  void _showSuccessToast() {
    if (!mounted) return;

    final overlay = Overlay.of(context);
    late OverlayEntry successEntry;

    successEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: -80.0, end: 0.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi, color: Colors.white, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Connection restored',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    overlay.insert(successEntry);

    // Remove success toast after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      successEntry.remove();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// Alternative approach using a banner widget if you prefer
class ConnectivityBanner extends StatefulWidget {
  final Widget child;

  const ConnectivityBanner({super.key, required this.child});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    _connectivityService.initialize();

    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    final initialConnection = await _connectivityService.isConnected;
    if (!mounted) return;

    setState(() {
      _isConnected = initialConnection;
    });

    if (!_isConnected) {
      _animationController.forward();
    }

    _connectivityService.connectivityStream.listen((hasConnection) {
      final wasConnected = _isConnected;

      setState(() {
        _isConnected = hasConnection;
      });

      if (!hasConnection && wasConnected) {
        _animationController.forward();
      } else if (hasConnection && !wasConnected) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizeTransition(
          sizeFactor: _animation,
          child: Container(
            width: double.infinity,
            color: Colors.red.withValues(alpha: 0.9),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'No internet connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
