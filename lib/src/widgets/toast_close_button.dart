import 'package:flutter/material.dart';

class ToastCloseButton extends StatefulWidget {
  final Color color;
  final VoidCallback onTap;

  const ToastCloseButton({super.key, required this.color, required this.onTap});

  @override
  State<ToastCloseButton> createState() => _ToastCloseButtonState();
}

class _ToastCloseButtonState extends State<ToastCloseButton> {
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
