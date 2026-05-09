# Changelog

## 1.0.9

### Bug Fixes
- Fixed toast disappearing early after manually closing a previous one — stale auto-dismiss timers were firing on the next toast. Fixed with a generation token so old timers can never affect a newer toast.

## 1.0.8

### Visual Redesign — Premium Look
- New color palette: softer refined backgrounds with improved contrast across all 5 variants
- Glowing icon: circle now has subtle colored drop-shadow matching the variant accent
- Layered shadows: two-layer system (colored ambient + neutral key) for realistic depth
- Refined border: 0.75px border with lighter tones — cleaner, less heavy
- Premium close button: circular pill background instead of bare icon
- Polished action button: colored drop shadow on the action pill for tactile feel
- Better typography: letterSpacing -0.1 on titles, improved line-height on messages
- Smoother animation: easeOutQuart curve + 420ms duration for fluid entry
- Rounded progress bar: both ends fully rounded matching container corners
- Loading toast: rounded spinner cap (StrokeCap.round), improved background
- Larger maxWidth: raised from 400px to 420px

## 1.0.7

### Bug Fixes
- Fixed `borderRadius can only be given on borders with uniform colors` crash when using `customBorder` with different border colors — replaced `BoxDecoration` border+radius with `ClipRRect` approach

## 1.0.6

### New Features
- **`onTap`** — tap anywhere on the toast body to trigger a callback
- **`showIcon: false`** — hide the icon for a simple text-only toast
- **`maxLines`** — limit message lines with ellipsis overflow
-

## 1.0.5

### New Features
- **Left border accent** — `leftBorderColor` in `ToastConfig` adds a colored left-side border
- Useful for card-style toasts like appointments, reminders, or calendar events


## 1.0.4

### Improvements
- `navigatorKey` is no longer `final` — can now be assigned an existing key
- Supports sharing navigatorKey with other services (e.g. NavigationService, GetX)

## 1.0.3

### Changed
- Improved README with clearer usage examples
- Added installation instructions

## 1.0.2

### Improvements
- Replaced deprecated `withOpacity()` with `withValues()` to avoid color precision loss

## 1.0.1

### New Features
- **Progress bar** — animated countdown bar below the toast
- **Action button** — add Undo, Retry, View or any custom button inside the toast
- **Toast queue** — pass `useQueue: true` to stack toasts one after another
- **Swipe to dismiss** — drag left or right to dismiss; configurable via `swipeToDismiss`
- **Persistent toast** — set `persistent: true` to disable auto-dismiss
- **Loading toast** — `ElegantToast.showLoading()` then `ElegantToast.completeLoading()`
- **Animation styles** — `slideAndFade` (default), `fade`, `scale`, `bounce`
- Added `ElegantToast.dismiss()` to dismiss current toast programmatically
- Added `ElegantToast.clearQueue()` to clear all queued toasts

### Improvements
- Better internal architecture with queue management
- `ToastTheme` is now public for advanced customization
- Improved animation smoothness with `easeOutCubic` curve
- Cleaner separation of context-free and context-based APIs

## 1.0.0

- Initial release
- 5 toast types: success, error, warning, info, neutral
- 6 positions
- Fully customizable via ToastConfig
- Slide + fade animation
- Auto-dismiss and close button
- Context-free calls via `ElegantToast.navigatorKey`