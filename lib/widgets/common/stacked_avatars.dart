import 'package:flutter/material.dart';
import 'package:kid_manager/models/app_user.dart';
import 'package:kid_manager/widgets/common/avatar.dart';

class StackedAvatars extends StatelessWidget {
  final List<AppUser> users;
  final double size;
  final double overlap;

  const StackedAvatars({
    super.key,
    required this.users,
    this.size = 48,
    this.overlap = 12,
  });

  @override
  Widget build(BuildContext context) {
    final displayUsers = users.take(3).toList();

    return SizedBox(
      width: size + overlap * (displayUsers.length - 1),
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < displayUsers.length; i++)
            Positioned(
              left: i * overlap,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black26,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: AppAvatar(
                    user: displayUsers[i],
                    size: size,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
