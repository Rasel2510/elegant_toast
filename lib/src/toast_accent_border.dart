/// The side where the accent border appears on the toast.
///
/// Used with [ToastConfig.accentBorderColor] and [ToastConfig.accentBorderSide].
///
/// Example:
/// ```dart
/// ToastConfig(
///   accentBorderColor: Color(0xFFE91E8C),
///   accentBorderSide: AccentBorderSide.left, // or right
/// )
/// ```
enum AccentBorderSide {
  /// Accent border on the left side (default).
  left,

  /// Accent border on the right side.
  right,
}
