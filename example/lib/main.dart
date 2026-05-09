import 'package:flutter/material.dart';
import 'package:elegant_toast/elegant_toast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elegant Toast Example',
      navigatorKey: ElegantToast.navigatorKey,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const ToastDemoPage(),
    );
  }
}

class ToastDemoPage extends StatelessWidget {
  const ToastDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elegant Toast 1.1.3')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Basic Toasts ──────────────────────────────────────
          _section('Basic Toasts'),
          _btn(
              'Success',
              () => ElegantToast.showSuccess(
                    title: 'Booking confirmed!',
                    message: 'Your tour has been successfully booked.',
                  )),
          _btn(
              'Error',
              () => ElegantToast.showError(
                    title: 'Something went wrong',
                    message: 'Could not complete the request.',
                  )),
          _btn(
              'Warning',
              () => ElegantToast.showWarning(
                    title: 'Session expiring soon',
                    message: 'You will be logged out in 5 minutes.',
                    position: ToastPosition.top,
                  )),
          _btn(
              'Info',
              () => ElegantToast.showInfo(
                    title: 'Update available',
                    message: 'A new version of the app is ready.',
                    position: ToastPosition.topRight,
                  )),
          _btn(
              'Neutral',
              () => ElegantToast.showNeutral(
                    title: 'Copied to clipboard',
                    position: ToastPosition.bottomRight,
                  )),

          // ── Progress Bar ──────────────────────────────────────
          _section('Progress Bar'),
          _btn(
              'Success + Progress Bar',
              () => ElegantToast.showSuccess(
                    title: 'File uploaded!',
                    message: 'Your file has been saved.',
                    config: const ToastConfig(
                      showProgressBar: true,
                      duration: Duration(seconds: 5),
                    ),
                  )),
          _btn(
              'Error + Progress Bar',
              () => ElegantToast.showError(
                    title: 'Upload failed',
                    message: 'Check your connection.',
                    config: const ToastConfig(
                      showProgressBar: true,
                      duration: Duration(seconds: 4),
                    ),
                  )),

          // ── Pause on Hold ─────────────────────────────────────
          _section('Pause on Hold'),
          _btn(
              'Hold to pause progress bar',
              () => ElegantToast.showInfo(
                    title: 'Hold me to pause',
                    message: 'Long press pauses the countdown.',
                    config: const ToastConfig(
                      showProgressBar: true,
                      pauseOnHold: true,
                      duration: Duration(seconds: 6),
                    ),
                  )),

          // ── Expandable Toast ──────────────────────────────────
          _section('Expandable Toast'),
          _btn(
              'Show more / Show less',
              () => ElegantToast.showError(
                    title: 'Upload failed',
                    message: 'Tap show more for details.',
                    config: const ToastConfig(
                      expandable: true,
                      expandedMessage:
                          'Connection timed out after 30s. Server returned 504. Check your network and try again.',
                      duration: Duration(seconds: 8),
                    ),
                  )),

          // ── onDismiss Callback ────────────────────────────────
          _section('onDismiss Callback'),
          _btn(
              'onDismiss → print',
              () => ElegantToast.showSuccess(
                    title: 'Saved!',
                    config: ToastConfig(
                      onDismiss: () => debugPrint('Toast dismissed!'),
                    ),
                  )),

          // ── Icon Size ─────────────────────────────────────────
          _section('Icon Size'),
          _btn(
              'Large icon (32)',
              () => ElegantToast.showSuccess(
                    title: 'Large icon',
                    config: const ToastConfig(iconSize: 32),
                  )),
          _btn(
              'Small icon (14)',
              () => ElegantToast.showInfo(
                    title: 'Small icon',
                    config: const ToastConfig(iconSize: 14),
                  )),

          // ── Action Button ─────────────────────────────────────
          _section('Action Button'),
          _btn(
              'With Undo Action',
              () => ElegantToast.showNeutral(
                    title: 'Item deleted',
                    message: 'The item has been removed.',
                    config: ToastConfig(
                      showProgressBar: true,
                      duration: const Duration(seconds: 5),
                      action: ToastAction(
                        label: 'Undo',
                        onPressed: () => debugPrint('Undo tapped!'),
                      ),
                    ),
                  )),
          _btn(
              'With Retry Action',
              () => ElegantToast.showError(
                    title: 'Upload failed',
                    config: ToastConfig(
                      showProgressBar: true,
                      action: ToastAction(
                        label: 'Retry',
                        onPressed: () => debugPrint('Retry tapped!'),
                      ),
                    ),
                  )),

          // ── onTap ─────────────────────────────────────────────
          _section('onTap'),
          _btn(
              'Tap to print',
              () => ElegantToast.showInfo(
                    title: 'Tap anywhere on me',
                    config: ToastConfig(
                      onTap: () => debugPrint('Toast tapped!'),
                    ),
                  )),

          // ── Toast Queue ───────────────────────────────────────
          _section('Toast Queue'),
          _btn('Queue 3 Toasts', () {
            ElegantToast.showSuccess(title: 'First toast', useQueue: true);
            ElegantToast.showWarning(title: 'Second toast', useQueue: true);
            ElegantToast.showInfo(title: 'Third toast', useQueue: true);
          }),

          // ── Loading Toast ─────────────────────────────────────
          _section('Loading Toast'),
          _btn('Loading → Success', () async {
            ElegantToast.showLoading(
              title: 'Uploading file...',
              message: 'Please wait',
            );
            await Future.delayed(const Duration(seconds: 2));
            ElegantToast.completeLoading(
              type: ToastType.success,
              title: 'Uploaded!',
              message: 'File saved successfully.',
            );
          }),
          _btn('Loading → Error', () async {
            ElegantToast.showLoading(title: 'Saving...');
            await Future.delayed(const Duration(seconds: 2));
            ElegantToast.completeLoading(
              type: ToastType.error,
              title: 'Save failed',
              message: 'Server error. Try again.',
            );
          }),

          // ── Animations ────────────────────────────────────────
          _section('Animations'),
          _btn(
              'Slide & Fade (default)',
              () => ElegantToast.showSuccess(
                    title: 'Slide & Fade',
                    config: const ToastConfig(
                        animation: ToastAnimation.slideAndFade),
                  )),
          _btn(
              'Scale',
              () => ElegantToast.showInfo(
                    title: 'Scale animation',
                    config: const ToastConfig(animation: ToastAnimation.scale),
                  )),
          _btn(
              'Bounce',
              () => ElegantToast.showSuccess(
                    title: 'Bounce animation',
                    config: const ToastConfig(animation: ToastAnimation.bounce),
                  )),
          _btn(
              'Fade only',
              () => ElegantToast.showNeutral(
                    title: 'Fade animation',
                    config: const ToastConfig(animation: ToastAnimation.fade),
                  )),

          // ── Persistent Toast ──────────────────────────────────
          _section('Persistent Toast'),
          _btn(
              'Persistent (manual close only)',
              () => ElegantToast.showWarning(
                    title: 'Action required',
                    message: 'Please complete your profile.',
                    config: const ToastConfig(persistent: true),
                  )),

          // ── Swipe to Dismiss ──────────────────────────────────
          _section('Swipe to Dismiss'),
          _btn(
              'Swipe me left/right',
              () => ElegantToast.showInfo(
                    title: 'Swipe to dismiss',
                    message: 'Drag me left or right!',
                    config: const ToastConfig(
                      duration: Duration(seconds: 8),
                      swipeToDismiss: true,
                    ),
                  )),

          // ── Left Border Accent ────────────────────────────────
          _section('Left Border Accent'),
          _btn(
              'Calendar style',
              () => ElegantToast.showNeutral(
                    title: 'Dentist Appointment',
                    message: '4:00 PM - 5:00 PM',
                    config: const ToastConfig(
                      leftBorderColor: Color(0xFFE91E8C),
                      backgroundColor: Color(0xFFFFF0F5),
                    ),
                  )),

          // ── Custom Styling ────────────────────────────────────
          _section('Custom Styling'),
          _btn(
              'Dark custom toast',
              () => ElegantToast.show(
                    context,
                    type: ToastType.success,
                    title: 'Custom styled!',
                    message: 'Fully custom colors and icon.',
                    config: ToastConfig(
                      backgroundColor: const Color(0xFF1A1A2E),
                      borderColor: const Color(0xFF7F77DD),
                      iconBackgroundColor: const Color(0xFF7F77DD),
                      icon: const Icon(Icons.star_rounded,
                          color: Colors.white, size: 16),
                      titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                      messageStyle:
                          const TextStyle(color: Colors.white70, fontSize: 13),
                      showProgressBar: true,
                      progressBarColor: const Color(0xFF7F77DD),
                      animation: ToastAnimation.scale,
                      onDismiss: () => debugPrint('Custom toast dismissed'),
                    ),
                  )),

          // ── Context-based ─────────────────────────────────────
          _section('Context-based'),
          _btn(
              'Context success',
              () => ElegantToast.success(
                    context,
                    title: 'Context-based!',
                    message: 'Called with BuildContext.',
                  )),

          // ── Dismiss All ───────────────────────────────────────
          _section('Dismiss'),
          _btn('Dismiss top toast', () => ElegantToast.dismiss()),
          _btn('Dismiss all toasts', () => ElegantToast.clearAll()),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
        ),
      );

  Widget _btn(String label, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(label),
        ),
      );
}
