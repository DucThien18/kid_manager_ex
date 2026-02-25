import 'package:flutter/material.dart';
import 'package:kid_manager/models/app_user.dart';
import 'package:kid_manager/widgets/common/avatar.dart';


class MapBottomControls extends StatelessWidget {
  final List<AppUser> children;
  final VoidCallback? onMore;
  final VoidCallback? onMyLocation;
  final void Function(AppUser child)? onTapChild;
  const MapBottomControls({
    super.key,
    required this.children,
    this.onMore,
    this.onTapChild,
    this.onMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        /// ===== CHILD PREVIEW GROUP =====
        if (children.isNotEmpty && onMore != null)
          _ChildrenPreviewButton(
            children: children,
            onTapChild: onTapChild,
            onTap: onMore!,
          ),

        const Spacer(),

        /// ===== MY LOCATION BUTTON =====
        if (onMyLocation != null)
          _MyLocationButton(
            onTap: onMyLocation!,
          ),
      ],
    );
  }
}

/* ============================================================
   CHILDREN PREVIEW (168 x 60)
============================================================ */

class _ChildrenPreviewButton extends StatelessWidget {
  final List<AppUser> children;
  final VoidCallback onTap;
  final void Function(AppUser child)? onTapChild;

  const _ChildrenPreviewButton({
    required this.children,
    required this.onTap,
    this.onTapChild
  });

  @override
  Widget build(BuildContext context) {
    final visible = children.take(2).toList();
    final remaining = children.length - visible.length;

    return GestureDetector(
      onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 60,
            maxWidth: 220, // 👈 giới hạn max như Google Maps
          ),
      child: Container(

        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000), // giống Compose spotColor
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
            mainAxisSize: MainAxisSize.min,
          children: [
            /// ===== AVATARS =====
            Stack(
              clipBehavior: Clip.none,
              children: [
                for (final child in visible)
                  Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: onTapChild == null
                            ? null
                            : () => onTapChild!(child),
                    child: AppAvatar(
                      user: child,
                      size:44
                    ),
                  ),
                      ),


                /// +N
                if (remaining > 0)
                  Positioned(
                    left: visible.length * 22,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey.shade300,
                      child: Text(
                        '+$remaining',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 8),
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFF1A73E8), // viền xanh
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.more_horiz,
                size: 22,
                color: Color(0xFF1A73E8), // 3 chấm xanh
              ),
            ),



          ],
        ),
      ),
        ),
    );
  }
}

/* ============================================================
   MY LOCATION BUTTON (GOOGLE STYLE)
============================================================ */

class _MyLocationButton extends StatelessWidget {
  final VoidCallback onTap;

  const _MyLocationButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 8,
      shadowColor: const Color(0x40000000),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(14),
          child: Icon(
            Icons.my_location, // giống Google Maps
            size: 26,
            color: Color(0xFF1A73E8),
          ),
        ),
      ),
    );
  }
}
