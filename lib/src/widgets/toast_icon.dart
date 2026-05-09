import 'package:flutter/material.dart';
import '../toast_type.dart';

class ToastIcon extends StatelessWidget {
  final ToastType type;
  final Color color;
  final double size;

  const ToastIcon({
    super.key,
    required this.type,
    required this.color,
    this.size = 22,
  });

  IconData get _icon => switch (type) {
        ToastType.success => Icons.check_circle_rounded,
        ToastType.error => Icons.error_rounded,
        ToastType.warning => Icons.warning_rounded,
        ToastType.info => Icons.info_rounded,
        ToastType.neutral => Icons.notifications_rounded,
      };

  @override
  Widget build(BuildContext context) => Icon(_icon, color: color, size: size);
}
