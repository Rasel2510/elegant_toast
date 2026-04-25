# elegant_toast

[![pub version](https://img.shields.io/badge/pub-1.0.1-blue)](https://pub.dev/packages/elegant_toast)
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
- ✅ Fully customizable — colors, icons, text styles, border radius
- ✅ Context-free calls via `navigatorKey` — use from Rx, services, blocs

---

## Installation

```yaml
dependencies:
  elegant_toast: ^1.0.1
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

That's it. You can now call toasts from **anywhere** in your app.

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
ElegantToast.showWarning(title: 'Session expiring soon');

// Info
ElegantToast.showInfo(title: 'Update available', position: ToastPosition.topRight);

// Neutral
ElegantToast.showNeutral(title: 'Copied to clipboard');
```

---

## Progress Bar

Show a countdown bar at the bottom of the toast:

```dart
ElegantToast.showSuccess(
  title: 'File uploaded!',
  config: const ToastConfig(
    showProgressBar: true,
    duration: Duration(seconds: 5),
  ),
);
```

---

## Action Button

Add a tappable button (e.g. Undo, Retry) inside the toast:

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
```

---

## Toast Queue

Show toasts one after another without overlap:

```dart
ElegantToast.showSuccess(title: 'Step 1 done', useQueue: true);
ElegantToast.showInfo(title: 'Step 2 running', useQueue: true);
ElegantToast.showSuccess(title: 'All done!', useQueue: true);

// Clear the queue at any time
ElegantToast.clearQueue();
```

---

## Loading Toast

Show a spinner while an async operation runs, then convert to result:

```dart
ElegantToast.showLoading(
  title: 'Uploading file...',
  message: 'Please wait',
);

await uploadFile();

ElegantToast.completeLoading(
  type: ToastType.success,
  title: 'Uploaded!',
  message: 'File saved successfully.',
);
```

---

## Swipe to Dismiss

Enabled by default. Drag the toast left or right to dismiss it.
Disable it via config:

```dart
ToastConfig(swipeToDismiss: false)
```

---

## Persistent Toast

Toast stays until the user manually closes it:

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

```dart
// slideAndFade (default)
ToastConfig(animation: ToastAnimation.slideAndFade)

// Fade only
ToastConfig(animation: ToastAnimation.fade)

// Scale from center
ToastConfig(animation: ToastAnimation.scale)

// Bounce on entry
ToastConfig(animation: ToastAnimation.bounce)
```

---

## Positions

```dart
ToastPosition.top
ToastPosition.topRight
ToastPosition.topLeft
ToastPosition.bottom        // default
ToastPosition.bottomRight
ToastPosition.bottomLeft
```

---

## Custom Styling

Override any visual property using `ToastConfig`:

```dart
ElegantToast.show(
  context,
  type: ToastType.success,
  title: 'Custom styled!',
  message: 'Fully custom colors and icon.',
  config: ToastConfig(
    backgroundColor: const Color(0xFF1A1A2E),
    borderColor: const Color(0xFF7F77DD),
    iconBackgroundColor: const Color(0xFF7F77DD),
    icon: const Icon(Icons.star_rounded, color: Colors.white, size: 16),
    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    messageStyle: const TextStyle(color: Colors.white70),
    showProgressBar: true,
    progressBarColor: const Color(0xFF7F77DD),
    animation: ToastAnimation.scale,
    borderRadius: BorderRadius.circular(16),
  ),
);
```

---

## Context-based vs Context-free

### Context-based (inside widgets)
```dart
ElegantToast.success(context, title: 'Done!');
ElegantToast.error(context, title: 'Failed!');
ElegantToast.show(context, type: ToastType.info, title: 'Hello');
```

### Context-free (Rx, services, API handlers, blocs)
```dart
ElegantToast.showSuccess(title: 'Done!');
ElegantToast.showError(title: 'Failed!');
```

---

## ToastConfig Reference

| Property             | Type            | Default              | Description                                 |
|----------------------|-----------------|----------------------|---------------------------------------------|
| `backgroundColor`    | `Color?`        | type default         | Toast background color                      |
| `borderColor`        | `Color?`        | type default         | Toast border color                          |
| `icon`               | `Widget?`       | type icon            | Custom icon widget                          |
| `iconBackgroundColor`| `Color?`        | type default         | Icon circle background color                |
| `titleStyle`         | `TextStyle?`    | type default         | Title text style                            |
| `messageStyle`       | `TextStyle?`    | type default         | Message text style                          |
| `duration`           | `Duration`      | `3 seconds`          | Auto-dismiss duration                       |
| `showCloseButton`    | `bool`          | `true`               | Show/hide close button                      |
| `borderRadius`       | `BorderRadius?` | `12px`               | Container border radius                     |
| `padding`            | `EdgeInsets?`   | `h:14 v:12`          | Internal padding                            |
| `showProgressBar`    | `bool`          | `false`              | Show countdown progress bar                 |
| `progressBarColor`   | `Color?`        | type icon color      | Progress bar color                          |
| `action`             | `ToastAction?`  | `null`               | Action button (Undo, Retry, etc.)           |
| `persistent`         | `bool`          | `false`              | Disable auto-dismiss                        |
| `swipeToDismiss`     | `bool`          | `true`               | Allow swipe gesture to dismiss              |
| `animation`          | `ToastAnimation`| `slideAndFade`       | Entrance/exit animation style               |

---

## License

MIT © 2024 ElegantToast Contributors
