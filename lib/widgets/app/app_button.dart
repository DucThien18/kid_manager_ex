import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  final bool loading;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  final bool fullWidth;
  final bool outlined;

  final double? width;
  final double? height;

  // NEW: typography
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;

  final double? letterSpacing;
  final double? lineHeight;

  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.fullWidth = true,
    this.outlined = false,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.letterSpacing,
    this.lineHeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final fgColor = foregroundColor ?? theme.colorScheme.onPrimary;

    final textStyle = theme.textTheme.labelLarge?.copyWith(
      color: outlined ? bgColor : fgColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily ?? "Poppins",
      letterSpacing: letterSpacing,
      height: lineHeight,
    );

    final style = ElevatedButton.styleFrom(
      backgroundColor: outlined ? Colors.transparent : bgColor,
      foregroundColor: fgColor,

      // 🔥 TẮT HIỆU ỨNG
      splashFactory: NoSplash.splashFactory,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,

      disabledBackgroundColor: bgColor.withOpacity(0.5),
      disabledForegroundColor: fgColor.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: outlined ? BorderSide(color: bgColor) : BorderSide.none,
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      elevation: 0,
      textStyle: textStyle,
    );

    final child = loading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: outlined ? bgColor : fgColor,
            ),
          )
        : IconTheme(
            data: IconThemeData(color: outlined ? bgColor : fgColor, size: 18),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      outlined ? bgColor : fgColor,
                      BlendMode.srcIn,
                    ),
                    child: icon!,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(text),
              ],
            ),
          );

    Widget button = ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: style,
      child: child,
    );

    if (width != null || height != null) {
      button = SizedBox(
        width: width ?? (fullWidth ? double.infinity : null),
        height: height,
        child: button,
      );
    } else if (fullWidth) {
      button = const SizedBox(width: double.infinity, child: SizedBox());
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
