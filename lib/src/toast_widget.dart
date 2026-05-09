import 'package:flutter/material.dart';
import 'toast_type.dart';
import 'toast_position.dart';
import 'toast_config.dart';
import 'toast_animation.dart';

/// Internal widget that renders the Android Material 3 style toast.
class ToastWidget extends StatefulWidget {
  final String title;
  final String? message;
  final ToastType type;
  final ToastPosition position;
  final ToastConfig config;
  final VoidCallback onDismiss;

  /// 0 = frontmost/newest, stackSize-1 = furthest back/oldest.
  final int stackIndex;
  final int stackSize;

  const ToastWidget({
    super.key,
    required this.title,
    this.message,
    required this.type,
    required this.position,
    required this.config,
    required this.onDismiss,
    this.stackIndex = 0,
    this.stackSize = 1,
  });

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with TickerProviderStateMixin {
  late AnimationController _enterController;
  late AnimationController _exitController;
  late AnimationController _progressController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _exitFade;
  late Animation<Offset> _exitSlide;

  // Swipe state
  double _dragOffset = 0;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: widget.config.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, _isTopPosition ? -0.6 : 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: widget.config.animation == ToastAnimation.bounce
          ? Curves.elasticOut
          : const _M3Curve(),
    ));

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOutBack),
    );

    // Exit: slides back the direction it came from
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );
    _exitSlide = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, _isTopPosition ? -0.5 : 0.5),
    ).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );

    _enterController.forward();

    if (!widget.config.persistent && widget.config.showProgressBar) {
      _progressController.forward();
    }
  }

  bool get _isTopPosition =>
      widget.position == ToastPosition.top ||
      widget.position == ToastPosition.topLeft ||
      widget.position == ToastPosition.topRight;

  @override
  void dispose() {
    _enterController.dispose();
    _exitController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  /// Plays the vertical exit animation then calls onDismiss.
  Future<void> _animatedDismiss() async {
    if (_isDismissing) return;
    _isDismissing = true;
    await _exitController.forward();
    widget.onDismiss();
  }

  /// Plays a horizontal swipe-out animation then calls onDismiss.
  Future<void> _swipeDismiss(double targetX) async {
    if (_isDismissing) return;
    _isDismissing = true;

    final swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    final swipeAnim = Tween<double>(
      begin: _dragOffset,
      end: targetX,
    ).animate(CurvedAnimation(parent: swipeController, curve: Curves.easeOut));

    swipeAnim.addListener(() {
      if (mounted) setState(() => _dragOffset = swipeAnim.value);
    });

    // Apply fade via the exit controller in parallel
    _exitController.animateTo(1.0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);

    await swipeController.forward();
    swipeController.dispose();
    widget.onDismiss();
  }

  AlignmentGeometry get _alignment {
    switch (widget.position) {
      case ToastPosition.top:
        return Alignment.topCenter;
      case ToastPosition.topRight:
        return Alignment.topRight;
      case ToastPosition.topLeft:
        return Alignment.topLeft;
      case ToastPosition.bottom:
        return Alignment.bottomCenter;
      case ToastPosition.bottomRight:
        return Alignment.bottomRight;
      case ToastPosition.bottomLeft:
        return Alignment.bottomLeft;
    }
  }

  EdgeInsets get _screenPadding {
    final isTop = _isTopPosition;
    final isLeft = widget.position == ToastPosition.topLeft ||
        widget.position == ToastPosition.bottomLeft;
    final isRight = widget.position == ToastPosition.topRight ||
        widget.position == ToastPosition.bottomRight;
    final isCenter = widget.position == ToastPosition.top ||
        widget.position == ToastPosition.bottom;
    return EdgeInsets.only(
      top: isTop ? 52 : 0,
      bottom: isTop ? 0 : 52,
      left: isLeft ? 16 : (isCenter ? 16 : 0),
      right: isRight ? 16 : (isCenter ? 16 : 0),
    );
  }

  Widget _buildAnimated(Widget child) {
    final entered = switch (widget.config.animation) {
      ToastAnimation.fade =>
        FadeTransition(opacity: _fadeAnimation, child: child),
      ToastAnimation.scale => FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(scale: _scaleAnimation, child: child),
        ),
      _ => FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(position: _slideAnimation, child: child),
        ),
    };

    // Wrap with exit (vertical slide + fade)
    return FadeTransition(
      opacity: _exitFade,
      child: SlideTransition(position: _exitSlide, child: entered),
    );
  }

  void _handleDragUpdate(DragUpdateDetails d) {
    if (!widget.config.swipeToDismiss || _isDismissing) return;
    setState(() => _dragOffset += d.delta.dx);
  }

  void _handleDragEnd(DragEndDetails d) {
    if (!widget.config.swipeToDismiss || _isDismissing) return;

    final velocity = d.primaryVelocity ?? 0;
    final screenWidth = MediaQuery.of(context).size.width;

    // Dismiss if dragged far enough OR flicked fast enough
    if (_dragOffset.abs() > 80 || velocity.abs() > 600) {
      // Fly off in the direction of the drag
      final targetX = _dragOffset > 0 ? screenWidth : -screenWidth;
      _swipeDismiss(targetX);
    } else {
      // Spring back to center
      _snapBack();
    }
  }

  void _snapBack() {
    final snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    final snapAnim = Tween<double>(begin: _dragOffset, end: 0.0).animate(
      CurvedAnimation(parent: snapController, curve: Curves.elasticOut),
    );
    snapAnim.addListener(() {
      if (mounted) setState(() => _dragOffset = snapAnim.value);
    });
    snapController.forward().then((_) => snapController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final theme = getToastTheme(widget.type, brightness: brightness);
    final config = widget.config;

    final bgColor = config.backgroundColor ?? theme.backgroundColor;
    final iconColor = config.iconBackgroundColor ?? theme.iconColor;
    final labelColor = theme.labelColor;
    final actionColor = theme.actionColor;
    final progressColor = config.progressBarColor ?? theme.accentColor;

    return Material(
        color: Colors.transparent,
        child: Align(
          alignment: _alignment,
          child: Padding(
            padding: _screenPadding,
            child: _buildStackTransform(
              _buildAnimated(
                GestureDetector(
                  onHorizontalDragUpdate: _handleDragUpdate,
                  onHorizontalDragEnd: _handleDragEnd,
                  onTap: config.onTap,
                  child: Transform.translate(
                    offset: Offset(_dragOffset, 0),
                    child: Opacity(
                      // Fade out as user drags, fully gone at 180px
                      opacity: (1 - (_dragOffset.abs() / 180)).clamp(0.0, 1.0),
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 288,
                          maxWidth: 560,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius:
                              config.borderRadius ?? BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.22),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              config.borderRadius ?? BorderRadius.circular(28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ── Content ──
                              Padding(
                                padding: config.padding ??
                                    const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Icon
                                    if (config.showIcon) ...[
                                      config.icon ??
                                          _M3Icon(
                                            type: widget.type,
                                            color: iconColor,
                                          ),
                                      const SizedBox(width: 12),
                                    ],

                                    // Title + message
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            widget.title,
                                            style: config.titleStyle ??
                                                TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: labelColor,
                                                  letterSpacing: 0.1,
                                                  height: 1.4,
                                                ),
                                          ),
                                          if (widget.message != null &&
                                              widget.message!.isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              widget.message!,
                                              maxLines: config.maxLines,
                                              overflow: config.maxLines != null
                                                  ? TextOverflow.ellipsis
                                                  : null,
                                              style: config.messageStyle ??
                                                  TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        labelColor.withValues(
                                                            alpha: 0.70),
                                                    height: 1.5,
                                                    letterSpacing: 0.2,
                                                  ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),

                                    // Action
                                    if (config.action != null) ...[
                                      const SizedBox(width: 8),
                                      _M3ActionButton(
                                        label: config.action!.label,
                                        labelStyle: config.action!.labelStyle,
                                        color: actionColor,
                                        onTap: () {
                                          config.action!.onPressed();
                                          _animatedDismiss();
                                        },
                                      ),
                                    ],

                                    // Close
                                    if (config.showCloseButton) ...[
                                      const SizedBox(width: 4),
                                      _M3CloseButton(
                                        color: labelColor,
                                        onTap: _animatedDismiss,
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // ── Progress bar ──
                              if (config.showProgressBar && !config.persistent)
                                _M3ProgressBar(
                                  controller: _progressController,
                                  color: progressColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  /// Applies scale + vertical offset for the stacked card effect.
  /// stackIndex 0 = front (newest), 1 = middle, 2 = back (oldest).
  Widget _buildStackTransform(Widget child) {
    if (widget.stackIndex == 0) return child;

    final depth = widget.stackIndex;
    final scale = 1.0 - (depth * 0.06);
    final isTop = _isTopPosition;
    final yShift = isTop ? -(depth * 8.0) : (depth * 8.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      transform: Matrix4.identity()
        ..translateByDouble(0.0, yShift, 0.0, 1.0)
        ..scaleByDouble(scale, scale, 1.0, 1.0),
      transformAlignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
      child: IgnorePointer(
        ignoring: true,
        child: Opacity(
          opacity: 1.0 - (depth * 0.15),
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Custom M3 decelerate curve
// ─────────────────────────────────────────────────────────────
class _M3Curve extends Curve {
  const _M3Curve();
  @override
  double transformInternal(double t) => 1 - (1 - t) * (1 - t) * (1 - t);
}

// ─────────────────────────────────────────────────────────────
// Material 3 icon
// ─────────────────────────────────────────────────────────────
class _M3Icon extends StatelessWidget {
  final ToastType type;
  final Color color;

  const _M3Icon({required this.type, required this.color});

  IconData get _icon => switch (type) {
        ToastType.success => Icons.check_circle_rounded,
        ToastType.error => Icons.error_rounded,
        ToastType.warning => Icons.warning_rounded,
        ToastType.info => Icons.info_rounded,
        ToastType.neutral => Icons.notifications_rounded,
      };

  @override
  Widget build(BuildContext context) => Icon(_icon, color: color, size: 22);
}

// ─────────────────────────────────────────────────────────────
// M3 action — text button with press ripple
// ─────────────────────────────────────────────────────────────
class _M3ActionButton extends StatefulWidget {
  final String label;
  final TextStyle? labelStyle;
  final Color color;
  final VoidCallback onTap;

  const _M3ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.labelStyle,
  });

  @override
  State<_M3ActionButton> createState() => _M3ActionButtonState();
}

class _M3ActionButtonState extends State<_M3ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _pressed
              ? widget.color.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.label.toUpperCase(),
          style: widget.labelStyle ??
              TextStyle(
                color: widget.color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// M3 close — icon button with press state
// ─────────────────────────────────────────────────────────────
class _M3CloseButton extends StatefulWidget {
  final Color color;
  final VoidCallback onTap;

  const _M3CloseButton({required this.color, required this.onTap});

  @override
  State<_M3CloseButton> createState() => _M3CloseButtonState();
}

class _M3CloseButtonState extends State<_M3CloseButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _pressed
              ? widget.color.withValues(alpha: 0.14)
              : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.close_rounded,
          size: 18,
          color: widget.color.withValues(alpha: 0.70),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// M3 progress bar
// ─────────────────────────────────────────────────────────────
class _M3ProgressBar extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _M3ProgressBar({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => LinearProgressIndicator(
        value: (1.0 - controller.value).clamp(0.0, 1.0),
        minHeight: 2,
        backgroundColor: color.withValues(alpha: 0.20),
        valueColor: AlwaysStoppedAnimation<Color>(color),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Loading toast — M3 style with dark mode support
// ─────────────────────────────────────────────────────────────
class LoadingToastWidget extends StatefulWidget {
  final String title;
  final String? message;
  final ToastPosition position;
  final Color? spinnerColor;

  const LoadingToastWidget({
    super.key,
    required this.title,
    this.message,
    required this.position,
    this.spinnerColor,
  });

  @override
  State<LoadingToastWidget> createState() => _LoadingToastWidgetState();
}

class _LoadingToastWidgetState extends State<LoadingToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool get _isTop =>
      widget.position == ToastPosition.top ||
      widget.position == ToastPosition.topLeft ||
      widget.position == ToastPosition.topRight;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 320));
    _fade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: Offset(0, _isTop ? -0.6 : 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: const _M3Curve()));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  AlignmentGeometry get _alignment {
    switch (widget.position) {
      case ToastPosition.top:
        return Alignment.topCenter;
      case ToastPosition.topRight:
        return Alignment.topRight;
      case ToastPosition.topLeft:
        return Alignment.topLeft;
      case ToastPosition.bottom:
        return Alignment.bottomCenter;
      case ToastPosition.bottomRight:
        return Alignment.bottomRight;
      case ToastPosition.bottomLeft:
        return Alignment.bottomLeft;
    }
  }

  EdgeInsets get _padding {
    final isTop = _isTop;
    final isLeft = widget.position == ToastPosition.topLeft ||
        widget.position == ToastPosition.bottomLeft;
    final isRight = widget.position == ToastPosition.topRight ||
        widget.position == ToastPosition.bottomRight;
    final isCenter = widget.position == ToastPosition.top ||
        widget.position == ToastPosition.bottom;
    return EdgeInsets.only(
      top: isTop ? 52 : 0,
      bottom: isTop ? 0 : 52,
      left: isLeft ? 16 : (isCenter ? 16 : 0),
      right: isRight ? 16 : (isCenter ? 16 : 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF2B2B2E) : const Color(0xFF1C1B1F);
    final label = isDark ? const Color(0xFFE6E1E5) : const Color(0xFFECE6F0);
    final subtext = isDark ? const Color(0xFFCAC4D0) : const Color(0xFFB0A8B9);
    final spinner = widget.spinnerColor ??
        (isDark ? const Color(0xFF80CBC4) : const Color(0xFF4DB6AC));

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: _alignment,
        child: Padding(
          padding: _padding,
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Container(
                constraints: const BoxConstraints(minWidth: 288, maxWidth: 560),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 20,
                        offset: const Offset(0, 6)),
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2)),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        strokeCap: StrokeCap.round,
                        valueColor: AlwaysStoppedAnimation<Color>(spinner),
                        backgroundColor: spinner.withValues(alpha: 0.20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: label,
                              letterSpacing: 0.1,
                              height: 1.4,
                            ),
                          ),
                          if (widget.message != null &&
                              widget.message!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.message!,
                              style: TextStyle(
                                fontSize: 12,
                                color: subtext,
                                height: 1.5,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ],
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
