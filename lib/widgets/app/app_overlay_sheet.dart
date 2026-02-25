import 'package:flutter/material.dart';

class AppOverlaySheet extends StatefulWidget {
  final Widget child;

  /// Panel size
  final double height;
  final double? width;

  /// Styling
  final Color overlayColor;
  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;
  final EdgeInsetsGeometry padding;

  /// Behavior
  final bool dismissOnTapOutside;
  final VoidCallback? onClose;

  /// Optional header handle
  final bool showHandle;

  const AppOverlaySheet({
    super.key,
    required this.child,
    this.height = 681,
    this.width,
    this.overlayColor = const Color(0x604F4F4F),
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(32),
      topRight: Radius.circular(32),
    ),
    this.shadows = const [
      BoxShadow(
        color: Color(0x29000000),
        blurRadius: 30,
        offset: Offset(0, 3),
      )
    ],
    this.padding = const EdgeInsets.only(top: 16, bottom: 16),
    this.dismissOnTapOutside = true,
    this.onClose,
    this.showHandle = false,
  });

  @override
  State<AppOverlaySheet> createState() => _AppOverlaySheetState();
}

class _AppOverlaySheetState extends State<AppOverlaySheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // từ dưới
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  Future<void> _close() async {
    await _controller.reverse();
    if (!mounted) return;
    if (widget.onClose != null) {
      widget.onClose!.call();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            /// Overlay
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap:
                    widget.dismissOnTapOutside ? _close : null,
                child: Container(
                  color: widget.overlayColor,
                ),
              ),
            ),

            /// Sheet
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  width: widget.width ??
                      MediaQuery.of(context).size.width,
                  height: widget.height,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: widget.borderRadius,
                    ),
                    shadows: widget.shadows,
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: widget.padding,
                      child: Column(
                        children: [
                          if (widget.showHandle) ...[
                            Center(
                              child: Container(
                                width: 55,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF212121),
                                  borderRadius:
                                      BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          Expanded(child: widget.child),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
