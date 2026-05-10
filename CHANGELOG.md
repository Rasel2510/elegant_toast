# Changelog

## 1.2.0

### New Features
- Redesigned toast stack layout to iOS lock screen style — stacked toasts now fan out fully (72px offset per depth) so each toast is completely readable, with subtle scale (4%) and opacity (12%) reduction per depth level. Previously toasts were barely visible behind the front toast (8px offset, Sonner style).

### Documentation
- Updated `## Fully Custom Toast` snippet to include all available options.
- Updated `ToastConfig` reference table with all properties.

## 1.1.7

### Improvements
- Minor code formatting cleanup.

## 1.1.6

### New Features
- Added `hapticIntensity` — override the automatic haptic intensity with `HapticIntensity.light`, `medium`, `heavy`, or `selection`. If not set, intensity is still chosen automatically by toast type.

## 1.1.5

### Bug Fixes
- Fixed `hapticFeedback` — extracted into a dedicated `_triggerHaptic()` async method so all `HapticFeedback` calls are properly awaited instead of fire-and-forget.

### Documentation
- Added `hapticFeedback` to the `ToastConfig` reference table in README.
- Added `## Haptic Feedback` usage section with examples for all intensity levels.

## 1.1.4

### New Features
- Added `maxStack` — customize max visible toasts (default 3) via `ElegantToast.maxStack = 5`
- Added `hapticFeedback` — triggers device vibration on toast appear; intensity varies by type.

## 1.1.3

### New Features
- Added `expandable` toast — set `expandable: true` and `expandedMessage` to show
  a "Show more" button that animates open with full content
- Added `onDismiss` callback — called when toast is dismissed (auto, manual, or swipe)
- Added `iconSize` — customize the icon size (default 22)

## 1.1.2

### New Features
- Added `pauseOnHold` — long pressing the toast pauses the progress bar countdown

## 1.1.1

### Bug Fixes
- Fixed light mode toasts showing dark colors — light theme variants now use correct saturated backgrounds with light text.

## 1.1.0

### New Features
- **Dark mode** — all 5 variants adapt to the app's theme brightness automatically.
- **Exit animation** — toasts slide back out with a fade instead of disappearing instantly.
- **Swipe animation** — flies off screen in the drag direction; springs back if under threshold.
- **Stacked toasts** — up to 3 toasts stack at once, newest in front. Oldest auto-drops when full.
- **`ElegantToast.clearAll()`** — dismisses all stacked toasts and clears the queue.
- Only the frontmost toast is interactive; back toasts ignore pointer events.

### Internal
- Replaced `_overlayEntry` with a `_stack` list managing up to 3 `OverlayEntry` instances.
- Each toast has its own generation token so stale timers can't affect other toasts.
- `markNeedsBuild()` syncs scale/offset animations when the stack changes.

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