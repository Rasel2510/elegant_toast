import 'package:flutter/material.dart';
import '../toast_config.dart';

class ToastTextColumn extends StatelessWidget {
  final String title;
  final String? message;
  final bool isExpanded;
  final ToastConfig config;
  final Color labelColor;
  final Color actionColor;
  final VoidCallback onToggleExpand;

  const ToastTextColumn({
    super.key,
    required this.title,
    this.message,
    required this.isExpanded,
    required this.config,
    required this.labelColor,
    required this.actionColor,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: config.titleStyle ??
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: labelColor,
                letterSpacing: 0.1,
                height: 1.4,
              ),
        ),
        if (message != null && message!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            message!,
            maxLines: config.maxLines,
            overflow: config.maxLines != null ? TextOverflow.ellipsis : null,
            style: config.messageStyle ??
                TextStyle(
                  fontSize: 12,
                  color: labelColor.withValues(alpha: 0.70),
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
          ),
        ],
        if (config.expandable &&
            config.expandedMessage != null &&
            isExpanded) ...[
          const SizedBox(height: 6),
          Text(
            config.expandedMessage!,
            style: config.messageStyle ??
                TextStyle(
                  fontSize: 12,
                  color: labelColor.withValues(alpha: 0.70),
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
          ),
        ],
        if (config.expandable && config.expandedMessage != null) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onToggleExpand,
            child: Text(
              isExpanded ? config.collapseLabel : config.expandLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: actionColor,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
