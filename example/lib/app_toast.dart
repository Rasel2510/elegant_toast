import 'dart:ui';

import 'package:elegant_toast/elegant_toast.dart';

class AppToast {
  AppToast._();

  // ─────────────────────────────────────────
  // AUTH
  // ─────────────────────────────────────────

  static void loginSuccess() => ElegantToast.showSuccess(
        title: 'Welcome back!',
        message: 'You have successfully logged in.',
        config: const ToastConfig(showProgressBar: true),
      );

  static void loginFailed({String? message}) => ElegantToast.showError(
        title: 'Login failed',
        message: message ?? 'Invalid email or password.',
        config: const ToastConfig(showProgressBar: true),
      );

  static void logoutSuccess() => ElegantToast.showNeutral(
        title: 'Logged out',
        message: 'You have been logged out successfully.',
      );

  static void registerSuccess() => ElegantToast.showSuccess(
        title: 'Account created!',
        message: 'Welcome! Your account is ready.',
        config: const ToastConfig(showProgressBar: true),
      );

  static void registerFailed({String? message}) => ElegantToast.showError(
        title: 'Registration failed',
        message: message ?? 'Could not create account. Try again.',
        config: const ToastConfig(showProgressBar: true),
      );

  static void passwordChanged() => ElegantToast.showSuccess(
        title: 'Password updated',
        message: 'Your password has been changed successfully.',
      );

  static void sessionExpired() => ElegantToast.showWarning(
        title: 'Session expired',
        message: 'Please log in again to continue.',
        position: ToastPosition.top,
        config: const ToastConfig(persistent: true),
      );

  // ─────────────────────────────────────────
  // BOOKING
  // ─────────────────────────────────────────

  static void bookingConfirmed() => ElegantToast.showSuccess(
        title: 'Booking confirmed!',
        message: 'Your booking has been successfully placed.',
        config: const ToastConfig(showProgressBar: true),
      );

  static void bookingFailed({String? message}) => ElegantToast.showError(
        title: 'Booking failed',
        message: message ?? 'Could not complete your booking. Try again.',
        config: const ToastConfig(showProgressBar: true),
      );

  static void bookingCancelled() => ElegantToast.showNeutral(
        title: 'Booking cancelled',
        message: 'Your booking has been cancelled.',
        config: const ToastConfig(showProgressBar: true),
      );

  static void bookingUpdated() => ElegantToast.showSuccess(
        title: 'Booking updated',
        message: 'Your booking details have been updated.',
      );

  // ─────────────────────────────────────────
  // PAYMENT
  // ─────────────────────────────────────────

  static void paymentSuccess() => ElegantToast.showSuccess(
        title: 'Payment successful!',
        message: 'Your payment has been processed.',
        config: const ToastConfig(showProgressBar: true),
      );

  static void paymentFailed({String? message}) => ElegantToast.showError(
        title: 'Payment failed',
        message: message ?? 'Transaction could not be completed.',
        config: const ToastConfig(showProgressBar: true),
      );

  static void paymentPending() => ElegantToast.showWarning(
        title: 'Payment pending',
        message: 'Your payment is being processed.',
        config: const ToastConfig(showProgressBar: true),
      );

  // ─────────────────────────────────────────
  // NETWORK
  // ─────────────────────────────────────────

  static void noInternet() => ElegantToast.showError(
        title: 'No internet connection',
        message: 'Please check your network and try again.',
        position: ToastPosition.top,
        config: const ToastConfig(persistent: true),
      );

  static void internetRestored() => ElegantToast.showSuccess(
        title: 'Back online',
        message: 'Your internet connection has been restored.',
        position: ToastPosition.top,
      );

  static void serverError({String? message}) => ElegantToast.showError(
        title: 'Server error',
        message: message ?? 'Something went wrong on our end. Try again.',
        config: const ToastConfig(showProgressBar: true),
      );

  static void requestTimeout() => ElegantToast.showWarning(
        title: 'Request timed out',
        message: 'The server took too long to respond.',
        config: const ToastConfig(showProgressBar: true),
      );

  // ─────────────────────────────────────────
  // PROFILE
  // ─────────────────────────────────────────

  static void profileUpdated() => ElegantToast.showSuccess(
        title: 'Profile updated',
        message: 'Your profile has been saved successfully.',
      );

  static void profileUpdateFailed({String? message}) => ElegantToast.showError(
        title: 'Update failed',
        message: message ?? 'Could not update your profile.',
      );

  static void profilePictureUpdated() => ElegantToast.showSuccess(
        title: 'Photo updated',
        message: 'Your profile picture has been changed.',
      );

  // ─────────────────────────────────────────
  // REVIEW
  // ─────────────────────────────────────────

  static void reviewSubmitted() => ElegantToast.showSuccess(
        title: 'Review submitted!',
        message: 'Thank you for your feedback.',
        config: const ToastConfig(showProgressBar: true),
      );

  static void reviewFailed({String? message}) => ElegantToast.showError(
        title: 'Review failed',
        message: message ?? 'Could not submit your review.',
      );

  // ─────────────────────────────────────────
  // UPLOAD / DOWNLOAD
  // ─────────────────────────────────────────

  static void uploadStarted() => ElegantToast.showLoading(
        title: 'Uploading...',
        message: 'Please wait while we upload your file.',
      );

  static void uploadSuccess() => ElegantToast.completeLoading(
        type: ToastType.success,
        title: 'Upload complete!',
        message: 'Your file has been uploaded successfully.',
      );

  static void uploadFailed({String? message}) => ElegantToast.completeLoading(
        type: ToastType.error,
        title: 'Upload failed',
        message: message ?? 'Could not upload your file.',
      );

  static void downloadSuccess() => ElegantToast.showSuccess(
        title: 'Download complete',
        message: 'Your file has been saved.',
      );

  // ─────────────────────────────────────────
  // CLIPBOARD
  // ─────────────────────────────────────────

  static void copied({String? label}) => ElegantToast.showNeutral(
        title: 'Copied!',
        message: '${label ?? 'Text'} copied to clipboard.',
        position: ToastPosition.bottomRight,
      );

  // ─────────────────────────────────────────
  // GENERAL
  // ─────────────────────────────────────────

  static void saved() => ElegantToast.showSuccess(
        title: 'Saved',
        message: 'Your changes have been saved.',
      );

  static void deleted({VoidCallback? onUndo}) => ElegantToast.showNeutral(
        title: 'Item deleted',
        message: 'The item has been removed.',
        config: ToastConfig(
          showProgressBar: true,
          duration: const Duration(seconds: 5),
          action: onUndo != null
              ? ToastAction(label: 'Undo', onPressed: onUndo)
              : null,
        ),
      );

  static void comingSoon() => ElegantToast.showInfo(
        title: 'Coming soon',
        message: 'This feature is not available yet.',
      );

  static void permissionDenied() => ElegantToast.showWarning(
        title: 'Permission denied',
        message: 'Please grant the required permission in settings.',
      );

  static void validationError({String? message}) => ElegantToast.showWarning(
        title: 'Invalid input',
        message: message ?? 'Please fill in all required fields correctly.',
        position: ToastPosition.top,
        config: const ToastConfig(showProgressBar: true),
      );

  static void unknownError({String? message}) => ElegantToast.showError(
        title: 'Unexpected error',
        message: message ?? 'Something went wrong. Please try again.',
        config: const ToastConfig(showProgressBar: true),
      );

  /// Dismiss current toast
  static void dismiss() => ElegantToast.dismiss();
}
