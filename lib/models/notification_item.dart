import 'package:flutter/material.dart';
import 'package:kid_manager/widgets/app/app_icon.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final bool isHighlighted;
  final VoidCallback onTap;
  final NotificationType type;

  const NotificationItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.type,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: isHighlighted ? const Color(0xFFEBEBEB) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ===== ICON =====
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFF3A7DFF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AppIcon(
                    path: getNotificationIcon(type),
                    type: AppIconType.svg,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ===== TEXT CONTENT =====
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF222B45),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.19,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.17,
                              letterSpacing: 0.75,
                            ),
                          ),
                        ),
                        Text(
                          trailing,
                          style: const TextStyle(
                            color: Color(0xFF202020),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.50,
                            letterSpacing: -0.14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum NotificationType { schedule, birthday, warning, study }

String getNotificationIcon(NotificationType type) {
  switch (type) {
    case NotificationType.schedule:
      return 'assets/icons/calendar.svg';
    case NotificationType.birthday:
      return 'assets/icons/cake.svg';
    case NotificationType.warning:
      return 'assets/icons/mobile.svg';
    case NotificationType.study:
      return 'assets/icons/calendar.svg';
  }
}
