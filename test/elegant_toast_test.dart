import 'package:flutter_test/flutter_test.dart';
import 'package:elegant_toast/elegant_toast.dart';

void main() {
  group('ToastConfig', () {
    test('default values are correct', () {
      const config = ToastConfig();
      expect(config.duration, const Duration(seconds: 3));
      expect(config.showCloseButton, true);
      expect(config.showProgressBar, false);
      expect(config.persistent, false);
      expect(config.swipeToDismiss, true);
      expect(config.animation, ToastAnimation.slideAndFade);
    });

    test('custom values are applied', () {
      final config = ToastConfig(
        duration: const Duration(seconds: 5),
        showCloseButton: false,
        showProgressBar: true,
        persistent: true,
        swipeToDismiss: false,
        animation: ToastAnimation.bounce,
        action: ToastAction(label: 'Undo', onPressed: () {}),
      );
      expect(config.duration, const Duration(seconds: 5));
      expect(config.showCloseButton, false);
      expect(config.showProgressBar, true);
      expect(config.persistent, true);
      expect(config.swipeToDismiss, false);
      expect(config.animation, ToastAnimation.bounce);
      expect(config.action, isNotNull);
      expect(config.action!.label, 'Undo');
    });
  });

  group('ToastType', () {
    test('all types resolve a theme', () {
      for (final type in ToastType.values) {
        final theme = getToastTheme(type);
        expect(theme.backgroundColor, isNotNull);
        expect(theme.borderColor, isNotNull);
        expect(theme.iconBackground, isNotNull);
        expect(theme.titleColor, isNotNull);
        expect(theme.iconLabel, isNotEmpty);
      }
    });
  });

  group('ToastPosition', () {
    test('all positions are defined', () {
      expect(ToastPosition.values.length, 6);
    });
  });

  group('ToastAnimation', () {
    test('all animations are defined', () {
      expect(ToastAnimation.values.length, 4);
    });
  });

  group('ToastAction', () {
    test('label and callback are stored', () {
      var called = false;
      final action = ToastAction(
        label: 'Retry',
        onPressed: () => called = true,
      );
      expect(action.label, 'Retry');
      action.onPressed();
      expect(called, true);
    });
  });
}
