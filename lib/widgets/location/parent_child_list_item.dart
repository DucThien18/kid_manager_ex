import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_manager/models/app_user.dart';
import 'package:kid_manager/models/location/location_data.dart';
import 'package:kid_manager/models/user/app_user_extensions.dart';
import 'package:kid_manager/views/location/child_detail_map_screen.dart';
import 'package:kid_manager/widgets/common/avatar.dart';

class ParentChildListItem extends StatelessWidget {
  final AppUser child;
  final LocationData? location;

  const ParentChildListItem({
    super.key,
    required this.child,
    this.location,
  });

  bool get isOnline {
    if (location == null) return false;

    final last = DateTime.fromMillisecondsSinceEpoch(location!.timestamp);
    return DateTime.now().difference(last).inMinutes <= 5;
  }

  @override
  Widget build(BuildContext context) {
    final name = child.displayLabel;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChildDetailMapScreen(
              childId: child.uid,
            ),
          ),
        );
      },

      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pop(context, child);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000), // bóng rất nhẹ
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                /// ===== AVATAR =====
                Stack(
                  children: [
                    AppAvatar(user: child, size: 61),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 12),

                /// ===== NAME + STATUS =====
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color:Color(0xFF222B45),

                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOnline ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.w500,

                        ),
                      ),
                    ],
                  ),
                ),

                /// ===== ACTIONS =====
                _ActionPill(
                  onChat: () {
                    // TODO: mở chat
                  },
                  onLocate: () {
                    Navigator.pop(context, child);
                  },
                ),

              ],
            ),
          ),
        ),
      )
      ,
    );
  }
}

/* ============================================================
   ACTION BUTTON
============================================================ */

class _ActionPill extends StatelessWidget {
  final VoidCallback onChat;
  final VoidCallback onLocate;

  const _ActionPill({
    required this.onChat,
    required this.onLocate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// CHAT
          InkWell(
            onTap: onChat,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SvgPicture.asset(
                "assets/icons/message.svg",
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF2563EB),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          /// divider
          Container(
            width: 1,
            height: 20,
            color: Colors.grey.shade300,
          ),

          /// GPS
          InkWell(
            onTap: onLocate,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SvgPicture.asset(
                "assets/icons/gps.svg",
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF2563EB),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

