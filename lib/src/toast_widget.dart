import 'package:flutter/material.dart';
import 'toast_type.dart';
import 'toast_position.dart';
import 'toast_config.dart';
import 'toast_animation.dart';

/// Internal widget that renders the premium toast UI with animations.
class ToastWidget extends StatefulWidget {
  final String title;
  final String? message;
  final ToastType type;
  final ToastPosition position;
  final ToastConfig config;
  final VoidCallback onDismiss;

  const ToastWidget({
    super.key,
    required this.title,
    this.message,
    required this.type,
    required this.position,
    required this.config,
    required this.onDismiss,
  });

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with TickerProviderStateMixin {
  late AnimationController _enterController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  double _dragOffset = 0;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: widget.config.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOut),
    );

    final isTop = widget.position == ToastPosition.top ||
        widget.position == ToastPosition.topLeft ||
        widget.position == ToastPosition.topRight;

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, isTop ? -0.5 : 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: widget.config.animation == ToastAnimation.bounce
          ? Curves.elasticOut
          : Curves.easeOutQuart,
    ));

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOutBack),
    );

    _enterController.forward();

    if (!widget.config.persistent && widget.config.showProgressBar) {
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _enterController.dispose();
    _progressController.dispose();
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

  EdgeInsets get _screenPadding {
    final isTop = widget.position == ToastPosition.top ||
        widget.position == ToastPosition.topLeft ||
        widget.position == ToastPosition.topRight;
    final isLeft = widget.position == ToastPosition.topLeft ||
        widget.position == ToastPosition.bottomLeft;
    final isRight = widget.position == ToastPosition.topRight ||
        widget.position == ToastPosition.bottomRight;
    final isCenter = widget.position == ToastPosition.top ||
        widget.position == ToastPosition.bottom;

    return EdgeInsets.only(
      top: isTop ? 56 : 0,
      bottom: isTop ? 0 : 56,
      left: isLeft ? 16 : (isCenter ? 16 : 0),
      right: isRight ? 16 : (isCenter ? 16 : 0),
    );
  }

  Widget _buildAnimated(Widget child) {
    switch (widget.config.animation) {
      case ToastAnimation.fade:
        return FadeTransition(opacity: _fadeAnimation, child: child);
      case ToastAnimation.scale:
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(scale: _scaleAnimation, child: child),
        );
      case ToastAnimation.slideAndFade:
      case ToastAnimation.bounce:
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(position: _slideAnimation, child: child),
        );
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.config.swipeToDismiss) return;
    setState(() => _dragOffset += details.delta.dx);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.config.swipeToDismiss) return;
    if (_dragOffset.abs() > 80 && !_isDismissing) {
      _isDismissing = true;
      widget.onDismiss();
    } else {
      setState(() => _dragOffset = 0);
    }
  }

  BoxBorder _resolveBorder(
      Color borderColor, Color? leftBorderColor, Border? customBorder) {
    if (customBorder != null) return customBorder;
    if (leftBorderColor != null) {
      return Border(
        left: BorderSide(color: leftBorderColor, width: 3.5),
        top: BorderSide(color: borderColor, width: 0.5),
        right: BorderSide(color: borderColor, width: 0.5),
        bottom: BorderSide(color: borderColor, width: 0.5),
      );
    }
    return Border.all(color: borderColor, width: 0.75);
  }

  @override
  Widget build(BuildContext context) {
    final theme = getToastTheme(widget.type);
    final config = widget.config;

    final bgColor = config.backgroundColor ?? theme.backgroundColor;
    final borderColor = config.borderColor ?? theme.borderColor;
    final accentColor = theme.accentColor;
    final iconBgColor = config.iconBackgroundColor ?? theme.iconBackground;
    final titleColor = theme.titleColor;
    final messageColor = theme.messageColor;
    final progressColor = config.progressBarColor ?? accentColor;

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: _alignment,
        child: Padding(
          padding: _screenPadding,
          child: _buildAnimated(
            GestureDetector(
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              onTap: config.onTap,
              child: Transform.translate(
                offset: Offset(_dragOffset, 0),
                child: Opacity(
                  opacity: (1 - (_dragOffset.abs() / 200)).clamp(0.0, 1.0),
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 280,
                      maxWidth: 420,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          config.borderRadius ?? BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.10),
                          blurRadius: 24,
                          spreadRadius: 0,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.07),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius:
                          config.borderRadius ?? BorderRadius.circular(14),
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          border: _resolveBorder(
                            borderColor,
                            config.leftBorderColor,
                            config.customBorder,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ─── Main content ───
                            Padding(
                              padding: config.padding ??
                                  const EdgeInsets.fromLTRB(14, 13, 12, 13),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon
                                  if (config.showIcon) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1),
                                      child: config.icon ??
                                          _PremiumIcon(
                                            label: theme.iconLabel,
                                            color: iconBgColor,
                                          ),
                                    ),
                                    const SizedBox(width: 11),
                                  ],

                                  // Title + Message + Action
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
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w600,
                                                color: titleColor,
                                                letterSpacing: -0.1,
                                                height: 1.3,
                                              ),
                                        ),
                                        if (widget.message != null &&
                                            widget.message!.isNotEmpty) ...[
                                          const SizedBox(height: 3),
                                          Text(
                                            widget.message!,
                                            maxLines: config.maxLines,
                                            overflow: config.maxLines != null
                                                ? TextOverflow.ellipsis
                                                : null,
                                            style: config.messageStyle ??
                                                TextStyle(
                                                  fontSize: 12.5,
                                                  color: messageColor
                                                      .withValues(alpha: 0.72),
                                                  height: 1.45,
                                                ),
                                          ),
                                        ],
                                        // Action button
                                        if (config.action != null) ...[
                                          const SizedBox(height: 9),
                                          _ActionButton(
                                            label: config.action!.label,
                                            labelStyle:
                                                config.action!.labelStyle,
                                            accentColor: iconBgColor,
                                            onTap: () {
                                              config.action!.onPressed();
                                              widget.onDismiss();
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  // Close button
                                  if (config.showCloseButton) ...[
                                    const SizedBox(width: 8),
                                    _CloseButton(
                                      color: titleColor,
                                      onTap: widget.onDismiss,
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // ─── Progress Bar ───
                            if (config.showProgressBar && !config.persistent)
                              _ProgressBar(
                                controller: _progressController,
                                color: progressColor,
                                bgColor: progressColor.withValues(alpha: 0.12),
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Premium icon — glowing circle with crisp symbol
// ─────────────────────────────────────────────────────────────
class _PremiumIcon extends StatelessWidget {
  final String label;
  final Color color;

  const _PremiumIcon({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          height: 1.0,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Polished action button
// ─────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final Color accentColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.accentColor,
    required this.onTap,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.30),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: labelStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Refined close button — pill shape, not bare icon
// ─────────────────────────────────────────────────────────────
class _CloseButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _CloseButton({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.close_rounded,
          size: 13,
          color: color.withValues(alpha: 0.40),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Smooth shrinking progress bar
// ─────────────────────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final Color bgColor;

  const _ProgressBar({
    required this.controller,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          height: 3,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (1.0 - controller.value).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Loading toast widget
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
  late AnimationController _enterController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOut),
    );
    final isTop = widget.position == ToastPosition.top ||
        widget.position == ToastPosition.topLeft ||
        widget.position == ToastPosition.topRight;
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, isTop ? -0.5 : 0.5),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _enterController, curve: Curves.easeOutQuart));
    _enterController.forward();
  }

  @override
  void dispose() {
    _enterController.dispose();
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

  EdgeInsets get _screenPadding {
    final isTop = widget.position == ToastPosition.top ||
        widget.position == ToastPosition.topLeft ||
        widget.position == ToastPosition.topRight;
    final isLeft = widget.position == ToastPosition.topLeft ||
        widget.position == ToastPosition.bottomLeft;
    final isRight = widget.position == ToastPosition.topRight ||
        widget.position == ToastPosition.bottomRight;
    final isCenter = widget.position == ToastPosition.top ||
        widget.position == ToastPosition.bottom;
    return EdgeInsets.only(
      top: isTop ? 56 : 0,
      bottom: isTop ? 0 : 56,
      left: isLeft ? 16 : (isCenter ? 16 : 0),
      right: isRight ? 16 : (isCenter ? 16 : 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    const spinnerAccent = Color(0xFF2563EB);
    final spinnerColor = widget.spinnerColor ?? spinnerAccent;

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: _alignment,
        child: Padding(
          padding: _screenPadding,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                constraints: const BoxConstraints(minWidth: 280, maxWidth: 420),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F8FF),
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: const Color(0xFFCCDFF8), width: 0.75),
                  boxShadow: [
                    BoxShadow(
                      color: spinnerAccent.withValues(alpha: 0.10),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        strokeCap: StrokeCap.round,
                        valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
                        backgroundColor: spinnerColor.withValues(alpha: 0.15),
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
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D2A6B),
                              letterSpacing: -0.1,
                              height: 1.3,
                            ),
                          ),
                          if (widget.message != null &&
                              widget.message!.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              widget.message!,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: const Color(0xFF2B4A82)
                                    .withValues(alpha: 0.65),
                                height: 1.45,
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
