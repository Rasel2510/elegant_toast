import 'package:flutter/material.dart';
import '../toast_type.dart';
import '../toast_config.dart';
import 'toast_content_row.dart';
import 'toast_progress_bar.dart';

class ToastBody extends StatelessWidget {
  final String title;
  final String? message;
  final ToastType type;
  final ToastConfig config;
  final Color bgColor;
  final Color iconColor;
  final Color labelColor;
  final Color actionColor;
  final Color progressColor;
  final bool isExpanded;
  final AnimationController progressController;
  final VoidCallback onToggleExpand;
  final VoidCallback onDismiss;

  const ToastBody({
    super.key,
    required this.title,
    this.message,
    required this.type,
    required this.config,
    required this.bgColor,
    required this.iconColor,
    required this.labelColor,
    required this.actionColor,
    required this.progressColor,
    required this.isExpanded,
    required this.progressController,
    required this.onToggleExpand,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 288, maxWidth: 560),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: config.borderRadius ?? BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: config.borderRadius ?? BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToastContentRow(
              title: title,
              message: message,
              type: type,
              config: config,
              iconColor: iconColor,
              labelColor: labelColor,
              actionColor: actionColor,
              isExpanded: isExpanded,
              onToggleExpand: onToggleExpand,
              onDismiss: onDismiss,
            ),
            if (config.showProgressBar && !config.persistent)
              ToastProgressBar(
                controller: progressController,
                color: progressColor,
              ),
          ],
        ),
      ),
    );
  }
}
