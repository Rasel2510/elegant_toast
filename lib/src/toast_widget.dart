import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'toast_type.dart';
import 'toast_position.dart';
import 'toast_config.dart';
import 'toast_animation.dart';
import 'toast_haptic_intensity.dart';
import 'widgets/toast_curve.dart';
import 'widgets/toast_animated.dart';
import 'widgets/toast_stack_transform.dart';
import 'widgets/toast_body.dart';

export 'widgets/toast_loading_widget.dart';

/// Internal widget that renders the toast overlay.
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

  double _dragOffset = 0;
  bool _isDismissing = false;
  bool _isExpanded = false;

  bool get _isTopPosition =>
      widget.position == ToastPosition.top ||
      widget.position == ToastPosition.topLeft ||
      widget.position == ToastPosition.topRight;

  // ── Init & Dispose ───────────────────────────────────────────────

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
          : const ToastCurve(),
    ));
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOutBack),
    );
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
    if (widget.config.hapticFeedback) _triggerHaptic();
    if (!widget.config.persistent && widget.config.showProgressBar) {
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _enterController.dispose();
    _exitController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  // ── Haptic ───────────────────────────────────────────────────────

  Future<void> _triggerHaptic() async {
    final intensity = widget.config.hapticIntensity ??
        switch (widget.type) {
          ToastType.error => HapticIntensity.heavy,
          ToastType.warning => HapticIntensity.medium,
          _ => HapticIntensity.light,
        };
    switch (intensity) {
      case HapticIntensity.heavy:
        await HapticFeedback.heavyImpact();
        break;
      case HapticIntensity.medium:
        await HapticFeedback.mediumImpact();
        break;
      case HapticIntensity.light:
        await HapticFeedback.lightImpact();
        break;
      case HapticIntensity.selection:
        await HapticFeedback.selectionClick();
        break;
    }
  }

  // ── Dismiss ──────────────────────────────────────────────────────

  Future<void> _animatedDismiss() async {
    if (_isDismissing) return;
    _isDismissing = true;
    await _exitController.forward();
    widget.config.onDismiss?.call();
    widget.onDismiss();
  }

  Future<void> _swipeDismiss(double targetX) async {
    if (_isDismissing) return;
    _isDismissing = true;
    final swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    final swipeAnim = Tween<double>(begin: _dragOffset, end: targetX).animate(
      CurvedAnimation(parent: swipeController, curve: Curves.easeOut),
    );
    swipeAnim.addListener(() {
      if (mounted) setState(() => _dragOffset = swipeAnim.value);
    });
    _exitController.animateTo(1.0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    await swipeController.forward();
    swipeController.dispose();
    widget.config.onDismiss?.call();
    widget.onDismiss();
  }

  // ── Gestures ─────────────────────────────────────────────────────

  void _handleLongPressStart(LongPressStartDetails _) {
    if (!widget.config.pauseOnHold || _isDismissing) return;
    if (widget.config.showProgressBar && !widget.config.persistent) {
      _progressController.stop();
    }
  }

  void _handleLongPressEnd(LongPressEndDetails _) {
    if (!widget.config.pauseOnHold || _isDismissing) return;
    if (widget.config.showProgressBar &&
        !widget.config.persistent &&
        !_isExpanded) {
      _progressController.forward();
    }
  }

  void _toggleExpand() {
    if (!widget.config.expandable || widget.config.expandedMessage == null) {
      return;
    }
    setState(() => _isExpanded = !_isExpanded);
    if (widget.config.showProgressBar && !widget.config.persistent) {
      _isExpanded ? _progressController.stop() : _progressController.forward();
    }
  }

  void _handleDragUpdate(DragUpdateDetails d) {
    if (!widget.config.swipeToDismiss || _isDismissing) return;
    setState(() => _dragOffset += d.delta.dx);
  }

  void _handleDragEnd(DragEndDetails d) {
    if (!widget.config.swipeToDismiss || _isDismissing) return;
    final velocity = d.primaryVelocity ?? 0;
    final screenWidth = MediaQuery.of(context).size.width;
    if (_dragOffset.abs() > 80 || velocity.abs() > 600) {
      _swipeDismiss(_dragOffset > 0 ? screenWidth : -screenWidth);
    } else {
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

  // ── Position helpers ─────────────────────────────────────────────

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

  // ── Build ────────────────────────────────────────────────────────

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
          child: ToastStackTransform(
            position: widget.position,
            stackIndex: widget.stackIndex,
            child: ToastAnimated(
              animation: config.animation,
              isTopPosition: _isTopPosition,
              fadeAnimation: _fadeAnimation,
              slideAnimation: _slideAnimation,
              scaleAnimation: _scaleAnimation,
              exitFade: _exitFade,
              exitSlide: _exitSlide,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: _handleDragUpdate,
                onHorizontalDragEnd: _handleDragEnd,
                onLongPressStart: _handleLongPressStart,
                onLongPressEnd: _handleLongPressEnd,
                onLongPressMoveUpdate: (_) {},
                onTap: config.onTap,
                child: Transform.translate(
                  offset: Offset(_dragOffset, 0),
                  child: Opacity(
                    opacity: (1 - (_dragOffset.abs() / 180)).clamp(0.0, 1.0),
                    child: ToastBody(
                      title: widget.title,
                      message: widget.message,
                      type: widget.type,
                      config: config,
                      bgColor: bgColor,
                      iconColor: iconColor,
                      labelColor: labelColor,
                      actionColor: actionColor,
                      progressColor: progressColor,
                      isExpanded: _isExpanded,
                      progressController: _progressController,
                      onToggleExpand: _toggleExpand,
                      onDismiss: _animatedDismiss,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
