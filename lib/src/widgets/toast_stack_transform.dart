import 'package:flutter/material.dart';
import '../toast_position.dart';
import '../toast_stack_state.dart';

class ToastStackTransform extends StatelessWidget {
  final ToastPosition position;
  final int stackIndex;
  final Widget child;

  const ToastStackTransform({
    super.key,
    required this.position,
    required this.stackIndex,
    required this.child,
  });

  bool get _isTopPosition =>
      position == ToastPosition.top ||
      position == ToastPosition.topLeft ||
      position == ToastPosition.topRight;

  @override
  Widget build(BuildContext context) {
    final depth = stackIndex;
    final isTop = _isTopPosition;
    final expanded = ToastStackState.expanded;

    // Collapsed: small peek (12px) — iOS notification stack
    // Expanded: full fan out (68px) — swipe up reveals all
    final collapsedShift = depth * 12.0;
    final expandedShift = depth * 68.0;
    final yShift = isTop
        ? -(expanded ? expandedShift : collapsedShift)
        : (expanded ? expandedShift : collapsedShift);

    final scale = expanded ? 1.0 - (depth * 0.02) : 1.0 - (depth * 0.05);
    final opacity = expanded ? 1.0 - (depth * 0.05) : 1.0 - (depth * 0.18);

    return GestureDetector(
      onVerticalDragEnd: (d) {
        final isUpSwipe = (d.primaryVelocity ?? 0) < -300;
        final isDownSwipe = (d.primaryVelocity ?? 0) > 300;
        if (isUpSwipe && !expanded) {
          ToastStackState.setExpanded(true);
        } else if (isDownSwipe && expanded) {
          ToastStackState.setExpanded(false);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translateByDouble(0.0, yShift, 0.0, 1.0)
          ..scaleByDouble(scale, scale, 1.0, 1.0),
        transformAlignment:
            isTop ? Alignment.topCenter : Alignment.bottomCenter,
        child: IgnorePointer(
          ignoring: !expanded && depth > 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: opacity.clamp(0.0, 1.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
