import 'package:flutter/material.dart';

/// An action button displayed inside the toast.
///
/// Example:
/// ```dart
/// ToastAction(
///   label: 'Undo',
///   onPressed: () => undoDelete(),
/// )
/// ```
class ToastAction {
  /// The label text shown on the button.
  final String label;

  /// Callback when the button is tapped.
  final VoidCallback onPressed;

  /// Optional text style for the button label.
  final TextStyle? labelStyle;

  const ToastAction({
    required this.label,
    required this.onPressed,
    this.labelStyle,
  });
}
