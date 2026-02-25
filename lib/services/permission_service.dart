import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usage_stats/usage_stats.dart';

class PermissionService {
  /// Microphone
  Future<bool> requestMicrophone() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Photos / Gallery:
  /// - Android 13+ dùng Permission.photos
  /// - Android <13 dùng Permission.storage
  /// - iOS dùng Permission.photos
  Future<bool> requestPhotosOrStorage() async {
    if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted || status.isLimited;
    }

    if (Platform.isAndroid) {
      final sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;

      if (sdkInt >= 33) {
        final status = await Permission.photos.request();
        return status.isGranted;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }

    return false;
  }

  /// Internet: không xin runtime. Chỉ khai báo manifest => luôn true.
  bool hasInternetByManifest() => true;

  /// Usage Access (Giám sát thời gian hoạt động app) - Android only
  /// Permission_handler không kiểm tra được "Usage Access" chuẩn 100%,
  /// nên thường dùng flow: mở Settings để user bật.
  Future<void> openUsageAccessSettings() async {
    if (!Platform.isAndroid) return;

    const intent = AndroidIntent(
      action: 'android.settings.USAGE_ACCESS_SETTINGS',
    );
    await intent.launch();
  }

  Future<bool> hasUsagePermission() async {
    if (!Platform.isAndroid) return false;

    try {
      final granted = await UsageStats.checkUsagePermission();
      if (granted == true) return true;

      // 👇 fallback test real usage
      final now = DateTime.now();
      final begin = now.subtract(const Duration(minutes: 5));

      final stats = await UsageStats.queryUsageStats(
        begin, // ✅ DateTime
        now, // ✅ DateTime
      );

      return stats.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Optional: kiểm tra Accessibility (nếu app bạn dùng accessibility để theo dõi)
  Future<void> openAccessibilitySettings() async {
    if (!Platform.isAndroid) return;

    const intent = AndroidIntent(
      action: 'android.settings.ACCESSIBILITY_SETTINGS',
    );
    await intent.launch();
  }

  /// Xin 1 lượt các quyền runtime (micro + photos/storage)
  Future<Map<String, bool>> requestCommonPermissions() async {
    final mic = await requestMicrophone();
    final media = await requestPhotosOrStorage();
    return {'microphone': mic, 'photos_or_storage': media};
  }
}
