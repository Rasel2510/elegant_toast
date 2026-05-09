import 'package:flutter/material.dart';

class ToastActionButton extends StatefulWidget {
  final String label;
  final TextStyle? labelStyle;
  final Color color;
  final VoidCallback onTap;

  const ToastActionButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
    this.labelStyle,
  });

  @override
  State<ToastActionButton> createState() => _ToastActionButtonState();
}

class _ToastActionButtonState extends State<ToastActionButton> {
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
