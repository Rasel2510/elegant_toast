import 'package:flutter/material.dart';
import 'toast_type.dart';
import 'toast_animation.dart';
import 'toast_action.dart';
import 'toast_haptic_intensity.dart';

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

  /// If true, holding a finger on the toast pauses the progress bar countdown.
  /// Releasing resumes from where it stopped. Default is true.
  /// Has no effect when [showProgressBar] is false or [persistent] is true.
  ///
  /// ```dart
  /// ToastConfig(showProgressBar: true, pauseOnHold: true)
  /// ```
  final bool pauseOnHold;

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

  /// Size of the icon. Default is 22.
  final double iconSize;

  /// Called when the toast is dismissed (auto or manual).
  ///
  /// ```dart
  /// ToastConfig(
  ///   onDismiss: () => print('toast gone'),
  /// )
  /// ```
  final VoidCallback? onDismiss;

  /// If true, triggers haptic feedback when the toast appears.
  /// Intensity varies by type: error = heavy, warning = medium, others = light.
  /// Default is false.
  ///
  /// ```dart
  /// ToastConfig(hapticFeedback: true)
  /// ```
  final bool hapticFeedback;

  /// Overrides the automatic haptic intensity when [hapticFeedback] is true.
  /// If null, intensity is chosen by toast type (error=heavy, warning=medium, others=light).
  ///
  /// ```dart
  /// ToastConfig(hapticFeedback: true, hapticIntensity: HapticIntensity.heavy)
  /// ```
  final HapticIntensity? hapticIntensity;

  /// The entrance/exit animation style. Default is [ToastAnimation.slideAndFade].
  final ToastAnimation animation;

  /// If true, a "Show more" button appears on the toast.
  /// Tapping it expands the toast to show [expandedMessage].
  /// Default is false.
  ///
  /// ```dart
  /// ToastConfig(
  ///   expandable: true,
  ///   expandedMessage: 'Full error details here...',
  /// )
  /// ```
  final bool expandable;

  /// The full content shown when the toast is expanded.
  /// Only used when [expandable] is true.
  final String? expandedMessage;

  /// Label for the expand button. Default is 'Show more'.
  final String expandLabel;

  /// Label for the collapse button. Default is 'Show less'.
  final String collapseLabel;

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
    this.pauseOnHold = true,
    this.onTap,
    this.leftBorderColor,
    this.customBorder,
    this.hapticFeedback = false,
    this.hapticIntensity,
    this.animation = ToastAnimation.slideAndFade,
    this.iconSize = 22,
    this.onDismiss,
    this.expandable = false,
    this.expandedMessage,
    this.expandLabel = 'Show more',
    this.collapseLabel = 'Show less',
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
              backgroundColor: Color(0xFF0F1F0D),
              borderColor: Color(0xFF1E3B1A),
              accentColor: Color(0xFF4ADE80),
              iconColor: Color(0xFF4ADE80),
              labelColor: Color(0xFFDCFCE7),
              actionColor: Color(0xFF4ADE80),
            )
          : const ToastTheme(
              backgroundColor: Color(0xFFF0FDF4),
              borderColor: Color(0xFFBBF7D0),
              accentColor: Color(0xFF16A34A),
              iconColor: Color(0xFF16A34A),
              labelColor: Color(0xFF14532D),
              actionColor: Color(0xFF16A34A),
            );

    case ToastType.error:
      return isDark
          ? const ToastTheme(
              backgroundColor: Color(0xFF1C0A0A),
              borderColor: Color(0xFF3B1212),
              accentColor: Color(0xFFF87171),
              iconColor: Color(0xFFF87171),
              labelColor: Color(0xFFFFE4E6),
              actionColor: Color(0xFFF87171),
            )
          : const ToastTheme(
              backgroundColor: Color(0xFFFFF1F2),
              borderColor: Color(0xFFFFCDD2),
              accentColor: Color(0xFFDC2626),
              iconColor: Color(0xFFDC2626),
              labelColor: Color(0xFF7F1D1D),
              actionColor: Color(0xFFDC2626),
            );

    case ToastType.warning:
      return isDark
          ? const ToastTheme(
              backgroundColor: Color(0xFF1C1500),
              borderColor: Color(0xFF3B2E00),
              accentColor: Color(0xFFFBBF24),
              iconColor: Color(0xFFFBBF24),
              labelColor: Color(0xFFFEF9C3),
              actionColor: Color(0xFFFBBF24),
            )
          : const ToastTheme(
              backgroundColor: Color(0xFFFFFBEB),
              borderColor: Color(0xFFFDE68A),
              accentColor: Color(0xFFD97706),
              iconColor: Color(0xFFD97706),
              labelColor: Color(0xFF78350F),
              actionColor: Color(0xFFD97706),
            );

    case ToastType.info:
      return isDark
          ? const ToastTheme(
              backgroundColor: Color(0xFF080F1C),
              borderColor: Color(0xFF0F2040),
              accentColor: Color(0xFF60A5FA),
              iconColor: Color(0xFF60A5FA),
              labelColor: Color(0xFFDBEAFE),
              actionColor: Color(0xFF60A5FA),
            )
          : const ToastTheme(
              backgroundColor: Color(0xFFEFF6FF),
              borderColor: Color(0xFFBFDBFE),
              accentColor: Color(0xFF2563EB),
              iconColor: Color(0xFF2563EB),
              labelColor: Color(0xFF1E3A5F),
              actionColor: Color(0xFF2563EB),
            );

    case ToastType.neutral:
      return isDark
          ? const ToastTheme(
              backgroundColor: Color(0xFF18181B),
              borderColor: Color(0xFF27272A),
              accentColor: Color(0xFFC4B5FD),
              iconColor: Color(0xFFA1A1AA),
              labelColor: Color(0xFFF4F4F5),
              actionColor: Color(0xFFC4B5FD),
            )
          : const ToastTheme(
              backgroundColor: Color(0xFFFAFAFA),
              borderColor: Color(0xFFE4E4E7),
              accentColor: Color(0xFF7C3AED),
              iconColor: Color(0xFF52525B),
              labelColor: Color(0xFF18181B),
              actionColor: Color(0xFF7C3AED),
            );
  }
}
