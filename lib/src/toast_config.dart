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

  /// Icon color. Defaults to type color if null.
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

  /// Color of the progress bar. Defaults to the type's accent color.
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
  final Color? leftBorderColor;

  /// Fully custom border — use Flutter's [Border] to style any side.
  /// When set, overrides [borderColor] and [leftBorderColor].
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

/// Internal theme data resolved from [ToastType] and [Brightness].
class ToastTheme {
  final Color backgroundColor;
  final Color borderColor;
  final Color accentColor;
  final Color iconColor;
  final Color labelColor;
  final Color actionColor;

  const ToastTheme({
    required this.backgroundColor,
    required this.borderColor,
    required this.accentColor,
    required this.iconColor,
    required this.labelColor,
    required this.actionColor,
  });
}

/// Resolves the default theme colors for a given [ToastType] and [Brightness].
ToastTheme getToastTheme(ToastType type,
    {Brightness brightness = Brightness.light}) {
  final isDark = brightness == Brightness.dark;

  switch (type) {
    case ToastType.success:
      return isDark
          ? const ToastTheme(
              backgroundColor: Color(0xFF1C2B18),
              borderColor: Color(0xFF2D4A24),
              accentColor: Color(0xFF6FCF5A),
              iconColor: Color(0xFF6FCF5A),
              labelColor: Color(0xFFD4EDBA),
              actionColor: Color(0xFF6FCF5A),
            )
          : const ToastTheme(
              backgroundColor: Color(0xFF1B2014),
              borderColor: Color(0xFF2A3A1E),
              accentColor: Color(0xFF4CAF50),
              iconColor: Color(0xFF4CAF50),
              labelColor: Color(0xFFE8F5E9),
              actionColor: Color(0xFF81C784),
            );

    case ToastType.error:
      return isDark
          ? const ToastTheme(
              backgroundColor: Color(0xFF2C1A1A),
              borderColor: Color(0xFF4A2424),
              accentColor: Color(0xFFEF5350),
              iconColor: Color(0xFFEF5350),
              labelColor: Color(0xFFFFCDD2),
              actionColor: Color(0xFFEF9A9A),
            )
          : const ToastTheme(
              backgroundColor: Color(0xFF211414),
              borderColor: Color(0xFF3A1E1E),
              accentColor: Color(0xFFE53935),
              iconColor: Color(0xFFE53935),
              labelColor: Color(0xFFFFEBEE),
              actionColor: Color(0xFFEF9A9A),
            );

    case ToastType.warning:
      return isDark
          ? const ToastTheme(
              backgroundColor: Color(0xFF2B2210),
              borderColor: Color(0xFF4A3A18),
              accentColor: Color(0xFFFFB74D),
              iconColor: Color(0xFFFFB74D),
              labelColor: Color(0xFFFFE0B2),
              actionColor: Color(0xFFFFCC80),
            )
          : const ToastTheme(
              backgroundColor: Color(0xFF211A0A),
              borderColor: Color(0xFF3A2E10),
              accentColor: Color(0xFFFFA726),
              iconColor: Color(0xFFFFA726),
              labelColor: Color(0xFFFFF3E0),
              actionColor: Color(0xFFFFCC80),
            );

    case ToastType.info:
      return isDark
          ? const ToastTheme(
              backgroundColor: Color(0xFF182230),
              borderColor: Color(0xFF1E3A52),
              accentColor: Color(0xFF64B5F6),
              iconColor: Color(0xFF64B5F6),
              labelColor: Color(0xFFBBDEFB),
              actionColor: Color(0xFF90CAF9),
            )
          : const ToastTheme(
              backgroundColor: Color(0xFF101922),
              borderColor: Color(0xFF152B3A),
              accentColor: Color(0xFF2196F3),
              iconColor: Color(0xFF2196F3),
              labelColor: Color(0xFFE3F2FD),
              actionColor: Color(0xFF90CAF9),
            );

    case ToastType.neutral:
      return isDark
          ? const ToastTheme(
              backgroundColor: Color(0xFF2B2B2E),
              borderColor: Color(0xFF3A3A3D),
              accentColor: Color(0xFFCAC4D0),
              iconColor: Color(0xFFCAC4D0),
              labelColor: Color(0xFFE6E1E5),
              actionColor: Color(0xFFD0BCFF),
            )
          : const ToastTheme(
              backgroundColor: Color(0xFF1C1B1F),
              borderColor: Color(0xFF2C2B2F),
              accentColor: Color(0xFFCAC4D0),
              iconColor: Color(0xFFCAC4D0),
              labelColor: Color(0xFFE6E1E5),
              actionColor: Color(0xFFD0BCFF),
            );
  }
}
