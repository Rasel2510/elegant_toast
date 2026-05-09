import 'package:flutter/material.dart';

class ToastProgressBar extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const ToastProgressBar(
      {super.key, required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final progress = (1.0 - controller.value).clamp(0.0, 1.0);
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: SizedBox(
            height: 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(color: color.withValues(alpha: 0.20)),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(color: color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
