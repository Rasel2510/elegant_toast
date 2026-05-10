/// Shared stack expansion state — used by both ElegantToast and ToastWidget
/// to avoid a circular import.
class ToastStackState {
  ToastStackState._();

  static bool _expanded = false;
  static bool get expanded => _expanded;

  static Function()? onChanged;

  static void setExpanded(bool value) {
    _expanded = value;
    onChanged?.call();
  }

  static void reset() {
    _expanded = false;
  }
}
