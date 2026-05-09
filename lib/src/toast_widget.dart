import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'toast_type.dart';
import 'toast_position.dart';
import 'toast_config.dart';
import 'toast_animation.dart';
import 'widgets/toast_curve.dart';
import 'widgets/toast_icon.dart';
import 'widgets/toast_close_button.dart';
import 'widgets/toast_action_button.dart';
import 'widgets/toast_progress_bar.dart';

export 'widgets/toast_loading_widget.dart';

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

  double _dragOffset = 0;
  bool _isDismissing = false;
  bool _isExpanded = false;

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

    if (widget.config.hapticFeedback) {
      _triggerHaptic();
    }

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

  // ── Haptic ───────────────────────────────────────────────────────

  Future<void> _triggerHaptic() async {
    switch (widget.type) {
      case ToastType.error:
        await HapticFeedback.heavyImpact();
        break;
      case ToastType.warning:
        await HapticFeedback.mediumImpact();
        break;
      default:
        await HapticFeedback.lightImpact();
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
      final targetX = _dragOffset > 0 ? screenWidth : -screenWidth;
      _swipeDismiss(targetX);
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

  // ── Animation builders ───────────────────────────────────────────

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

    return FadeTransition(
      opacity: _exitFade,
      child: SlideTransition(position: _exitSlide, child: entered),
    );
  }

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

  // ── Content builders ─────────────────────────────────────────────

  Widget _buildTextColumn(
      Color labelColor, Color actionColor, ToastConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        if (widget.message != null && widget.message!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            widget.message!,
            maxLines: config.maxLines,
            overflow: config.maxLines != null ? TextOverflow.ellipsis : null,
            style: config.messageStyle ??
                TextStyle(
                  fontSize: 12,
                  color: labelColor.withValues(alpha: 0.70),
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
          ),
        ],
        if (config.expandable &&
            config.expandedMessage != null &&
            _isExpanded) ...[
          const SizedBox(height: 6),
          Text(
            config.expandedMessage!,
            style: config.messageStyle ??
                TextStyle(
                  fontSize: 12,
                  color: labelColor.withValues(alpha: 0.70),
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
          ),
        ],
        if (config.expandable && config.expandedMessage != null) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _toggleExpand,
            child: Text(
              _isExpanded ? config.collapseLabel : config.expandLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: actionColor,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContentRow(Color iconColor, Color labelColor, Color actionColor,
      ToastConfig config) {
    return Padding(
      padding: config.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (config.showIcon) ...[
            config.icon ??
                ToastIcon(
                  type: widget.type,
                  color: iconColor,
                  size: config.iconSize,
                ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: _buildTextColumn(labelColor, actionColor, config),
          ),
          if (config.action != null) ...[
            const SizedBox(width: 8),
            ToastActionButton(
              label: config.action!.label,
              labelStyle: config.action!.labelStyle,
              color: actionColor,
              onTap: () {
                config.action!.onPressed();
                _animatedDismiss();
              },
            ),
          ],
          if (config.showCloseButton) ...[
            const SizedBox(width: 4),
            ToastCloseButton(
              color: labelColor,
              onTap: _animatedDismiss,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToastBody(Color bgColor, Color iconColor, Color labelColor,
      Color actionColor, Color progressColor, ToastConfig config) {
    return Container(
      constraints: const BoxConstraints(minWidth: 288, maxWidth: 560),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: config.borderRadius ?? BorderRadius.circular(16),
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
        borderRadius: config.borderRadius ?? BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContentRow(iconColor, labelColor, actionColor, config),
            if (config.showProgressBar && !config.persistent)
              ToastProgressBar(
                controller: _progressController,
                color: progressColor,
              ),
          ],
        ),
      ),
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
          child: _buildStackTransform(
            _buildAnimated(
              GestureDetector(
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
                    child: _buildToastBody(
                      bgColor,
                      iconColor,
                      labelColor,
                      actionColor,
                      progressColor,
                      config,
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
