# elegant_toast

[![pub version](https://img.shields.io/badge/pub-1.1.6-blue)](https://pub.dev/packages/elegant_toast)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue)](https://flutter.dev)

A beautiful, customizable Flutter toast notification package with dark/light mode support.

---

## Features

- ✅ 5 built-in variants — `success`, `error`, `warning`, `info`, `neutral`
- ✅ **Automatic dark/light mode** — follows your app's theme brightness
- ✅ Progress bar with countdown timer
- ✅ **Pause on hold** — long press pauses the progress bar countdown
- ✅ **Expandable toast** — "Show more" button reveals full content
- ✅ Action buttons — Undo, Retry, View, or any custom label
- ✅ `onDismiss` callback — called when toast disappears
- ✅ `onTap` — tap anywhere on the toast to trigger a callback
- ✅ `iconSize` — customize the icon size
- ✅ Toast queue — multiple toasts show one after another
- ✅ Swipe to dismiss
- ✅ Persistent toast — no auto-dismiss
- ✅ Loading toast — shows spinner, converts to success/error
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
  elegant_toast: ^1.1.6
```

---

## Setup

```dart
MaterialApp(
  navigatorKey: ElegantToast.navigatorKey,
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: ThemeMode.system, // toast follows system dark/light
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

## Dark / Light Mode

Toast colors automatically adapt to your app's theme brightness. No extra setup needed — just configure your `MaterialApp` with both `theme` and `darkTheme`:

```dart
MaterialApp(
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: ThemeMode.system, // or .dark / .light
)
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

## Pause on Hold

Long pressing the toast pauses the progress bar countdown. Releasing resumes it. Enabled by default when `showProgressBar` is true.

```dart
ElegantToast.showSuccess(
  title: 'Hold to pause',
  config: const ToastConfig(
    showProgressBar: true,
    pauseOnHold: true, // default is true
  ),
);
```

---

## Expandable Toast

Show a "Show more" button that reveals full content when tapped. Progress bar pauses while expanded.

```dart
ElegantToast.showError(
  title: 'Upload failed',
  message: 'Tap show more for details.',
  config: ToastConfig(
    expandable: true,
    expandedMessage: 'Connection timed out after 30s. Check your network and try again.',
    expandLabel: 'Show more',   // optional, default
    collapseLabel: 'Show less', // optional, default
  ),
);
```

---

## onDismiss Callback

Called when the toast disappears — whether auto-dismissed, manually closed, or swiped away.

```dart
ElegantToast.showSuccess(
  title: 'Profile saved!',
  config: ToastConfig(
    onDismiss: () => Navigator.pushNamed(context, '/home'),
  ),
);
```

---

## Icon Size

```dart
ElegantToast.showSuccess(
  title: 'Done!',
  config: const ToastConfig(
    iconSize: 28, // default is 22
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

## onTap

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

## Persistent Toast

```dart
ElegantToast.showWarning(
  title: 'Action required',
  config: const ToastConfig(persistent: true),
);

ElegantToast.dismiss(); // dismiss programmatically
ElegantToast.clearAll(); // dismiss all
```

---

## Left Border Accent

```dart
ElegantToast.showNeutral(
  title: 'Dentist Appointment',
  message: '4:00 PM - 5:00 PM',
  config: ToastConfig(
    leftBorderColor: Color(0xFFE91E8C),
    backgroundColor: Color(0xFFFFF0F5),
  ),
);
```

---

## Custom Border

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
```

> **Border priority:** `customBorder` → `leftBorderColor` → default `borderColor`

---

## Haptic Feedback

```dart
// Auto intensity by type (error=heavy, warning=medium, others=light)
ElegantToast.showError(
  title: 'Payment failed',
  config: const ToastConfig(
    hapticFeedback: true,
  ),
);

// Override intensity manually
ElegantToast.showSuccess(
  title: 'Saved!',
  config: const ToastConfig(
    hapticFeedback: true,
    hapticIntensity: HapticIntensity.heavy,
  ),
);

ElegantToast.showInfo(
  title: 'New message',
  config: const ToastConfig(
    hapticFeedback: true,
    hapticIntensity: HapticIntensity.selection, // subtle tick
  ),
);
```

> If `hapticIntensity` is not set, intensity is automatically chosen by toast type: `error` → heavy, `warning` → medium, all others → light.

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
  useQueue: false,
  config: ToastConfig(
    // Colors
    backgroundColor: const Color(0xFF1A1A2E),
    borderColor: const Color(0xFF7F77DD),
    leftBorderColor: const Color(0xFF7F77DD),
    iconBackgroundColor: const Color(0xFF7F77DD),

    // Custom border (overrides borderColor & leftBorderColor)
    // customBorder: Border(left: BorderSide(color: Color(0xFF7F77DD), width: 4)),

    // Icon
    icon: const Icon(Icons.star_rounded, color: Colors.white, size: 16),
    showIcon: true,
    iconSize: 24,

    // Text styles
    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    messageStyle: const TextStyle(color: Colors.white70),
    maxLines: 2,

    // Layout
    borderRadius: BorderRadius.circular(16),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

    // Duration & dismissal
    duration: const Duration(seconds: 5),
    persistent: false,
    showCloseButton: true,
    swipeToDismiss: true,

    // Progress bar
    showProgressBar: true,
    progressBarColor: const Color(0xFF7F77DD),
    pauseOnHold: true,

    // Animation
    animation: ToastAnimation.scale,

    // Haptic
    hapticFeedback: true,
    hapticIntensity: HapticIntensity.heavy,

    // Expandable
    expandable: true,
    expandedMessage: 'Here are the full details of this notification.',
    expandLabel: 'Show more',
    collapseLabel: 'Show less',

    // Callbacks
    onTap: () => navigateToDetails(),
    onDismiss: () => print('toast gone'),

    // Action button
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
| `borderColor` | `Color?` | type default | Toast border color |
| `leftBorderColor` | `Color?` | `null` | Left accent border |
| `customBorder` | `Border?` | `null` | Fully custom border — overrides `borderColor` and `leftBorderColor` |
| `icon` | `Widget?` | type icon | Custom icon widget |
| `showIcon` | `bool` | `true` | Show/hide the icon |
| `iconSize` | `double` | `22` | Size of the icon |
| `iconBackgroundColor` | `Color?` | type default | Icon color |
| `titleStyle` | `TextStyle?` | type default | Title text style |
| `messageStyle` | `TextStyle?` | type default | Message text style |
| `maxLines` | `int?` | `null` | Max lines for message |
| `duration` | `Duration` | `3 seconds` | Auto-dismiss duration |
| `showCloseButton` | `bool` | `true` | Show/hide × close button |
| `borderRadius` | `BorderRadius?` | `16px` | Container border radius |
| `padding` | `EdgeInsets?` | `h:16 v:14` | Internal padding |
| `showProgressBar` | `bool` | `false` | Animated countdown progress bar |
| `pauseOnHold` | `bool` | `true` | Long press pauses progress bar |
| `progressBarColor` | `Color?` | type accent | Progress bar color |
| `action` | `ToastAction?` | `null` | Action button |
| `persistent` | `bool` | `false` | Disable auto-dismiss |
| `swipeToDismiss` | `bool` | `true` | Swipe left/right to dismiss |
| `expandable` | `bool` | `false` | Show "Show more" button |
| `expandedMessage` | `String?` | `null` | Full content shown when expanded |
| `expandLabel` | `String` | `'Show more'` | Expand button label |
| `collapseLabel` | `String` | `'Show less'` | Collapse button label |
| `onTap` | `VoidCallback?` | `null` | Callback when toast is tapped |
| `onDismiss` | `VoidCallback?` | `null` | Callback when toast is dismissed |
| `animation` | `ToastAnimation` | `slideAndFade` | Entrance/exit animation style |
| `hapticFeedback` | `bool` | `false` | Triggers haptic on appear; intensity varies by type (error=heavy, warning=medium, others=light) |
| `hapticIntensity` | `HapticIntensity?` | `null` | Overrides automatic haptic intensity: `light`, `medium`, `heavy`, `selection` |

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
| `ToastType.warning` | Amber | Warnings, cautions |
| `ToastType.info` | Blue | Informational messages |
| `ToastType.neutral` | Gray | General notifications |

---

## License

MIT © 2026 [Rasel2510](https://github.com/Rasel2510)