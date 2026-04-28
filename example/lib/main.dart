import 'package:flutter/material.dart';
import 'package:elegant_toast/elegant_toast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elegant Toast Example',
      navigatorKey: ElegantToast.navigatorKey, // Required for context-free calls
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const ToastDemoPage(),
    );
  }
}

class ToastDemoPage extends StatelessWidget {
  const ToastDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elegant Toast 1.0.1')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Basic Toasts (Context-free)'),
          _btn('Success', () => ElegantToast.showSuccess(
            title: 'Booking confirmed!',
            message: 'Your tour has been successfully booked.',
          )),
          _btn('Error', () => ElegantToast.showError(
            title: 'Something went wrong',
            message: 'Could not complete the request.',
          )),
          _btn('Warning', () => ElegantToast.showWarning(
            title: 'Session expiring soon',
            message: 'You will be logged out in 5 minutes.',
            position: ToastPosition.top,
          )),
          _btn('Info', () => ElegantToast.showInfo(
            title: 'Update available',
            message: 'A new version of the app is ready.',
            position: ToastPosition.topRight,
          )),
          _btn('Neutral', () => ElegantToast.showNeutral(
            title: 'Copied to clipboard',
            position: ToastPosition.bottomRight,
          )),

          _section('Progress Bar'),
          _btn('Success + Progress Bar', () => ElegantToast.showSuccess(
            title: 'File uploaded!',
            message: 'Your file has been saved.',
            config: const ToastConfig(
              showProgressBar: true,
              duration: Duration(seconds: 5),
            ),
          )),
          _btn('Error + Progress Bar', () => ElegantToast.showError(
            title: 'Upload failed',
            message: 'Check your connection.',
            config: const ToastConfig(
              showProgressBar: true,
              duration: Duration(seconds: 4),
            ),
          )),

          _section('Action Button'),
          _btn('With Undo Action', () => ElegantToast.showNeutral(
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
          _btn('With Retry Action', () => ElegantToast.showError(
            title: 'Upload failed',
            config: ToastConfig(
              showProgressBar: true,
              action: ToastAction(
                label: 'Retry',
                onPressed: () => debugPrint('Retry tapped!'),
              ),
            ),
          )),

          _section('Toast Queue'),
          _btn('Queue 3 Toasts', () {
            ElegantToast.showSuccess(title: 'First toast', useQueue: true);
            ElegantToast.showWarning(title: 'Second toast', useQueue: true);
            ElegantToast.showInfo(title: 'Third toast', useQueue: true);
          }),

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

          _section('Animations'),
          _btn('Slide & Fade (default)', () => ElegantToast.showSuccess(
            title: 'Slide & Fade',
            config: const ToastConfig(animation: ToastAnimation.slideAndFade),
          )),
          _btn('Scale', () => ElegantToast.showInfo(
            title: 'Scale animation',
            config: const ToastConfig(animation: ToastAnimation.scale),
          )),
          _btn('Bounce', () => ElegantToast.showSuccess(
            title: 'Bounce animation',
            config: const ToastConfig(animation: ToastAnimation.bounce),
          )),
          _btn('Fade only', () => ElegantToast.showNeutral(
            title: 'Fade animation',
            config: const ToastConfig(animation: ToastAnimation.fade),
          )),

          _section('Persistent Toast'),
          _btn('Persistent (manual close)', () => ElegantToast.showWarning(
            title: 'Action required',
            message: 'Please complete your profile.',
            config: const ToastConfig(persistent: true),
          )),

          _section('Swipe to Dismiss'),
          _btn('Swipe me left/right', () => ElegantToast.showInfo(
            title: 'Swipe to dismiss',
            message: 'Drag me left or right!',
            config: const ToastConfig(
              duration: Duration(seconds: 8),
              swipeToDismiss: true,
            ),
          )),

          _section('Custom Styling'),
          _btn('Dark custom toast', () => ElegantToast.show(
            context,
            type: ToastType.success,
            title: 'Custom styled!',
            message: 'Fully custom colors and icon.',
            config: const ToastConfig(
              backgroundColor: Color(0xFF1A1A2E),
              borderColor: Color(0xFF7F77DD),
              iconBackgroundColor: Color(0xFF7F77DD),
              icon: Icon(Icons.star_rounded, color: Colors.white, size: 16),
              titleStyle: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              messageStyle: TextStyle(color: Colors.white70, fontSize: 13),
              showProgressBar: true,
              progressBarColor: Color(0xFF7F77DD),
              animation: ToastAnimation.scale,
            ),
          )),

          _section('Context-based'),
          _btn('Context success', () => ElegantToast.success(
            context,
            title: 'Context-based!',
            message: 'Called with BuildContext.',
          )),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black54)),
      );

  Widget _btn(String label, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(label),
        ),
      );
}
