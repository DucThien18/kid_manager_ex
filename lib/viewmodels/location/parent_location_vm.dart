import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:kid_manager/models/location/location_data.dart';
import 'package:kid_manager/repositories/location/location_repository.dart';

enum LocationSharingStatus { idle, sharing, paused, error }

class ParentLocationVm extends ChangeNotifier {
  final LocationRepository _locationRepo;

  ParentLocationVm(this._locationRepo);

  /* ============================================================
     STATE
  ============================================================ */

  LocationSharingStatus _status = LocationSharingStatus.idle;
  LocationSharingStatus get status => _status;


  bool _readyForInitialFocus = false;
  bool get readyForInitialFocus => _readyForInitialFocus;

  String? _error;
  String? get error => _error;

  void _setError(String msg) {
    _error = msg;
    _status = LocationSharingStatus.error;
    notifyListeners();
  }

  /* ============================================================
     LOCATION DATA
  ============================================================ */
  Map<String, LocationData> get childrenLocations =>
      Map.unmodifiable(_childrenLocations);

  final Map<String, LocationData> _childrenLocations = {};


  final Map<String, List<LocationData>> _childrenTrails = {};
  Map<String, List<LocationData>> get childrenTrails => _childrenTrails;

  final Map<String, StreamSubscription<LocationData>> _subs = {};

  /* ============================================================
     WATCHING
  ============================================================ */

  Stream<LocationData> watchChildLocation(String childId) =>
      _locationRepo.watchChildLocation(childId);

  Future<void> watchAllChildren(List<String> childIds) async {
    _status = LocationSharingStatus.sharing;
    notifyListeners();
    debugPrint('WATCH LOCATION FOR: $childIds');

    for (final childId in childIds) {
      if (_subs.containsKey(childId)) continue;

      _childrenTrails.putIfAbsent(childId, () => []);

      final sub = _locationRepo.watchChildLocation(childId).listen(
            (loc) {
              debugPrint('🔥 LOCATION UPDATE $childId => $loc');
          if (!_isValidLocation(loc)) return;

          _childrenLocations[childId] = loc;

          final trail = _childrenTrails[childId]!;
          if (trail.isEmpty || trail.last.timestamp != loc.timestamp) {
            trail.add(loc);
            if (trail.length > 300) {
              trail.removeRange(0, trail.length - 300);
            }
          }
              // 👇 CHỈ BẬT 1 LẦN DUY NHẤT
              if (!_readyForInitialFocus) {
                _readyForInitialFocus = true;
              }
          notifyListeners();
        },
        onError: (e) => _setError('Lỗi theo dõi $childId: $e'),
      );

      _subs[childId] = sub;
    }
  }

  Future<void> refreshWatching(List<String> newChildIds) async {
    // ❌ KHÔNG clear childrenLocations ở đây

    for (final childId in newChildIds) {
      if (_subs.containsKey(childId)) continue;

      _childrenTrails.putIfAbsent(childId, () => []);

      final sub = _locationRepo.watchChildLocation(childId).listen(
            (loc) {
              debugPrint("Vao den day roi : ${loc.latitude}");
          if (!_isValidLocation(loc)) return;

          _childrenLocations[childId] = loc;
          notifyListeners();
        },
        onError: (e) => _setError('Lỗi theo dõi $childId: $e'),
      );

      _subs[childId] = sub;
    }
  }


  Future<void> stopWatchingChild(String childId) async {
    await _subs[childId]?.cancel();
    _subs.remove(childId);
    _childrenLocations.remove(childId);
    _childrenTrails.remove(childId);
    notifyListeners();
  }

  Future<void> stopWatchingAllChildren() async {
    for (final s in _subs.values) {
      await s.cancel();
    }
    _subs.clear();
    _childrenLocations.clear();
    _childrenTrails.clear();

    _status = LocationSharingStatus.paused;
    notifyListeners();
  }

  /* ============================================================
     HISTORY + STATS
  ============================================================ */

  Future<List<LocationData>> loadLocationHistory(String childId) async {
    try {
      final history = await _locationRepo.getLocationHistory(childId);
      final valid = history.where(_isValidLocation).toList();

      _childrenTrails[childId] = valid;
      if (valid.isNotEmpty) {
        _childrenLocations[childId] = valid.last;
      }
      notifyListeners();
      return valid;
    } catch (e) {
      _setError('Lỗi tải lịch sử: $e');
      return [];
    }
  }

  Map<String, dynamic> getChildLocationStats(String childId) {
    final trail = _childrenTrails[childId] ?? [];
    if (trail.isEmpty) return {};

    double totalDistance = 0;
    for (int i = 1; i < trail.length; i++) {
      totalDistance += trail[i - 1].distanceTo(trail[i]);
    }

    return {
      'totalPoints': trail.length,
      'totalDistance': totalDistance,
      'firstLocation': trail.first,
      'lastLocation': trail.last,
      'timeSpan': trail.last.timestamp - trail.first.timestamp,
    };
  }

  /* ============================================================
     UTILS
  ============================================================ */

  bool _isValidLocation(LocationData loc) {
    return loc.latitude.isFinite &&
        loc.longitude.isFinite &&
        loc.latitude >= -90 &&
        loc.latitude <= 90 &&
        loc.longitude >= -180 &&
        loc.longitude <= 180;
  }

  @override
  void dispose() {
    for (final s in _subs.values) {
      s.cancel();
    }
    super.dispose();
  }
}
