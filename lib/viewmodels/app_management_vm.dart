import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:kid_manager/models/app_item_model.dart';
import 'package:kid_manager/repositories/app_management_repository.dart';

class AppManagementVM extends ChangeNotifier {
  final AppManagementRepository _repo;

  AppManagementVM(this._repo);

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  List<AppItemModel> _apps = [];
  List<AppItemModel> get apps => _apps;

  /// Load + seed + sync usage
  Future<void> loadApps(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      // 1️⃣ Load installed apps
      _apps = await _repo.loadAppsFromFirestore(userId);
      notifyListeners();

      // 3️⃣ Sync usage
      await _repo.syncTodayUsage(userId);
    } catch (e) {
      _error = 'Không thể đồng bộ ứng dụng';
    } finally {
      _setLoading(false);
    }
  }

  /// Chỉ sync usage (khi app đã seed)
  Future<void> syncUsageOnly(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      await _repo.syncTodayUsage(userId);
    } catch (e) {
      _error = 'Không thể cập nhật usage';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  AppItemModel _mapToItem(AppInfo app) {
    return AppItemModel(
      packageName: app.packageName ?? '',
      name: app.name,
      iconBase64: app.icon == null ? null : base64Encode(app.icon!),
      usageTime: null,
      lastSeen: null,
    );
  }
}
