import 'dart:convert';

import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppInstalledService {
  Future<List<AppInfo>> getUserInstalledApps({bool withIcon = true}) async {
    final apps = await InstalledApps.getInstalledApps(
      excludeSystemApps: false,
      excludeNonLaunchableApps: true,
      withIcon: withIcon,
    );
    // Sort theo tên
    apps.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return apps;
  }

  

  Map<String, dynamic> toBlockedAppJson(AppInfo a) {
    final iconBytes = a.icon;

    return {
      "allowed": false,
      "iconBase64": iconBytes == null ? "" : base64Encode(iconBytes),
      "name": a.name,
      "packageName": a.packageName,
      "usageTime": "0h 0m",
      "lastSeen": null,
    };
  }

  
}
