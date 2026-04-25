import 'package:flutter/material.dart';
import 'toast_type.dart';
import 'toast_position.dart';
import 'toast_config.dart';
import 'toast_widget.dart';

/// A beautiful, customizable Flutter toast notification system.
///
/// ## Setup
/// Attach [navigatorKey] once in your [MaterialApp]:
/// ```dart
/// MaterialApp(
///   navigatorKey: ElegantToast.navigatorKey,
/// )
/// ```
///
/// ## Context-free usage (from anywhere — Rx, services, bloc)
/// ```dart
/// ElegantToast.showSuccess(title: 'Saved!');
/// ElegantToast.showError(title: 'Failed!', message: 'Try again.');
/// ```
///
/// ## Context-based usage (inside widgets)
/// ```dart
/// ElegantToast.success(context, title: 'Done!');
/// ```
///
/// ## Loading toast
/// ```dart
/// ElegantToast.showLoading(title: 'Uploading...');
/// // later...
/// ElegantToast.completeLoading(type: ToastType.success, title: 'Done!');
/// ```
///
/// ## Queue mode
/// ```dart
/// ElegantToast.showSuccess(title: 'First', useQueue: true);
/// ElegantToast.showError(title: 'Second', useQueue: true);
/// // Shows one at a time, second waits for first to finish.
/// ```
class ElegantToast {
  ElegantToast._();

  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  // Queue state
  static final List<_QueueItem> _queue = [];
  static bool _queueProcessing = false;

  /// Attach this to [MaterialApp.navigatorKey] to enable context-free calls.
  ///
  /// ```dart
  /// MaterialApp(navigatorKey: ElegantToast.navigatorKey)
  /// ```
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static OverlayState? get _overlay => navigatorKey.currentState?.overlay;

  // ─────────────────────────────────────────────────────────────────
  // Context-free static methods (no BuildContext needed)
  // ─────────────────────────────────────────────────────────────────

  /// Shows a success toast without requiring a [BuildContext].
  ///
  /// Requires [navigatorKey] to be attached to [MaterialApp].
  static void showSuccess({
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
    bool useQueue = false,
  }) =>
      _showViaKey(
          title: title,
          message: message,
          type: ToastType.success,
          position: position,
          config: config,
          useQueue: useQueue);

  /// Shows an error toast without requiring a [BuildContext].
  static void showError({
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
    bool useQueue = false,
  }) =>
      _showViaKey(
          title: title,
          message: message,
          type: ToastType.error,
          position: position,
          config: config,
          useQueue: useQueue);

  /// Shows a warning toast without requiring a [BuildContext].
  static void showWarning({
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
    bool useQueue = false,
  }) =>
      _showViaKey(
          title: title,
          message: message,
          type: ToastType.warning,
          position: position,
          config: config,
          useQueue: useQueue);

  /// Shows an info toast without requiring a [BuildContext].
  static void showInfo({
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
    bool useQueue = false,
  }) =>
      _showViaKey(
          title: title,
          message: message,
          type: ToastType.info,
          position: position,
          config: config,
          useQueue: useQueue);

  /// Shows a neutral toast without requiring a [BuildContext].
  static void showNeutral({
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
    bool useQueue = false,
  }) =>
      _showViaKey(
          title: title,
          message: message,
          type: ToastType.neutral,
          position: position,
          config: config,
          useQueue: useQueue);

  /// Shows a loading spinner toast without requiring a [BuildContext].
  ///
  /// Call [completeLoading] to replace it with a success/error toast.
  static void showLoading({
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    Color? spinnerColor,
  }) {
    final overlay = _overlay;
    if (overlay == null) {
      _logMissingKey();
      return;
    }
    _dismissCurrent();
    _overlayEntry = OverlayEntry(
      builder: (_) => LoadingToastWidget(
        title: title,
        message: message,
        position: position,
        spinnerColor: spinnerColor,
      ),
    );
    _isVisible = true;
    overlay.insert(_overlayEntry!);
  }

  /// Replaces the current loading toast with a result toast.
  ///
  /// ```dart
  /// ElegantToast.showLoading(title: 'Saving...');
  /// await saveData();
  /// ElegantToast.completeLoading(type: ToastType.success, title: 'Saved!');
  /// ```
  static void completeLoading({
    required ToastType type,
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
  }) {
    _dismissCurrent();
    _showViaKey(
        title: title,
        message: message,
        type: type,
        position: position,
        config: config,
        useQueue: false);
  }

  /// Dismisses the currently visible toast immediately.
  static void dismiss() => _dismissCurrent();

  /// Clears all queued toasts and dismisses the current one.
  static void clearQueue() {
    _queue.clear();
    _queueProcessing = false;
    _dismissCurrent();
  }

  // ─────────────────────────────────────────────────────────────────
  // Context-based methods (use inside widgets)
  // ─────────────────────────────────────────────────────────────────

  /// Shows a success toast using a [BuildContext].
  static void success(
    BuildContext context, {
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
    bool useQueue = false,
  }) =>
      _showViaContext(context,
          title: title,
          message: message,
          type: ToastType.success,
          position: position,
          config: config,
          useQueue: useQueue);

  /// Shows an error toast using a [BuildContext].
  static void error(
    BuildContext context, {
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
    bool useQueue = false,
  }) =>
      _showViaContext(context,
          title: title,
          message: message,
          type: ToastType.error,
          position: position,
          config: config,
          useQueue: useQueue);

  /// Shows a warning toast using a [BuildContext].
  static void warning(
    BuildContext context, {
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
    bool useQueue = false,
  }) =>
      _showViaContext(context,
          title: title,
          message: message,
          type: ToastType.warning,
          position: position,
          config: config,
          useQueue: useQueue);

  /// Shows an info toast using a [BuildContext].
  static void info(
    BuildContext context, {
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
    bool useQueue = false,
  }) =>
      _showViaContext(context,
          title: title,
          message: message,
          type: ToastType.info,
          position: position,
          config: config,
          useQueue: useQueue);

  /// Shows a neutral toast using a [BuildContext].
  static void neutral(
    BuildContext context, {
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
    bool useQueue = false,
  }) =>
      _showViaContext(context,
          title: title,
          message: message,
          type: ToastType.neutral,
          position: position,
          config: config,
          useQueue: useQueue);

  /// Shows a fully customized toast using a [BuildContext].
  static void show(
    BuildContext context, {
    required String title,
    String? message,
    required ToastType type,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
    bool useQueue = false,
  }) =>
      _showViaContext(context,
          title: title,
          message: message,
          type: type,
          position: position,
          config: config,
          useQueue: useQueue);

  // ─────────────────────────────────────────────────────────────────
  // Internal
  // ─────────────────────────────────────────────────────────────────

  static void _showViaKey({
    required String title,
    String? message,
    required ToastType type,
    required ToastPosition position,
    required ToastConfig config,
    required bool useQueue,
  }) {
    final overlay = _overlay;
    if (overlay == null) {
      _logMissingKey();
      return;
    }
    _enqueueOrShow(
      overlay: overlay,
      title: title,
      message: message,
      type: type,
      position: position,
      config: config,
      useQueue: useQueue,
    );
  }

  static void _showViaContext(
    BuildContext context, {
    required String title,
    String? message,
    required ToastType type,
    required ToastPosition position,
    required ToastConfig config,
    required bool useQueue,
  }) {
    _enqueueOrShow(
      overlay: Overlay.of(context),
      title: title,
      message: message,
      type: type,
      position: position,
      config: config,
      useQueue: useQueue,
    );
  }

  static void _enqueueOrShow({
    required OverlayState overlay,
    required String title,
    String? message,
    required ToastType type,
    required ToastPosition position,
    required ToastConfig config,
    required bool useQueue,
  }) {
    if (useQueue) {
      _queue.add(_QueueItem(
        overlay: overlay,
        title: title,
        message: message,
        type: type,
        position: position,
        config: config,
      ));
      _processQueue();
    } else {
      _insertOverlay(
        overlay: overlay,
        title: title,
        message: message,
        type: type,
        position: position,
        config: config,
      );
    }
  }

  static void _processQueue() {
    if (_queueProcessing || _queue.isEmpty) return;
    _queueProcessing = true;
    final item = _queue.removeAt(0);
    _insertOverlay(
      overlay: item.overlay,
      title: item.title,
      message: item.message,
      type: item.type,
      position: item.position,
      config: item.config,
      onDone: () {
        _queueProcessing = false;
        Future.delayed(const Duration(milliseconds: 200), _processQueue);
      },
    );
  }

  static void _insertOverlay({
    required OverlayState overlay,
    required String title,
    String? message,
    required ToastType type,
    required ToastPosition position,
    required ToastConfig config,
    VoidCallback? onDone,
  }) {
    _dismissCurrent();

    void dismiss() {
      _dismissCurrent();
      onDone?.call();
    }

    _overlayEntry = OverlayEntry(
      builder: (_) => ToastWidget(
        title: title,
        message: message,
        type: type,
        position: position,
        config: config,
        onDismiss: dismiss,
      ),
    );
    _isVisible = true;
    overlay.insert(_overlayEntry!);

    if (!config.persistent) {
      Future.delayed(config.duration, dismiss);
    }
  }

  static void _dismissCurrent() {
    if (_isVisible) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }

  static void _logMissingKey() {
    debugPrint(
      '[ElegantToast] ⚠ navigatorKey is not attached. '
      'Add navigatorKey: ElegantToast.navigatorKey to your MaterialApp.',
    );
  }
}

class _QueueItem {
  final OverlayState overlay;
  final String title;
  final String? message;
  final ToastType type;
  final ToastPosition position;
  final ToastConfig config;

  _QueueItem({
    required this.overlay,
    required this.title,
    this.message,
    required this.type,
    required this.position,
    required this.config,
  });
}
