import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ===== SET =====
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  Future<bool> setInt(String key, int value) =>
      _prefs.setInt(key, value);

  Future<bool> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  // ===== GET =====
  String? getString(String key) => _prefs.getString(key);

  int? getInt(String key) => _prefs.getInt(key);

  bool? getBool(String key) => _prefs.getBool(key);

  double? getDouble(String key) => _prefs.getDouble(key);

  List<String>? getStringList(String key) =>
      _prefs.getStringList(key);

  // ===== UTILS =====
  bool contains(String key) => _prefs.containsKey(key);

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clear() => _prefs.clear();
}



// cách dùng

// final storage = context.read<StorageService>();
// await storage.setString('uid', user.uid);