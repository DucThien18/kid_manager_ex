import 'dart:convert';
import 'package:flutter/material.dart';

class AppItem extends StatelessWidget {
  final String appName;
  final String usageTimeText;

  /// Icon app bên trái (svg asset path)
  final String? iconBase64;

  /// Icon edit bên phải (svg asset path)
  final Widget editIconAsset;

  /// Actions
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  /// Optional styling
  final double width;
  final double height;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const AppItem({
    super.key,
    required this.appName,
    required this.usageTimeText,
    required this.editIconAsset,
    this.iconBase64,
    this.onTap,
    this.onEdit,
    this.width = 366,
    this.height = 70,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultTitleStyle = theme.textTheme.titleMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF4A4A4A),
      fontFamily: "Poppins",
      height: 1.25,
    );

    final defaultSubtitleStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF6B6778),
      fontFamily: "Poppins",
      height: 1.33,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 4),
                color: Color(0x0A000000),
              ),
            ],
          ),
          child: Row(
            children: [
              // LEFT: app icon
              Container(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: iconBase64 != null
                      ? Image.memory(
                          base64Decode(iconBase64!),
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        )
                      : const Icon(Icons.apps, size: 24, color: Colors.grey),
                ),
              ),

              const SizedBox(width: 12),

              // CENTER: name + usage time
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle ?? defaultTitleStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      usageTimeText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: subtitleStyle ?? defaultSubtitleStyle,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // RIGHT: edit icon
              InkResponse(
                onTap: onEdit,
                radius: 22,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: editIconAsset,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
