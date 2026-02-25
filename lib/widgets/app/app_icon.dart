import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppIconType { svg, png }

class AppIcon extends StatelessWidget {
  final String path;
  final AppIconType type;
  final double size;
  final Color? color;

  const AppIcon({
    super.key,
    required this.path,
    required this.type,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppIconType.svg:
        return SvgPicture.asset(
          path,
          width: size,
          height: size,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        );

      case AppIconType.png:
        return Image.asset(
          path,
          width: size,
          height: size,
          fit: BoxFit.contain,
        );
    }
  }
}
