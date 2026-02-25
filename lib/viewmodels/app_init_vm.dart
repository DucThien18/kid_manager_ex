import 'package:flutter/material.dart';
import 'package:kid_manager/core/storage_keys.dart';
import 'package:kid_manager/services/permission_service.dart';
import 'package:kid_manager/services/storage_service.dart';

class AppInitVM extends ChangeNotifier with WidgetsBindingObserver {
  final StorageService storage;
  final PermissionService permissionService;

  bool _ready = false;
  bool get ready => _ready;

  String? _uid;
  String? get uid => _uid;

  AppInitVM(this.storage, this.permissionService) {
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  Future<void> init() async {
    _uid = storage.getString(StorageKeys.uid);

    if (_uid == null) {
      _setReady(false);
      return;
    }

    final hasUsage = await permissionService.hasUsagePermission();
    _setReady(hasUsage);
    debugPrint("hehehehe: ${hasUsage}");

  }

  /// 👉 Mở settings, KHÔNG check ở đây
  Future<void> openUsageSettings() async {
    await permissionService.openUsageAccessSettings();
  }

  /// 👉 Khi app quay lại foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      init(); // 🔥 check lại permission tại đây
    }
  }

  void _setReady(bool value) {
    if (_ready == value) return;
    _ready = value;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
