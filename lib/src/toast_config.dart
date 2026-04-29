import 'package:flutter/material.dart';
import 'toast_type.dart';
import 'toast_animation.dart';
import 'toast_action.dart';

/// Configuration for customizing the toast appearance and behavior.
///
/// All fields are optional — defaults are applied per [ToastType].
class ToastConfig {
  /// Background color of the toast. Defaults to type color if null.
  final Color? backgroundColor;

  /// Border color of the toast. Defaults to type color if null.
  final Color? borderColor;

  /// Custom icon widget. Defaults to type icon if null.
  final Widget? icon;

  /// Whether to show the icon. Default is true.
  /// Set to false for a simple text-only toast.
  ///
  /// ```dart
  /// ToastConfig(showIcon: false)
  /// ```
  final bool showIcon;

  /// Icon background color. Defaults to type color if null.
  final Color? iconBackgroundColor;

  /// Title text style override.
  final TextStyle? titleStyle;

  /// Message text style override.
  final TextStyle? messageStyle;

  /// Maximum number of lines for the message text.
  /// Default is null (no limit).
  ///
  /// ```dart
  /// ToastConfig(maxLines: 2)
  /// ```
  final int? maxLines;

  /// Duration before toast auto-dismisses. Default is 3 seconds.
  /// Has no effect when [persistent] is true.
  final Duration duration;

  /// Whether to show the close button. Default is true.
  final bool showCloseButton;

  /// Border radius of the toast container.
  final BorderRadius? borderRadius;

  /// Internal padding of the toast container.
  final EdgeInsets? padding;

  /// Whether to show a progress bar that counts down the [duration].
  /// Default is false.
  final bool showProgressBar;

  /// Color of the progress bar. Defaults to the type's icon color.
  final Color? progressBarColor;

  /// An optional action button shown inside the toast (e.g. "Undo", "Retry").
  final ToastAction? action;

  /// If true, the toast will not auto-dismiss. User must close manually.
  /// Default is false.
  final bool persistent;

  /// Whether the user can swipe the toast to dismiss it. Default is true.
  final bool swipeToDismiss;

  /// Called when the user taps anywhere on the toast body.
  ///
  /// ```dart
  /// ToastConfig(
  ///   onTap: () => Navigator.pushNamed(context, '/details'),
  /// )
  /// ```
  final VoidCallback? onTap;

  /// Optional left accent border color.
  /// When set, replaces the full border with a left-only colored border.
  /// Useful for card-style toasts like appointment or reminder notifications.
  ///
  /// ```dart
  /// ToastConfig(leftBorderColor: Color(0xFFE91E8C))
  /// ```
  final Color? leftBorderColor;

  /// Fully custom border — use Flutter's [Border] to style any side.
  /// When set, overrides [borderColor] and [leftBorderColor].
  ///
  /// ```dart
  /// // Left only
  /// customBorder: Border(left: BorderSide(color: Colors.pink, width: 4))
  ///
  /// // Right only
  /// customBorder: Border(right: BorderSide(color: Colors.blue, width: 4))
  ///
  /// // Top + Bottom
  /// customBorder: Border(
  ///   top: BorderSide(color: Colors.green, width: 3),
  ///   bottom: BorderSide(color: Colors.green, width: 3),
  /// )
  /// ```
  final Border? customBorder;

  /// The entrance/exit animation style. Default is [ToastAnimation.slideAndFade].
  final ToastAnimation animation;

  const ToastConfig({
    this.backgroundColor,
    this.borderColor,
    this.icon,
    this.showIcon = true,
    this.iconBackgroundColor,
    this.titleStyle,
    this.messageStyle,
    this.maxLines,
    this.duration = const Duration(seconds: 3),
    this.showCloseButton = true,
    this.borderRadius,
    this.padding,
    this.showProgressBar = false,
    this.progressBarColor,
    this.action,
    this.persistent = false,
    this.swipeToDismiss = true,
    this.onTap,
    this.leftBorderColor,
    this.customBorder,
    this.animation = ToastAnimation.slideAndFade,
  });
}

/// Internal theme data resolved from [ToastType].
class ToastTheme {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackground;
  final Color titleColor;
  final Color messageColor;
  final String iconLabel;

  const ToastTheme({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackground,
    required this.titleColor,
    required this.messageColor,
    required this.iconLabel,
  });
}

/// Resolves the default theme colors for a given [ToastType].
ToastTheme getToastTheme(ToastType type) {
  switch (type) {
    case ToastType.success:
      return const ToastTheme(
        backgroundColor: Color(0xFFEAF3DE),
        borderColor: Color(0xFF97C459),
        iconBackground: Color(0xFF639922),
        titleColor: Color(0xFF3B6D11),
        messageColor: Color(0xFF3B6D11),
        iconLabel: '✓',
      );
    case ToastType.error:
      return const ToastTheme(
        backgroundColor: Color(0xFFFCEBEB),
        borderColor: Color(0xFFF09595),
        iconBackground: Color(0xFFA32D2D),
        titleColor: Color(0xFF791F1F),
        messageColor: Color(0xFF791F1F),
        iconLabel: '✕',
      );
    case ToastType.warning:
      return const ToastTheme(
        backgroundColor: Color(0xFFFAEEDA),
        borderColor: Color(0xFFEF9F27),
        iconBackground: Color(0xFFBA7517),
        titleColor: Color(0xFF854F0B),
        messageColor: Color(0xFF854F0B),
        iconLabel: '!',
      );
    case ToastType.info:
      return const ToastTheme(
        backgroundColor: Color(0xFFE6F1FB),
        borderColor: Color(0xFF85B7EB),
        iconBackground: Color(0xFF185FA5),
        titleColor: Color(0xFF0C447C),
        messageColor: Color(0xFF0C447C),
        iconLabel: 'i',
      );
    case ToastType.neutral:
      return const ToastTheme(
        backgroundColor: Color(0xFFF1EFE8),
        borderColor: Color(0xFFB4B2A9),
        iconBackground: Color(0xFF5F5E5A),
        titleColor: Color(0xFF2C2C2A),
        messageColor: Color(0xFF444441),
        iconLabel: '→',
      );
  }
}
