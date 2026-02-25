import 'package:flutter/material.dart';
import 'package:kid_manager/models/app_user.dart';

class AppAvatar extends StatelessWidget {
  final AppUser user;
  final double size;
  final bool grayscale;

  const AppAvatar({
    super.key,
    required this.user,
    this.size = 44,
    this.grayscale = false,
  });

  @override
  Widget build(BuildContext context) {
    final img = user.photoUrl != null && user.photoUrl!.isNotEmpty
        ? NetworkImage(user.photoUrl!)
        : const AssetImage('assets/images/avatar_default.png');

    return ColorFiltered(
      colorFilter: grayscale
          ? const ColorFilter.mode(
        Colors.grey,
        BlendMode.saturation,
      )
          : const ColorFilter.mode(
        Colors.transparent,
        BlendMode.multiply,
      ),
      child: ClipOval(
        child: Image(
          image: img as ImageProvider,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

