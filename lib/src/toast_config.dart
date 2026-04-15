import 'package:flutter/material.dart';
import 'toast_type.dart';

class ToastConfig {
  /// Background color of the toast. Defaults to type color if null.
  final Color? backgroundColor;

  /// Border color of the toast. Defaults to type color if null.
  final Color? borderColor;

  /// Icon widget. Defaults to type icon if null.
  final Widget? icon;

  /// Icon background color. Defaults to type color if null.
  final Color? iconBackgroundColor;

  /// Title text style override.
  final TextStyle? titleStyle;

  /// Message text style override.
  final TextStyle? messageStyle;

  /// Duration before toast auto-dismisses. Default is 3 seconds.
  final Duration duration;

  /// Whether to show the close button.
  final bool showCloseButton;

  /// Border radius of the toast.
  final BorderRadius? borderRadius;

  /// Custom padding inside the toast.
  final EdgeInsets? padding;

  const ToastConfig({
    this.backgroundColor,
    this.borderColor,
    this.icon,
    this.iconBackgroundColor,
    this.titleStyle,
    this.messageStyle,
    this.duration = const Duration(seconds: 3),
    this.showCloseButton = true,
    this.borderRadius,
    this.padding,
  });
}

class _ToastTheme {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackground;
  final Color titleColor;
  final Color messageColor;
  final String iconLabel;

  const _ToastTheme({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackground,
    required this.titleColor,
    required this.messageColor,
    required this.iconLabel,
  });
}

_ToastTheme getToastTheme(ToastType type) {
  switch (type) {
    case ToastType.success:
      return _ToastTheme(
        backgroundColor: const Color(0xFFEAF3DE),
        borderColor: const Color(0xFF97C459),
        iconBackground: const Color(0xFF639922),
        titleColor: const Color(0xFF3B6D11),
        messageColor: const Color(0xFF3B6D11),
        iconLabel: '✓',
      );
    case ToastType.error:
      return _ToastTheme(
        backgroundColor: const Color(0xFFFCEBEB),
        borderColor: const Color(0xFFF09595),
        iconBackground: const Color(0xFFA32D2D),
        titleColor: const Color(0xFF791F1F),
        messageColor: const Color(0xFF791F1F),
        iconLabel: '✕',
      );
    case ToastType.warning:
      return _ToastTheme(
        backgroundColor: const Color(0xFFFAEEDA),
        borderColor: const Color(0xFFEF9F27),
        iconBackground: const Color(0xFFBA7517),
        titleColor: const Color(0xFF854F0B),
        messageColor: const Color(0xFF854F0B),
        iconLabel: '!',
      );
    case ToastType.info:
      return _ToastTheme(
        backgroundColor: const Color(0xFFE6F1FB),
        borderColor: const Color(0xFF85B7EB),
        iconBackground: const Color(0xFF185FA5),
        titleColor: const Color(0xFF0C447C),
        messageColor: const Color(0xFF0C447C),
        iconLabel: 'i',
      );
    case ToastType.neutral:
      return _ToastTheme(
        backgroundColor: const Color(0xFFF1EFE8),
        borderColor: const Color(0xFFB4B2A9),
        iconBackground: const Color(0xFF5F5E5A),
        titleColor: const Color(0xFF2C2C2A),
        messageColor: const Color(0xFF444441),
        iconLabel: '→',
      );
  }
}
