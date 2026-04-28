# elegant_toast

[![pub version](https://img.shields.io/badge/pub-1.0.4-blue)](https://pub.dev/packages/elegant_toast)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue)](https://flutter.dev)

A beautiful, customizable Flutter toast notification package with progress bar, action buttons, toast queue, swipe to dismiss, persistent toasts, loading toasts, and 4 animation styles.

---

## Features

- ✅ 5 built-in variants — `success`, `error`, `warning`, `info`, `neutral`
- ✅ Progress bar with countdown timer
- ✅ Action buttons — Undo, Retry, View, or any custom label
- ✅ Toast queue — multiple toasts show one after another
- ✅ Swipe to dismiss — drag left/right to close
- ✅ Persistent toast — no auto-dismiss, user closes manually
- ✅ Loading toast — shows spinner, converts to success/error
- ✅ 6 positions — top, topRight, topLeft, bottom, bottomRight, bottomLeft
- ✅ 4 animation styles — slideAndFade, fade, scale, bounce
- ✅ Fully customizable — colors, icons, text styles, border radius, padding
- ✅ Context-free calls via `navigatorKey` — use from Rx, services, blocs
- ✅ `dismiss()` and `clearQueue()` for programmatic control

---

## Installation

```yaml
dependencies:
  elegant_toast: ^1.0.4
```

---

## Setup

Attach `ElegantToast.navigatorKey` **once** in your `MaterialApp`:

```dart
import 'package:elegant_toast/elegant_toast.dart';

MaterialApp(
  navigatorKey: ElegantToast.navigatorKey,
  home: MyHomePage(),
)
```

That's it. You can now call toasts from **anywhere** in your app — widgets, services, Rx handlers, blocs.

---

## Toast Types

| Type | Method (context-free) | Method (context-based) |
|---|---|---|
| Success | `ElegantToast.showSuccess(...)` | `ElegantToast.success(context, ...)` |
| Error | `ElegantToast.showError(...)` | `ElegantToast.error(context, ...)` |
| Warning | `ElegantToast.showWarning(...)` | `ElegantToast.warning(context, ...)` |
| Info | `ElegantToast.showInfo(...)` | `ElegantToast.info(context, ...)` |
| Neutral | `ElegantToast.showNeutral(...)` | `ElegantToast.neutral(context, ...)` |
| Custom | `ElegantToast.show(context, type: ...)` | `ElegantToast.show(context, type: ...)` |

---

## Basic Usage

```dart
// Success
ElegantToast.showSuccess(
  title: 'Booking confirmed!',
  message: 'Your tour has been successfully booked.',
);

// Error
ElegantToast.showError(
  title: 'Something went wrong',
  message: 'Could not complete the request.',
);

// Warning
ElegantToast.showWarning(
  title: 'Session expiring soon',
  message: 'You will be logged out in 5 minutes.',
);

// Info
ElegantToast.showInfo(
  title: 'Update available',
  message: 'A new version of the app is ready.',
  position: ToastPosition.topRight,
);

// Neutral
ElegantToast.showNeutral(
  title: 'Copied to clipboard',
  position: ToastPosition.bottomRight,
);
```

---

## Positions

6 positions available. Default is `ToastPosition.bottom`.

```dart
ElegantToast.showSuccess(
  title: 'Hello!',
  position: ToastPosition.top,         // Top center
  // position: ToastPosition.topRight,  // Top right
  // position: ToastPosition.topLeft,   // Top left
  // position: ToastPosition.bottom,    // Bottom center (default)
  // position: ToastPosition.bottomRight, // Bottom right
  // position: ToastPosition.bottomLeft,  // Bottom left
);
```

---

## Duration

Control how long the toast stays visible. Default is 3 seconds.

```dart
ElegantToast.showSuccess(
  title: 'Saved!',
  config: const ToastConfig(
    duration: Duration(seconds: 5), // stays for 5 seconds
  ),
);
```

---

## Progress Bar

Show an animated countdown bar at the bottom of the toast.

```dart
ElegantToast.showSuccess(
  title: 'File uploaded!',
  message: 'Your file has been saved.',
  config: const ToastConfig(
    showProgressBar: true,
    duration: Duration(seconds: 5),
  ),
);

// Custom progress bar color
ElegantToast.showError(
  title: 'Upload failed',
  config: const ToastConfig(
    showProgressBar: true,
    progressBarColor: Color(0xFFFF5252),
  ),
);
```

---

## Action Button

Add a tappable button inside the toast — Undo, Retry, View, or any label.

```dart
ElegantToast.showNeutral(
  title: 'Item deleted',
  message: 'The item has been removed.',
  config: ToastConfig(
    showProgressBar: true,
    duration: const Duration(seconds: 5),
    action: ToastAction(
      label: 'Undo',
      onPressed: () => restoreItem(),
    ),
  ),
);

// Custom action label style
ToastAction(
  label: 'Retry',
  onPressed: () => retryUpload(),
  labelStyle: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 13,
  ),
)
```

---

## Close Button

Show or hide the close (×) button. Shown by default.

```dart
// Hide close button
ElegantToast.showInfo(
  title: 'FYI',
  config: const ToastConfig(
    showCloseButton: false,
  ),
);
```

---

## Toast Queue

Show toasts one after another without overlap. Pass `useQueue: true`.

```dart
ElegantToast.showSuccess(title: 'Step 1 done', useQueue: true);
ElegantToast.showInfo(title: 'Step 2 running', useQueue: true);
ElegantToast.showSuccess(title: 'All done!', useQueue: true);

// Clear all queued toasts
ElegantToast.clearQueue();
```

> Default behavior (`useQueue: false`) replaces the current toast immediately when a new one is shown.

---

## Loading Toast

Show a spinner while an async operation runs, then convert to a result toast.

```dart
// Show loading
ElegantToast.showLoading(
  title: 'Uploading file...',
  message: 'Please wait',
  spinnerColor: Colors.blue, // optional
);

await uploadFile();

// Convert to result
ElegantToast.completeLoading(
  type: ToastType.success,
  title: 'Uploaded!',
  message: 'File saved successfully.',
);

// Or convert to error
ElegantToast.completeLoading(
  type: ToastType.error,
  title: 'Upload failed',
  message: 'Server error. Try again.',
);
```

---

## Swipe to Dismiss

Enabled by default. Drag the toast left or right to dismiss it.

```dart
// Enabled (default)
ToastConfig(swipeToDismiss: true)

// Disabled
ToastConfig(swipeToDismiss: false)
```

---

## Persistent Toast

Toast stays on screen until the user manually closes it. Useful for important alerts.

```dart
ElegantToast.showWarning(
  title: 'Action required',
  message: 'Please complete your profile.',
  config: const ToastConfig(persistent: true),
);

// Dismiss programmatically
ElegantToast.dismiss();
```

---

## Animation Styles

4 animation styles available. Default is `slideAndFade`.

```dart
// Slide in from top/bottom + fade (default)
ToastConfig(animation: ToastAnimation.slideAndFade)

// Fade in/out only
ToastConfig(animation: ToastAnimation.fade)

// Scale up from center + fade
ToastConfig(animation: ToastAnimation.scale)

// Bounce effect on entry
ToastConfig(animation: ToastAnimation.bounce)
```

---

## Custom Colors

Override background, border, and icon colors.

```dart
ElegantToast.showSuccess(
  title: 'Custom colors',
  config: const ToastConfig(
    backgroundColor: Color(0xFF1A1A2E),
    borderColor: Color(0xFF7F77DD),
    iconBackgroundColor: Color(0xFF7F77DD),
  ),
);
```

---

## Custom Icon

Replace the default icon with any widget.

```dart
ElegantToast.showSuccess(
  title: 'Custom icon',
  config: const ToastConfig(
    icon: Icon(Icons.star_rounded, color: Colors.white, size: 16),
    iconBackgroundColor: Color(0xFF7F77DD),
  ),
);
```

---

## Custom Text Styles

Override title and message text styles.

```dart
ElegantToast.showInfo(
  title: 'Custom text',
  message: 'Styled message here.',
  config: const ToastConfig(
    titleStyle: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
    messageStyle: TextStyle(
      color: Colors.white70,
      fontSize: 13,
      fontStyle: FontStyle.italic,
    ),
  ),
);
```

---

## Custom Border Radius

```dart
ElegantToast.showSuccess(
  title: 'Rounded',
  config: ToastConfig(
    borderRadius: BorderRadius.circular(24), // more rounded
  ),
);

// Pill shape
ToastConfig(borderRadius: BorderRadius.circular(100))

// Square
ToastConfig(borderRadius: BorderRadius.zero)
```

---

## Custom Padding

```dart
ElegantToast.showSuccess(
  title: 'Custom padding',
  config: const ToastConfig(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  ),
);
```

---

## Fully Custom Toast

Combine everything for a completely custom look:

```dart
ElegantToast.show(
  context,
  type: ToastType.success,
  title: 'Custom styled!',
  message: 'Fully custom colors, icon, and animation.',
  position: ToastPosition.top,
  config: ToastConfig(
    backgroundColor: const Color(0xFF1A1A2E),
    borderColor: const Color(0xFF7F77DD),
    iconBackgroundColor: const Color(0xFF7F77DD),
    icon: const Icon(Icons.star_rounded, color: Colors.white, size: 16),
    titleStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    ),
    messageStyle: const TextStyle(
      color: Colors.white70,
      fontSize: 13,
    ),
    showProgressBar: true,
    progressBarColor: const Color(0xFF7F77DD),
    animation: ToastAnimation.scale,
    borderRadius: BorderRadius.circular(16),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    duration: const Duration(seconds: 5),
    showCloseButton: true,
    swipeToDismiss: true,
    action: ToastAction(
      label: 'View',
      onPressed: () => navigateToDetails(),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
);
```

---

## Context-based vs Context-free

### Context-based — inside widgets
```dart
ElegantToast.success(context, title: 'Done!', message: 'Saved.');
ElegantToast.error(context, title: 'Failed!');
ElegantToast.warning(context, title: 'Watch out!');
ElegantToast.info(context, title: 'FYI');
ElegantToast.neutral(context, title: 'Copied!');
ElegantToast.show(context, type: ToastType.info, title: 'Hello');
```

### Context-free — from services, Rx, API handlers, blocs
```dart
ElegantToast.showSuccess(title: 'Done!');
ElegantToast.showError(title: 'Failed!');
ElegantToast.showWarning(title: 'Watch out!');
ElegantToast.showInfo(title: 'FYI');
ElegantToast.showNeutral(title: 'Copied!');
```

---

## Programmatic Control

```dart
// Dismiss current toast
ElegantToast.dismiss();

// Clear all queued toasts + dismiss current
ElegantToast.clearQueue();
```

---

## AppToast Pattern (Recommended)

Create a wrapper class with app-specific toasts for cleaner code:

```dart
class AppToast {
  AppToast._();

  static void loginSuccess() => ElegantToast.showSuccess(
    title: 'Welcome back!',
    message: 'You have successfully logged in.',
    config: const ToastConfig(showProgressBar: true),
  );

  static void loginFailed({String? message}) => ElegantToast.showError(
    title: 'Login failed',
    message: message ?? 'Invalid email or password.',
    config: const ToastConfig(showProgressBar: true),
  );

  static void noInternet() => ElegantToast.showError(
    title: 'No internet connection',
    message: 'Please check your network and try again.',
    position: ToastPosition.top,
    config: const ToastConfig(persistent: true),
  );

  static void deleted({VoidCallback? onUndo}) => ElegantToast.showNeutral(
    title: 'Item deleted',
    config: ToastConfig(
      showProgressBar: true,
      duration: const Duration(seconds: 5),
      action: onUndo != null
          ? ToastAction(label: 'Undo', onPressed: onUndo)
          : null,
    ),
  );
}

// Usage anywhere in your app
AppToast.loginSuccess();
AppToast.noInternet();
AppToast.deleted(onUndo: () => restoreItem());
```

---

## ToastConfig — Full Reference

| Property | Type | Default | Description |
|---|---|---|---|
| `backgroundColor` | `Color?` | type default | Toast background color |
| `borderColor` | `Color?` | type default | Toast border color |
| `icon` | `Widget?` | type icon | Custom icon widget (replaces default circle icon) |
| `iconBackgroundColor` | `Color?` | type default | Icon circle background color |
| `titleStyle` | `TextStyle?` | type default | Title text style |
| `messageStyle` | `TextStyle?` | type default | Message text style |
| `duration` | `Duration` | `3 seconds` | Auto-dismiss duration (ignored if persistent) |
| `showCloseButton` | `bool` | `true` | Show/hide the × close button |
| `borderRadius` | `BorderRadius?` | `12px` | Container border radius |
| `padding` | `EdgeInsets?` | `h:14 v:12` | Internal content padding |
| `showProgressBar` | `bool` | `false` | Show animated countdown progress bar |
| `progressBarColor` | `Color?` | type icon color | Progress bar fill color |
| `action` | `ToastAction?` | `null` | Action button (Undo, Retry, View, etc.) |
| `persistent` | `bool` | `false` | Disable auto-dismiss — user must close manually |
| `swipeToDismiss` | `bool` | `true` | Allow left/right swipe to dismiss |
| `animation` | `ToastAnimation` | `slideAndFade` | Entrance/exit animation style |

---

## ToastAction — Reference

| Property | Type | Description |
|---|---|---|
| `label` | `String` | Button label text (e.g. "Undo", "Retry") |
| `onPressed` | `VoidCallback` | Callback when button is tapped (toast auto-dismisses after) |
| `labelStyle` | `TextStyle?` | Optional custom text style for the label |

---

## ToastPosition — All Values

| Value | Description |
|---|---|
| `ToastPosition.top` | Top center |
| `ToastPosition.topRight` | Top right corner |
| `ToastPosition.topLeft` | Top left corner |
| `ToastPosition.bottom` | Bottom center *(default)* |
| `ToastPosition.bottomRight` | Bottom right corner |
| `ToastPosition.bottomLeft` | Bottom left corner |

---

## ToastAnimation — All Values

| Value | Description |
|---|---|
| `ToastAnimation.slideAndFade` | Slides in from top/bottom + fades *(default)* |
| `ToastAnimation.fade` | Fades in/out only |
| `ToastAnimation.scale` | Scales up from center + fades |
| `ToastAnimation.bounce` | Bounces on entry |

---

## ToastType — All Values

| Value | Color | Use case |
|---|---|---|
| `ToastType.success` | Green | Successful operations |
| `ToastType.error` | Red | Failures, errors |
| `ToastType.warning` | Yellow | Warnings, cautions |
| `ToastType.info` | Blue | Informational messages |
| `ToastType.neutral` | Gray | General notifications |

---

## License

MIT © 2024 ElegantToast Contributors
