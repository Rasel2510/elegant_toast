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
/// ## Stacked toasts (default behaviour when calling multiple times)
/// Up to 3 toasts stack behind each other. The newest is always on top.
/// Older toasts scale down and offset slightly for a Sonner-style look.
/// ```dart
/// ElegantToast.showSuccess(title: 'Saved!');
/// ElegantToast.showError(title: 'Failed!');
/// // Both visible — error in front, success stacked behind.
/// ```
///
/// ## Queue mode (one at a time)
/// ```dart
/// ElegantToast.showSuccess(title: 'First', useQueue: true);
/// ElegantToast.showError(title: 'Second', useQueue: true);
/// ```
///
/// ## Loading toast
/// ```dart
/// ElegantToast.showLoading(title: 'Uploading...');
/// ElegantToast.completeLoading(type: ToastType.success, title: 'Done!');
/// ```
class ElegantToast {
  ElegantToast._();

  // ── Stack (max 3 toasts visible at once) ──────────────────────────
  static const int _maxStack = 3;
  static final List<_StackEntry> _stack = [];

  // ── Generation token (prevents stale timers) ──────────────────────
  static int _toastGeneration = 0;

  // ── Queue ─────────────────────────────────────────────────────────
  static final List<_QueueItem> _queue = [];
  static bool _queueProcessing = false;

  // ── Loading overlay (separate — never stacked) ────────────────────
  static OverlayEntry? _loadingEntry;

  /// Attach this to [MaterialApp.navigatorKey] to enable context-free calls.
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static OverlayState? get _overlay => navigatorKey.currentState?.overlay;

  // ─────────────────────────────────────────────────────────────────
  // Context-free public API
  // ─────────────────────────────────────────────────────────────────

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
    _loadingEntry?.remove();
    _loadingEntry = OverlayEntry(
      builder: (_) => LoadingToastWidget(
        title: title,
        message: message,
        position: position,
        spinnerColor: spinnerColor,
      ),
    );
    overlay.insert(_loadingEntry!);
  }

  static void completeLoading({
    required ToastType type,
    required String title,
    String? message,
    ToastPosition position = ToastPosition.bottom,
    ToastConfig config = const ToastConfig(),
  }) {
    _loadingEntry?.remove();
    _loadingEntry = null;
    _showViaKey(
        title: title,
        message: message,
        type: type,
        position: position,
        config: config,
        useQueue: false);
  }

  /// Dismisses the top (newest) toast.
  static void dismiss() => _removeTop();

  /// Dismisses all visible toasts and clears the queue.
  static void clearAll() {
    _queue.clear();
    _queueProcessing = false;
    for (final e in _stack) {
      e.overlayEntry.remove();
    }
    _stack.clear();
    _toastGeneration++;
  }

  /// Clears all queued toasts and dismisses the current one.
  static void clearQueue() {
    _queue.clear();
    _queueProcessing = false;
    _removeTop();
  }

  // ─────────────────────────────────────────────────────────────────
  // Context-based public API
  // ─────────────────────────────────────────────────────────────────

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
  // Internal routing
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
        useQueue: useQueue);
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
        useQueue: useQueue);
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
          config: config));
      _processQueue();
    } else {
      _pushToStack(
          overlay: overlay,
          title: title,
          message: message,
          type: type,
          position: position,
          config: config);
    }
  }

  static void _processQueue() {
    if (_queueProcessing || _queue.isEmpty) return;
    _queueProcessing = true;
    final item = _queue.removeAt(0);
    _pushToStack(
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

  // ─────────────────────────────────────────────────────────────────
  // Stack management
  // ─────────────────────────────────────────────────────────────────

  static void _pushToStack({
    required OverlayState overlay,
    required String title,
    String? message,
    required ToastType type,
    required ToastPosition position,
    required ToastConfig config,
    VoidCallback? onDone,
  }) {
    // If stack is full, remove the oldest (bottom) entry
    if (_stack.length >= _maxStack) {
      final oldest = _stack.removeAt(0);
      oldest.overlayEntry.remove();
    }

    final myGeneration = ++_toastGeneration;
    late final _StackEntry entry;

    void dismissThis() {
      final idx = _stack.indexOf(entry);
      if (idx == -1) return; // already removed
      _toastGeneration++;
      _stack.removeAt(idx);
      entry.overlayEntry.remove();
      // Rebuild remaining entries so they animate to new stack positions
      _rebuildStack();
      onDone?.call();
    }

    final overlayEntry = OverlayEntry(
      builder: (_) {
        final stackIndex = _stack.indexOf(entry);
        final stackSize = _stack.length;
        return ToastWidget(
          title: title,
          message: message,
          type: type,
          position: position,
          config: config,
          stackIndex: stackIndex == -1 ? 0 : stackIndex,
          stackSize: stackSize,
          onDismiss: dismissThis,
        );
      },
    );

    entry = _StackEntry(
      overlayEntry: overlayEntry,
      generation: myGeneration,
    );

    _stack.add(entry);
    overlay.insert(overlayEntry);

    // Rebuild existing toasts so they shift back in the stack
    _rebuildStack();

    // Auto-dismiss
    if (!config.persistent) {
      Future.delayed(config.duration, () {
        if (entry.generation == myGeneration && _stack.contains(entry)) {
          dismissThis();
        }
      });
    }
  }

  /// Marks all stack entries dirty so they rebuild with updated stackIndex.
  static void _rebuildStack() {
    for (final e in _stack) {
      e.overlayEntry.markNeedsBuild();
    }
  }

  /// Removes the top (newest/frontmost) toast.
  static void _removeTop() {
    if (_stack.isEmpty) return;
    final top = _stack.removeLast();
    _toastGeneration++;
    top.overlayEntry.remove();
    _rebuildStack();
  }

  static void _logMissingKey() {
    debugPrint(
      '[ElegantToast] ⚠ navigatorKey is not attached. '
      'Add navigatorKey: ElegantToast.navigatorKey to your MaterialApp.',
    );
  }
}

// ── Internal stack entry ───────────────────────────────────────────
class _StackEntry {
  final OverlayEntry overlayEntry;
  final int generation;

  _StackEntry({required this.overlayEntry, required this.generation});
}

// ── Queue item ─────────────────────────────────────────────────────
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
