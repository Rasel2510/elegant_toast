import 'package:flutter/material.dart';
import '../toast_animation.dart';

class ToastAnimated extends StatelessWidget {
  final ToastAnimation animation;
  final bool isTopPosition;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> scaleAnimation;
  final Animation<double> exitFade;
  final Animation<Offset> exitSlide;
  final Widget child;

  const ToastAnimated({
    super.key,
    required this.animation,
    required this.isTopPosition,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.scaleAnimation,
    required this.exitFade,
    required this.exitSlide,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final entered = switch (animation) {
      ToastAnimation.fade =>
        FadeTransition(opacity: fadeAnimation, child: child),
      ToastAnimation.scale => FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        ),
      _ => FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: slideAnimation, child: child),
        ),
    };

    return FadeTransition(
      opacity: exitFade,
      child: SlideTransition(position: exitSlide, child: entered),
    );
  }
}
