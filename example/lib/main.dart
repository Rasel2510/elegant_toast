import 'package:elegant_toast/elegant_toast.dart';
import 'package:flutter/material.dart';

import 'app_toast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppToast Test',
      navigatorKey: ElegantToast.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const ToastTestPage(),
    );
  }
}

class ToastTestPage extends StatelessWidget {
  const ToastTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AppToast Test'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Auth'),
              Tab(text: 'Booking'),
              Tab(text: 'Payment'),
              Tab(text: 'Network'),
              Tab(text: 'Profile & Review'),
              Tab(text: 'General'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _AuthTab(),
            _BookingTab(),
            _PaymentTab(),
            _NetworkTab(),
            _ProfileReviewTab(),
            _GeneralTab(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// AUTH TAB
// ─────────────────────────────────────────
class _AuthTab extends StatelessWidget {
  const _AuthTab();

  @override
  Widget build(BuildContext context) {
    return _ToastList(items: [
      const _ToastItem(
        label: 'Login Success',
        color: Colors.green,
        onTap: AppToast.loginSuccess,
      ),
      _ToastItem(
        label: 'Login Failed',
        color: Colors.red,
        onTap: () =>
            AppToast.loginFailed(message: 'Invalid email or password.'),
      ),
      _ToastItem(
        label: 'Login Failed (custom)',
        color: Colors.red,
        onTap: () =>
            AppToast.loginFailed(message: 'Account has been suspended.'),
      ),
      const _ToastItem(
        label: 'Logout Success',
        color: Colors.grey,
        onTap: AppToast.logoutSuccess,
      ),
      const _ToastItem(
        label: 'Register Success',
        color: Colors.green,
        onTap: AppToast.registerSuccess,
      ),
      _ToastItem(
        label: 'Register Failed',
        color: Colors.red,
        onTap: () => AppToast.registerFailed(message: 'Email already in use.'),
      ),
      const _ToastItem(
        label: 'Password Changed',
        color: Colors.green,
        onTap: AppToast.passwordChanged,
      ),
      const _ToastItem(
        label: 'Session Expired',
        color: Colors.orange,
        onTap: AppToast.sessionExpired,
      ),
      const _ToastItem(
        label: 'Dismiss',
        color: Colors.blueGrey,
        onTap: AppToast.dismiss,
      ),
    ]);
  }
}

// ─────────────────────────────────────────
// BOOKING TAB
// ─────────────────────────────────────────
class _BookingTab extends StatelessWidget {
  const _BookingTab();

  @override
  Widget build(BuildContext context) {
    return _ToastList(items: [
      const _ToastItem(
        label: 'Booking Confirmed',
        color: Colors.green,
        onTap: AppToast.bookingConfirmed,
      ),
      _ToastItem(
        label: 'Booking Failed',
        color: Colors.red,
        onTap: () => AppToast.bookingFailed(message: 'No slots available.'),
      ),
      const _ToastItem(
        label: 'Booking Cancelled',
        color: Colors.grey,
        onTap: AppToast.bookingCancelled,
      ),
      const _ToastItem(
        label: 'Booking Updated',
        color: Colors.green,
        onTap: AppToast.bookingUpdated,
      ),
    ]);
  }
}

// ─────────────────────────────────────────
// PAYMENT TAB
// ─────────────────────────────────────────
class _PaymentTab extends StatelessWidget {
  const _PaymentTab();

  @override
  Widget build(BuildContext context) {
    return _ToastList(items: [
      const _ToastItem(
        label: 'Payment Success',
        color: Colors.green,
        onTap: AppToast.paymentSuccess,
      ),
      _ToastItem(
        label: 'Payment Failed',
        color: Colors.red,
        onTap: () => AppToast.paymentFailed(message: 'Card was declined.'),
      ),
      const _ToastItem(
        label: 'Payment Pending',
        color: Colors.orange,
        onTap: AppToast.paymentPending,
      ),
    ]);
  }
}

// ─────────────────────────────────────────
// NETWORK TAB
// ─────────────────────────────────────────
class _NetworkTab extends StatelessWidget {
  const _NetworkTab();

  @override
  Widget build(BuildContext context) {
    return _ToastList(items: [
      const _ToastItem(
        label: 'No Internet',
        color: Colors.red,
        onTap: AppToast.noInternet,
      ),
      const _ToastItem(
        label: 'Internet Restored',
        color: Colors.green,
        onTap: AppToast.internetRestored,
      ),
      _ToastItem(
        label: 'Server Error',
        color: Colors.red,
        onTap: () =>
            AppToast.serverError(message: '500 Internal Server Error.'),
      ),
      const _ToastItem(
        label: 'Request Timeout',
        color: Colors.orange,
        onTap: AppToast.requestTimeout,
      ),
      const _ToastItem(
        label: 'Dismiss Persistent',
        color: Colors.blueGrey,
        onTap: AppToast.dismiss,
      ),
    ]);
  }
}

// ─────────────────────────────────────────
// PROFILE & REVIEW TAB
// ─────────────────────────────────────────
class _ProfileReviewTab extends StatelessWidget {
  const _ProfileReviewTab();

  @override
  Widget build(BuildContext context) {
    return _ToastList(items: [
      const _ToastItem(
        label: 'Profile Updated',
        color: Colors.green,
        onTap: AppToast.profileUpdated,
      ),
      _ToastItem(
        label: 'Profile Update Failed',
        color: Colors.red,
        onTap: () =>
            AppToast.profileUpdateFailed(message: 'Username already taken.'),
      ),
      const _ToastItem(
        label: 'Profile Picture Updated',
        color: Colors.green,
        onTap: AppToast.profilePictureUpdated,
      ),
      const _ToastItem(
        label: 'Review Submitted',
        color: Colors.green,
        onTap: AppToast.reviewSubmitted,
      ),
      _ToastItem(
        label: 'Review Failed',
        color: Colors.red,
        onTap: () =>
            AppToast.reviewFailed(message: 'You have already reviewed this.'),
      ),
    ]);
  }
}

// ─────────────────────────────────────────
// GENERAL TAB
// ─────────────────────────────────────────
class _GeneralTab extends StatelessWidget {
  const _GeneralTab();

  @override
  Widget build(BuildContext context) {
    return _ToastList(items: [
      _ToastItem(
        label: 'Upload → Success',
        color: Colors.blue,
        onTap: () async {
          AppToast.uploadStarted();
          await Future.delayed(const Duration(seconds: 2));
          AppToast.uploadSuccess();
        },
      ),
      _ToastItem(
        label: 'Upload → Failed',
        color: Colors.red,
        onTap: () async {
          AppToast.uploadStarted();
          await Future.delayed(const Duration(seconds: 2));
          AppToast.uploadFailed(message: 'File size exceeds 10MB.');
        },
      ),
      const _ToastItem(
        label: 'Download Success',
        color: Colors.green,
        onTap: AppToast.downloadSuccess,
      ),
      _ToastItem(
        label: 'Copied to Clipboard',
        color: Colors.blueGrey,
        onTap: () => AppToast.copied(label: 'Phone number'),
      ),
      const _ToastItem(
        label: 'Saved',
        color: Colors.green,
        onTap: AppToast.saved,
      ),
      _ToastItem(
        label: 'Deleted (with Undo)',
        color: Colors.grey,
        onTap: () => AppToast.deleted(
          onUndo: () => debugPrint('Undo tapped — item restored!'),
        ),
      ),
      _ToastItem(
        label: 'Deleted (no Undo)',
        color: Colors.grey,
        onTap: () => AppToast.deleted(),
      ),
      const _ToastItem(
        label: 'Coming Soon',
        color: Colors.blue,
        onTap: AppToast.comingSoon,
      ),
      const _ToastItem(
        label: 'Permission Denied',
        color: Colors.orange,
        onTap: AppToast.permissionDenied,
      ),
      _ToastItem(
        label: 'Validation Error',
        color: Colors.orange,
        onTap: () => AppToast.validationError(message: 'Email is required.'),
      ),
      _ToastItem(
        label: 'Unknown Error',
        color: Colors.red,
        onTap: () => AppToast.unknownError(message: 'Please try again later.'),
      ),
      _ToastItem(
        label: 'Queue 3 Toasts',
        color: Colors.purple,
        onTap: () {
          ElegantToast.showSuccess(title: 'Step 1 complete', useQueue: true);
          ElegantToast.showInfo(title: 'Step 2 running...', useQueue: true);
          ElegantToast.showSuccess(title: 'All done!', useQueue: true);
        },
      ),
    ]);
  }
}

// ─────────────────────────────────────────
// REUSABLE WIDGETS
// ─────────────────────────────────────────
class _ToastList extends StatelessWidget {
  final List<_ToastItem> items;

  const _ToastList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => items[i],
    );
  }
}

class _ToastItem extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ToastItem({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
