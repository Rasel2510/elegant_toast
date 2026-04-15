# elegant_toast

A beautiful, customizable toast notification package for Flutter.

## Features

- 5 built-in variants: `success`, `error`, `warning`, `info`, `neutral`
- 6 positions: `top`, `topRight`, `topLeft`, `bottom`, `bottomRight`, `bottomLeft`
- Smooth slide + fade animation
- Fully customizable: color, icon, text style, duration, border radius
- Auto-dismiss with configurable duration
- Close button (can be hidden)

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  elegant_toast:
    path: ../elegant_toast  # or pub.dev version
```

---

## Basic Usage

```dart
import 'package:elegant_toast/elegant_toast.dart';

// Success
ElegantToast.success(
  context,
  title: 'Booking confirmed!',
  message: 'Your tour has been successfully booked.',
);

// Error
ElegantToast.error(
  context,
  title: 'Something went wrong',
  message: 'Could not complete the request.',
);

// Warning
ElegantToast.warning(
  context,
  title: 'Session expiring soon',
);

// Info
ElegantToast.info(
  context,
  title: 'Update available',
  position: ToastPosition.topRight,
);

// Neutral
ElegantToast.neutral(
  context,
  title: 'Copied to clipboard',
);
```

---

## Positions

```dart
ToastPosition.top
ToastPosition.topRight
ToastPosition.topLeft
ToastPosition.bottom         // default
ToastPosition.bottomRight
ToastPosition.bottomLeft
```

---

## Custom Styling

Use `ToastConfig` to override anything:

```dart
ElegantToast.show(
  context,
  title: 'Custom Toast',
  message: 'Fully styled by you.',
  type: ToastType.success,
  config: ToastConfig(
    backgroundColor: const Color(0xFF1A1A2E),
    borderColor: const Color(0xFF7F77DD),
    iconBackgroundColor: const Color(0xFF7F77DD),
    icon: const Icon(Icons.star, color: Colors.white, size: 16),
    titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
    messageStyle: const TextStyle(color: Colors.white70, fontSize: 13),
    duration: Duration(seconds: 5),
    showCloseButton: true,
  ),
);
```

---

## ToastConfig Options

| Property             | Type            | Description                          |
|----------------------|-----------------|--------------------------------------|
| `backgroundColor`    | `Color?`        | Toast background color               |
| `borderColor`        | `Color?`        | Toast border color                   |
| `icon`               | `Widget?`       | Custom icon widget                   |
| `iconBackgroundColor`| `Color?`        | Icon circle background color         |
| `titleStyle`         | `TextStyle?`    | Title text style                     |
| `messageStyle`       | `TextStyle?`    | Message text style                   |
| `duration`           | `Duration`      | Auto-dismiss duration (default: 3s)  |
| `showCloseButton`    | `bool`          | Show/hide close button (default: true)|
| `borderRadius`       | `BorderRadius?` | Custom border radius                 |
| `padding`            | `EdgeInsets?`   | Internal padding                     |
