/// The haptic feedback intensity when a toast appears.
///
/// Used with [ToastConfig.hapticIntensity] when [ToastConfig.hapticFeedback] is true.
///
/// If not set, intensity is automatically chosen by toast type:
/// error = heavy, warning = medium, all others = light.
enum HapticIntensity {
  /// Light impact — subtle feedback. Default for success, info, neutral.
  light,

  /// Medium impact — moderate feedback. Default for warning.
  medium,

  /// Heavy impact — strong feedback. Default for error.
  heavy,

  /// Selection click — very subtle, tick-like feedback.
  selection,
}
