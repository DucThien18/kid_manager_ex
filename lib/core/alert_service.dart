import 'package:flutter/material.dart';

class AlertService {
  AlertService._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get _ctx => navigatorKey.currentContext;

  /// Snackbar nhanh (info / error)
  static void showSnack(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    final ctx = _ctx;
    if (ctx == null) return;

    final messenger = ScaffoldMessenger.of(ctx);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError
            ? Theme.of(ctx).colorScheme.error
            : Theme.of(ctx).colorScheme.inverseSurface,
      ),
    );
  }

  /// Dialog xác nhận (OK/Cancel)
  static Future<bool> confirm({
    required String title,
    required String message,
    String okText = 'OK',
    String cancelText = 'Huỷ',
  }) async {
    final ctx = _ctx;
    if (ctx == null) return false;

    final res = await showDialog<bool>(
      context: ctx,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(okText),
          ),
        ],
      ),
    );

    return res ?? false;
  }

  /// Dialog báo lỗi (1 nút)
  static Future<void> error({
    String title = 'Có lỗi xảy ra',
    required String message,
    String okText = 'Đóng',
  }) async {
    final ctx = _ctx;
    if (ctx == null) return;

    await showDialog<void>(
      context: ctx,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(okText),
          ),
        ],
      ),
    );
  }
}
