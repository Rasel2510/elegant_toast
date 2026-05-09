import 'package:flutter/material.dart';

/// Custom Material 3 decelerate curve used by toast animations.
class ToastCurve extends Curve {
  const ToastCurve();

  @override
  double transformInternal(double t) => 1 - (1 - t) * (1 - t) * (1 - t);
}
