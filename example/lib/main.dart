import 'package:flutter/material.dart';
import 'package:elegant_toast/elegant_toast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elegant Toast Example',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const ToastDemoPage(),
    );
  }
}

class ToastDemoPage extends StatelessWidget {
  const ToastDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elegant Toast Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Default toasts
            ElevatedButton(
              onPressed: () => ElegantToast.success(
                context,
                title: 'Booking confirmed!',
                message: 'Your tour has been successfully booked.',
              ),
              child: const Text('Success Toast'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ElegantToast.error(
                context,
                title: 'Something went wrong',
                message: 'Could not complete the request. Try again.',
              ),
              child: const Text('Error Toast'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ElegantToast.warning(
                context,
                title: 'Session expiring soon',
                message: 'You will be logged out in 5 minutes.',
                position: ToastPosition.top,
              ),
              child: const Text('Warning Toast (top)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ElegantToast.info(
                context,
                title: 'New update available',
                message: 'A new version of the app is ready.',
                position: ToastPosition.topRight,
              ),
              child: const Text('Info Toast (top right)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ElegantToast.neutral(
                context,
                title: 'Copied to clipboard',
                position: ToastPosition.bottomRight,
              ),
              child: const Text('Neutral Toast (no message)'),
            ),
            const SizedBox(height: 24),

            /// Custom color toast
            ElevatedButton(
              onPressed: () => ElegantToast.show(
                context,
                title: 'Custom styled!',
                message: 'You can change anything you want.',
                type: ToastType.success,
                config: ToastConfig(
                  backgroundColor: const Color(0xFF1A1A2E),
                  borderColor: const Color(0xFF7F77DD),
                  iconBackgroundColor: const Color(0xFF7F77DD),
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  messageStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                  icon: const Icon(Icons.star, color: Colors.white, size: 16),
                ),
              ),
              child: const Text('Custom Toast'),
            ),
          ],
        ),
      ),
    );
  }
}
