import 'package:flutter/material.dart';
import 'toast_type.dart';
import 'toast_position.dart';
import 'toast_config.dart';
import 'toast_widget.dart';

class ElegantToast {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  /// Show a success toast
  static void success(
    BuildContext context, {
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
  }) {
    _show(context,
        title: title,
        message: message,
        type: ToastType.success,
        position: position,
        config: config);
  }

  /// Show an error toast
  static void error(
    BuildContext context, {
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
  }) {
    _show(context,
        title: title,
        message: message,
        type: ToastType.error,
        position: position,
        config: config);
  }

  /// Show a warning toast
  static void warning(
    BuildContext context, {
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
  }) {
    _show(context,
        title: title,
        message: message,
        type: ToastType.warning,
        position: position,
        config: config);
  }

  /// Show an info toast
  static void info(
    BuildContext context, {
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
  }) {
    _show(context,
        title: title,
        message: message,
        type: ToastType.info,
        position: position,
        config: config);
  }

  /// Show a neutral toast
  static void neutral(
    BuildContext context, {
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
  }) {
    _show(context,
        title: title,
        message: message,
        type: ToastType.neutral,
        position: position,
        config: config);
  }

  /// Show a fully custom toast
  static void show(
    BuildContext context, {
    required String title,
    String? message,
    required ToastType type,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
  }) {
    _show(context,
        title: title,
        message: message,
        type: type,
        position: position,
        config: config);
  }

  static void _show(
    BuildContext context, {
    required String title,
    String? message,
    required ToastType type,
    required ToastPosition position,
    required ToastConfig config,
  }) {
    _dismiss();

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => ToastWidget(
        title: title,
        message: message,
        type: type,
        position: position,
        config: config,
        onDismiss: _dismiss,
      ),
    );

    _isVisible = true;
    overlay.insert(_overlayEntry!);

    Future.delayed(config.duration, () {
      _dismiss();
    });
  }

  static void _dismiss() {
    if (_isVisible) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }
}
