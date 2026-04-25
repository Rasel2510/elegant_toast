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
