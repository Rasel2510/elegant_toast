/// A beautiful, customizable Flutter toast notification package.
///
/// ## Features
/// - 5 built-in variants: success, error, warning, info, neutral
/// - Progress bar with countdown timer
/// - Action buttons (Undo, Retry, View, etc.)
/// - Toast queue — multiple toasts stack one after another
/// - Swipe to dismiss
/// - Persistent toasts (no auto-dismiss)
/// - Loading toast that converts to success/error
/// - 6 positions
/// - 4 animation styles: slideAndFade, fade, scale, bounce
/// - Fully customizable colors, icons, and text styles
/// - Context-free calls via navigatorKey
///
/// ## Quick Start
/// ```dart
/// // 1. Attach navigatorKey in MaterialApp
/// MaterialApp(navigatorKey: ElegantToast.navigatorKey)
///
/// // 2. Show a toast from anywhere
/// ElegantToast.showSuccess(title: 'Done!', message: 'Saved successfully.');
///
/// // 3. Show with progress bar + action
/// ElegantToast.showError(
///   title: 'Deleted',
///   config: ToastConfig(
///     showProgressBar: true,
///     action: ToastAction(label: 'Undo', onPressed: () => restore()),
///   ),
/// );
/// ```
library elegant_toast;

export 'src/elegant_toast.dart';
export 'src/toast_type.dart';
export 'src/toast_position.dart';
export 'src/toast_config.dart';
export 'src/toast_animation.dart';
export 'src/toast_action.dart';
export 'src/toast_haptic_intensity.dart';
