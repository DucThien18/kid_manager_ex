import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_manager/helpers/location_helper.dart';
import 'package:kid_manager/models/app_user.dart';
import 'package:kid_manager/models/location/location_data.dart';
import 'package:kid_manager/models/user/app_user_extensions.dart';
import 'package:kid_manager/widgets/common/avatar.dart';

class ChildMarker extends StatelessWidget {
  final AppUser child;
  final LocationData location;
  final VoidCallback onTap;

  const ChildMarker({
    super.key,
    required this.child,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final online = LocationHelper.isOnline(location);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: online ? Colors.green : Colors.grey,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black26,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Opacity(
                opacity: online ? 1.0 : 0.45,
                child: AppAvatar(
                  user: child,
                  size: 48,
                  grayscale: !online,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(blurRadius: 4, color: Colors.black26),
              ],
            ),
            child: Text(
              child.displayLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
