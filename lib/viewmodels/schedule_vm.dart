import 'package:flutter/material.dart';
import 'package:kid_manager/views/parent/schedule/schedule_screen.dart';
import '../models/schedule.dart';
import '../repositories/schedule_repository.dart';
import 'auth_vm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleRepository _repo;
  final AuthVM _authVM;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ScheduleViewModel(this._repo, this._authVM);

  int _loadToken = 0;

  // ======================
  // STATE
  // ======================

  /// tháng đang focus (để load calendar)
  DateTime focusedMonth = DateTime.now();

  /// ngày đang chọn
  DateTime selectedDate = DateTime.now();

  /// child đang chọn
  String? selectedChildId;

  bool isLoading = false;
  String? error;

  /// Map dùng cho DOT calendar
  /// key = yyyy-mm-dd (normalized)
  Map<DateTime, List<Schedule>> monthSchedules = {};

  /// list hiển thị bên dưới
  List<Schedule> schedules = [];

  String get parentUid {
    final uid = _authVM.user?.uid;
    if (uid == null) {
      throw Exception('User chưa đăng nhập');
    }
    return uid;
  }

  // ======================
  // PUBLIC API (UI gọi)
  // ======================

  /// chọn bé
  Future<void> setChild(String id) async {
  selectedChildId = id;

  final now = DateTime.now();
  selectedDate = _normalize(now);
  focusedMonth = DateTime(now.year, now.month, 1);

  await loadMonth();
}

  /// chọn ngày
  void setDate(DateTime date) {
    selectedDate = _normalize(date);
    schedules = monthSchedules[selectedDate] ?? [];
    notifyListeners();
  }

  /// bấm ← →
  void changeMonth(DateTime newDate) {
  focusedMonth = DateTime(newDate.year, newDate.month, 1);
  selectedDate = DateTime(newDate.year, newDate.month, 1);
  loadMonth();
}

  /// calendar dùng để vẽ dot
  bool hasSchedule(DateTime day) {
    return monthSchedules[_normalize(day)]?.isNotEmpty == true;
  }

  // ======================
  // LOAD DATA
  // ======================

  Future<void> loadMonth() async {
  if (selectedChildId == null) return;

  final token = ++_loadToken;

  try {
    isLoading = true;
    error = null;
    notifyListeners();

    final list = await _repo.getSchedulesByMonth(
      parentUid: parentUid,
      childId: selectedChildId!,
      month: focusedMonth,
    );

    if (token != _loadToken) return;

    monthSchedules = _groupByDay(list);
    final key = _normalize(selectedDate);
    schedules = monthSchedules[key] ?? [];
  } catch (e) {
    if (token != _loadToken) return;
    error = e.toString();
  } finally {
    if (token != _loadToken) return;
    isLoading = false;
    notifyListeners();
  }
}

  // ======================
  // CRUD
  // ======================

  Future<void> addSchedule(Schedule s) async {
    await _repo.createSchedule(parentUid, s);
    await loadMonth();
  }

  Future<void> updateSchedule(Schedule s) async {
    await _repo.updateSchedule(parentUid, s);
    await loadMonth();
  }

  Future<void> deleteSchedule(String id) async {
  try {
    // optimistic UI
    schedules.removeWhere((e) => e.id == id);
    for (final entry in monthSchedules.entries) {
      entry.value.removeWhere((e) => e.id == id);
    }
    notifyListeners();

    await _repo.deleteSchedule(parentUid, id);

    // đảm bảo dot + list khớp tuyệt đối với server
    await loadMonth();
  } catch (e) {
    rethrow;
  }
}

  // ======================
  // HELPERS
  // ======================

  Map<DateTime, List<Schedule>> _groupByDay(List<Schedule> list) {
    final map = <DateTime, List<Schedule>>{};
    for (final s in list) {
      final key = _normalize(s.startAt);
      map.putIfAbsent(key, () => []).add(s);
    }
    return map;
  }

  DateTime _normalize(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

}