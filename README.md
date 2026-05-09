# elegant_toast

[![pub version](https://img.shields.io/badge/pub-1.1.2-blue)](https://pub.dev/packages/elegant_toast)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue)](https://flutter.dev)

A beautiful, customizable Flutter toast notification package.

---

## Features

- ✅ 5 built-in variants — `success`, `error`, `warning`, `info`, `neutral`
- ✅ Progress bar with countdown timer
- ✅ Action buttons — Undo, Retry, View, or any custom label
- ✅ Toast queue — multiple toasts show one after another
- ✅ Swipe to dismiss
- ✅ Persistent toast — no auto-dismiss
- ✅ Loading toast — shows spinner, converts to success/error
- ✅ `onTap` — tap anywhere on the toast to trigger a callback
- ✅ `showIcon: false` — simple text-only toast
- ✅ `maxLines` — limit message lines with ellipsis
- ✅ Left border accent — `leftBorderColor`
- ✅ Fully custom border — `customBorder` (any side, any width)
- ✅ 6 positions
- ✅ 4 animation styles — slideAndFade, fade, scale, bounce
- ✅ Fully customizable — colors, icons, text styles, border radius
- ✅ Context-free calls via `navigatorKey`

---

## Installation

```yaml
dependencies:
  elegant_toast: ^1.1.2
```

---

## Setup

```dart
MaterialApp(
  navigatorKey: ElegantToast.navigatorKey,
  home: MyHomePage(),
)

// Or assign your existing key
ElegantToast.navigatorKey = NavigationService.navigatorKey;
```

---

## Basic Usage

```dart
ElegantToast.showSuccess(title: 'Booking confirmed!', message: 'Your tour has been booked.');
ElegantToast.showError(title: 'Something went wrong', message: 'Try again.');
ElegantToast.showWarning(title: 'Session expiring soon');
ElegantToast.showInfo(title: 'Update available', position: ToastPosition.topRight);
ElegantToast.showNeutral(title: 'Copied to clipboard');
```

---

## onTap — Tap anywhere on toast

```dart
ElegantToast.showInfo(
  title: 'New message received',
  message: 'Tap to open inbox.',
  config: ToastConfig(
    onTap: () => Navigator.pushNamed(context, '/inbox'),
  ),
);
```

---

## showIcon: false — Text-only toast

```dart
ElegantToast.showSuccess(
  title: 'Done!',
  config: const ToastConfig(
    showIcon: false,
  ),
);
```

---

## maxLines — Limit message lines

```dart
ElegantToast.showInfo(
  title: 'Long message',
  message: 'This is a very long message that should be truncated after 2 lines.',
  config: const ToastConfig(
    maxLines: 2,
  ),
);
```

---

## Progress Bar

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

```dart
ElegantToast.showNeutral(
  title: 'Item deleted',
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

```dart
ElegantToast.showSuccess(title: 'Step 1 done', useQueue: true);
ElegantToast.showInfo(title: 'Step 2 running', useQueue: true);
ElegantToast.showSuccess(title: 'All done!', useQueue: true);

ElegantToast.clearQueue(); // clear all queued toasts
```

---

## Loading Toast

```dart
ElegantToast.showLoading(title: 'Uploading...', message: 'Please wait');
await uploadFile();
ElegantToast.completeLoading(type: ToastType.success, title: 'Uploaded!');
```

---

## Left Border Accent

```dart
ElegantToast.showNeutral(
  title: 'Dentist Appointment',
  message: '4:00 PM - 5:00 PM\nDental Clinic',
  config: ToastConfig(
    leftBorderColor: Color(0xFFE91E8C),
    backgroundColor: Color(0xFFFFF0F5),
  ),
);
```

---

## Custom Border (any side)

```dart
// Right border
ToastConfig(
  customBorder: Border(
    right: BorderSide(color: Colors.blue, width: 4),
  ),
)

// Top + Bottom
ToastConfig(
  customBorder: Border(
    top: BorderSide(color: Colors.green, width: 3),
    bottom: BorderSide(color: Colors.green, width: 3),
  ),
)

// Left + Right
ToastConfig(
  customBorder: Border(
    left: BorderSide(color: Colors.pink, width: 4),
    right: BorderSide(color: Colors.blue, width: 4),
  ),
)
```

> **Border priority:** `customBorder` → `leftBorderColor` → default `borderColor`

---

## Animations

```dart
ToastConfig(animation: ToastAnimation.slideAndFade) // default
ToastConfig(animation: ToastAnimation.fade)
ToastConfig(animation: ToastAnimation.scale)
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

## Persistent Toast

```dart
ElegantToast.showWarning(
  title: 'Action required',
  config: const ToastConfig(persistent: true),
);

ElegantToast.dismiss(); // dismiss programmatically
```

---

## Swipe to Dismiss

```dart
ToastConfig(swipeToDismiss: true)  // default
ToastConfig(swipeToDismiss: false) // disable
```

---

## Context-based vs Context-free

```dart
// Context-free — from services, Rx, blocs
ElegantToast.showSuccess(title: 'Done!');
ElegantToast.showError(title: 'Failed!');

// Context-based — inside widgets
ElegantToast.success(context, title: 'Done!');
ElegantToast.error(context, title: 'Failed!');
```

---

## Fully Custom Toast

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
    leftBorderColor: const Color(0xFF7F77DD),
    iconBackgroundColor: const Color(0xFF7F77DD),
    icon: const Icon(Icons.star_rounded, color: Colors.white, size: 16),
    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    messageStyle: const TextStyle(color: Colors.white70),
    showProgressBar: true,
    progressBarColor: const Color(0xFF7F77DD),
    animation: ToastAnimation.scale,
    borderRadius: BorderRadius.circular(16),
    duration: const Duration(seconds: 5),
    showCloseButton: true,
    swipeToDismiss: true,
    maxLines: 2,
    showIcon: true,
    onTap: () => navigateToDetails(),
    action: ToastAction(
      label: 'View',
      onPressed: () => navigateToDetails(),
    ),
  ),
);
```

---

## ToastConfig — Full Reference

| Property | Type | Default | Description |
|---|---|---|---|
| `backgroundColor` | `Color?` | type default | Toast background color |
| `borderColor` | `Color?` | type default | Toast border color (all sides) |
| `leftBorderColor` | `Color?` | `null` | Left accent border — 4px wide |
| `customBorder` | `Border?` | `null` | Fully custom border — any side, any width. Overrides `borderColor` and `leftBorderColor` |
| `icon` | `Widget?` | type icon | Custom icon widget |
| `showIcon` | `bool` | `true` | Show/hide the icon — `false` for text-only toast |
| `iconBackgroundColor` | `Color?` | type default | Icon circle background color |
| `titleStyle` | `TextStyle?` | type default | Title text style |
| `messageStyle` | `TextStyle?` | type default | Message text style |
| `maxLines` | `int?` | `null` | Max lines for message — truncates with ellipsis |
| `duration` | `Duration` | `3 seconds` | Auto-dismiss duration |
| `showCloseButton` | `bool` | `true` | Show/hide × close button |
| `borderRadius` | `BorderRadius?` | `12px` | Container border radius |
| `padding` | `EdgeInsets?` | `h:14 v:12` | Internal padding |
| `showProgressBar` | `bool` | `false` | Animated countdown progress bar |
| `progressBarColor` | `Color?` | type icon color | Progress bar color |
| `action` | `ToastAction?` | `null` | Action button (Undo, Retry, etc.) |
| `persistent` | `bool` | `false` | Disable auto-dismiss |
| `swipeToDismiss` | `bool` | `true` | Swipe left/right to dismiss |
| `onTap` | `VoidCallback?` | `null` | Callback when toast body is tapped |
| `animation` | `ToastAnimation` | `slideAndFade` | Entrance/exit animation style |

---

## ToastAction Reference

| Property | Type | Description |
|---|---|---|
| `label` | `String` | Button label (e.g. "Undo", "Retry") |
| `onPressed` | `VoidCallback` | Callback — toast auto-dismisses after |
| `labelStyle` | `TextStyle?` | Custom label text style |

---

## ToastPosition Values

| Value | Description |
|---|---|
| `ToastPosition.top` | Top center |
| `ToastPosition.topRight` | Top right |
| `ToastPosition.topLeft` | Top left |
| `ToastPosition.bottom` | Bottom center *(default)* |
| `ToastPosition.bottomRight` | Bottom right |
| `ToastPosition.bottomLeft` | Bottom left |

---

## ToastAnimation Values

| Value | Description |
|---|---|
| `ToastAnimation.slideAndFade` | Slides in + fades *(default)* |
| `ToastAnimation.fade` | Fades in/out only |
| `ToastAnimation.scale` | Scales up + fades |
| `ToastAnimation.bounce` | Bounces on entry |

---

## ToastType Values

| Value | Color | Use case |
|---|---|---|
| `ToastType.success` | Green | Successful operations |
| `ToastType.error` | Red | Failures, errors |
| `ToastType.warning` | Yellow | Warnings, cautions |
| `ToastType.info` | Blue | Informational messages |
| `ToastType.neutral` | Gray | General notifications |

---

## License

MIT © 2026 [RASEL](https://github.com/Rasel2510)
