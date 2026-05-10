import 'package:flutter/material.dart';
import '../toast_type.dart';
import '../toast_config.dart';
import 'toast_icon.dart';
import 'toast_close_button.dart';
import 'toast_action_button.dart';
import 'toast_text_column.dart';

class ToastContentRow extends StatelessWidget {
  final String title;
  final String? message;
  final ToastType type;
  final ToastConfig config;
  final Color iconColor;
  final Color labelColor;
  final Color actionColor;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onDismiss;

  const ToastContentRow({
    super.key,
    required this.title,
    this.message,
    required this.type,
    required this.config,
    required this.iconColor,
    required this.labelColor,
    required this.actionColor,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: config.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (config.showIcon) ...[
            config.icon ??
                ToastIcon(
                  type: type,
                  color: iconColor,
                  size: config.iconSize,
                ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ToastTextColumn(
              title: title,
              message: message,
              isExpanded: isExpanded,
              config: config,
              labelColor: labelColor,
              actionColor: actionColor,
              onToggleExpand: onToggleExpand,
            ),
          ),
          if (config.action != null) ...[
            const SizedBox(width: 8),
            ToastActionButton(
              label: config.action!.label,
              labelStyle: config.action!.labelStyle,
              color: actionColor,
              onTap: () {
                config.action!.onPressed();
                onDismiss();
              },
            ),
          ],
          if (config.showCloseButton) ...[
            const SizedBox(width: 4),
            ToastCloseButton(
              color: labelColor,
              onTap: onDismiss,
            ),
          ],
        ],
      ),
    );
  }
}
