import 'package:flutter/material.dart';
import 'toast_type.dart';
import 'toast_position.dart';
import 'toast_config.dart';
import 'toast_animation.dart';

/// Internal widget that renders the toast UI with animations.
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
      duration: const Duration(milliseconds: 350),
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
      begin: Offset(0, isTop ? -0.4 : 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: widget.config.animation == ToastAnimation.bounce
          ? Curves.elasticOut
          : Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
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
      top: isTop ? 52 : 0,
      bottom: isTop ? 0 : 52,
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

  @override
  Widget build(BuildContext context) {
    final theme = getToastTheme(widget.type);
    final config = widget.config;

    final bgColor = config.backgroundColor ?? theme.backgroundColor;
    final borderColor = config.borderColor ?? theme.borderColor;
    final iconBgColor = config.iconBackgroundColor ?? theme.iconBackground;
    final titleColor = theme.titleColor;
    final messageColor = theme.messageColor;
    final progressColor = config.progressBarColor ?? theme.iconBackground;

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
              child: Transform.translate(
                offset: Offset(_dragOffset, 0),
                child: Opacity(
                  opacity: (1 - (_dragOffset.abs() / 200)).clamp(0.0, 1.0),
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 280,
                      maxWidth: 400,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius:
                          config.borderRadius ?? BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ─── Main content ───
                        Padding(
                          padding: config.padding ??
                              const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: config.icon ??
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: iconBgColor,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        theme.iconLabel,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                              ),
                              const SizedBox(width: 10),

                              // Title + Message + Action
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: config.titleStyle ??
                                          TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w600,
                                            color: titleColor,
                                          ),
                                    ),
                                    if (widget.message != null &&
                                        widget.message!.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.message!,
                                        style: config.messageStyle ??
                                            TextStyle(
                                              fontSize: 12.5,
                                              color:
                                                  messageColor.withOpacity(0.8),
                                            ),
                                      ),
                                    ],
                                    // Action button
                                    if (config.action != null) ...[
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          config.action!.onPressed();
                                          widget.onDismiss();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: iconBgColor,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            config.action!.label,
                                            style:
                                                config.action!.labelStyle ??
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Close button
                              if (config.showCloseButton) ...[
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: widget.onDismiss,
                                  child: Icon(
                                    Icons.close,
                                    size: 15,
                                    color: titleColor.withOpacity(0.45),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // ─── Progress Bar ───
                        if (config.showProgressBar && !config.persistent)
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(12),
                              bottomRight: const Radius.circular(12),
                              topLeft: config.action != null ||
                                      (widget.message != null &&
                                          widget.message!.isNotEmpty)
                                  ? Radius.zero
                                  : Radius.zero,
                              topRight: Radius.zero,
                            ),
                            child: AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, _) {
                                return LinearProgressIndicator(
                                  value: 1.0 - _progressController.value,
                                  minHeight: 3,
                                  backgroundColor:
                                      progressColor.withOpacity(0.15),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      progressColor),
                                );
                              },
                            ),
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
    );
  }
}

/// Internal loading toast widget that can be converted to success/error.
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
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOut),
    );
    final isTop = widget.position == ToastPosition.top ||
        widget.position == ToastPosition.topLeft ||
        widget.position == ToastPosition.topRight;
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, isTop ? -0.4 : 0.4),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _enterController, curve: Curves.easeOutCubic));
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
      top: isTop ? 52 : 0,
      bottom: isTop ? 0 : 52,
      left: isLeft ? 16 : (isCenter ? 16 : 0),
      right: isRight ? 16 : (isCenter ? 16 : 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spinnerColor = widget.spinnerColor ?? const Color(0xFF185FA5);
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
                constraints:
                    const BoxConstraints(minWidth: 280, maxWidth: 400),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F1FB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFF85B7EB), width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(spinnerColor),
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
                              color: Color(0xFF0C447C),
                            ),
                          ),
                          if (widget.message != null &&
                              widget.message!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.message!,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0x990C447C),
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
