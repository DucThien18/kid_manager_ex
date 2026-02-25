// lib/features/child/location/presentation/state/child_location_view_model.dart
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:kid_manager/models/location/location_data.dart';
import 'package:kid_manager/repositories/location/location_repository.dart';
import 'package:kid_manager/services/location/location_service.dart';
import 'package:kid_manager/widgets/app/app_mode.dart';

class ChildLocationViewModel extends ChangeNotifier {
  ChildLocationViewModel(
      this._locationRepository,
      this._locationService, {
        FirebaseAuth? auth,
      }) : _auth = auth ?? FirebaseAuth.instance;

  final LocationRepository _locationRepository;
  final LocationServiceInterface _locationService;
  final FirebaseAuth _auth;

  // ===== STATE =====
  LocationData? _currentLocation;
  LocationData? get currentLocation => _currentLocation;

  LocationPlayMode _mode =LocationPlayMode.live;
  LocationPlayMode get mode => _mode;

  MotionState _motionState =MotionState.moving;
  MotionState get motionState =>_motionState;
  DateTime? _lastMoveAt;
  final List<LocationData> _trail = [];
  List<LocationData> get locationTrail => List.unmodifiable(_trail);

  static const double _moveThresholdKm = 0.03; // 30m
  static const double _idleThresholdKm = 0.01; // 10m

  static const Duration _idleAfter = Duration(minutes: 1);
  static const Duration _stationaryAfter = Duration(minutes: 5);

  static const double _maxAcceptableAccuracy =50;

  bool _isSharing = false;
  bool get isSharing => _isSharing;

  bool _requireBackground = false;
  bool get requireBackground => _requireBackground;

  String? _error;
  String? get error => _error;

  // ===== INTERNAL =====
  LocationData? _lastSentLocation;
  StreamSubscription<LocationData>? _gpsSub;
  Timer? _keepAliveTimer;

  bool _restarting = false;

  static const double _minSendDistanceKm = 0.1; // 100m
  static const Duration _keepAliveEvery = Duration(seconds: 30);

  String _requireUid() {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception("Chưa đăng nhập -> không thể chia sẻ vị trí");
    }
    return uid;
  }

  void _setError(Object? e) {
    _error = e?.toString();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  //  dùng khi LOGOUT (clear sạch state)
  Future<void> stopSharingOnLogout() async {
    await stopSharing(clearData: true);
  }

  /// Stop sharing (clearData=false nếu chỉ muốn tạm dừng, true nếu logout)
  Future<void> stopSharing({bool clearData = false}) async {
    await _gpsSub?.cancel();
    _gpsSub = null;

    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;

    _isSharing = false;
    _restarting = false;

    if (clearData) {
      _currentLocation = null;
      _lastSentLocation = null;
      _trail.clear();
      _requireBackground = false;
      _error = null;
    }

    notifyListeners();
  }

  ///  Start sharing (mặc định foreground để chắc chắn hiện permission popup)
  Future<void> startLocationSharing({bool background = false}) async {
    if (_isSharing) return;

    try {
      _requireUid(); // validate
    } catch (e) {
      _setError(e);
      return;
    }

    _error = null;

    // allow caller override requireBackground
    _requireBackground = background;
    notifyListeners();

    final ok = await _locationService.ensureServiceAndPermission(
      requireBackground: _requireBackground,
    );

    if (!ok) {
      _isSharing = false;
      notifyListeners();
      return;
    }

    _isSharing = true;
    _lastMoveAt = DateTime.now();
    _motionState = MotionState.moving;

    notifyListeners();

    // listen GPS stream


    _gpsSub = _locationService.getLocationStream().listen(
          (loc) async {
            debugPrint('📍 GPS RAW: acc=${loc.accuracy}');
            final isFirstFix =_lastSentLocation ==null;

            if(!isFirstFix && loc.accuracy > _maxAcceptableAccuracy){
              return;
            }
        _currentLocation = loc;
        final now = DateTime.now();
        final last =_lastSentLocation;
        double distanceKm =0;
        if (last != null) {
              distanceKm = last.distanceTo(loc);
            }
        _updateMotionState(distanceKm, now);
            if (_shouldSendLocation(loc, distanceKm)) {
              try {
                await _locationRepository.updateMyLocation(loc);
                debugPrint(
                  '✅ SENT → lat=${loc.latitude}, lng=${loc.longitude}, '
                      'acc=${loc.accuracy}, dist=${distanceKm.toStringAsFixed(3)}, '
                      'motion=$_motionState, night=${_isNightSleep(now)}',
                );

                _lastSentLocation = loc;
              } catch (e) {
                _setError(e);
              }
            }
            _appendTrail(loc);
        notifyListeners();
      },
      onError: (e, __) async {
        _setError(e);
        await _restartSharing(delay: const Duration(seconds: 2));
      },
      cancelOnError: false,
    );
  }

  ///  Android 11+: bật background permission (thường sẽ mở Settings)
  Future<void> enableBackgroundSharing() async {
    _requireBackground = true;
    notifyListeners();

    final ok = await _locationService.ensureServiceAndPermission(
      requireBackground: true,
    );

    if (!ok) return;

    // Nếu đã share rồi thì restart 1 lần để chắc stream chạy theo permission mới
    if (_isSharing) {
      await _restartSharing(delay: const Duration(milliseconds: 300));
    }
  }

  Future<void> _restartSharing({Duration delay = const Duration(seconds: 1)}) async {
    if (_restarting) return;
    _restarting = true;

    // nếu user logout giữa chừng
    if (_auth.currentUser?.uid == null) {
      _restarting = false;
      return;
    }

    try {
      await _gpsSub?.cancel();
      _gpsSub = null;

      _isSharing = false;
      notifyListeners();

      await Future.delayed(delay);

      // start lại với mode hiện tại
      await startLocationSharing(background: _requireBackground);
    } finally {
      _restarting = false;
    }
  }

  Future<void> replayHistory({
    Duration step = const Duration(milliseconds: 800),
})async{
    if(_trail.length < 2) return;
    _mode =LocationPlayMode.replay;
    notifyListeners();
    for (final loc in _trail) {
      if (_mode != LocationPlayMode.replay) break;

      _currentLocation = loc;
      notifyListeners();
      await Future.delayed(step);
    }

    _mode = LocationPlayMode.live;
    notifyListeners();
  }
  /// Load lịch sử (dùng chung cho tab History)
  Future<List<LocationData>> loadLocationHistory(String childId) async {
    try {
      final history = await _locationRepository.getLocationHistory(childId);

      _trail
        ..clear()
        ..addAll(history);

      if (history.isNotEmpty) {
        _currentLocation = history.last;
      }

      notifyListeners();
      return history;
    } catch (e) {
      _setError(e);
      return [];
    }
  }
  void stopReplay() {
    if (_mode == LocationPlayMode.replay) {
      _mode = LocationPlayMode.live;
      notifyListeners();
    }
  }

  void _appendTrail(LocationData loc) {
    if (_trail.isEmpty ||
        _trail.last.distanceTo(loc) >= 0.03) {
      _trail.add(loc);
    }
  }

  bool _shouldSendLocation(LocationData loc, double distanceKm) {
    if (_lastSentLocation == null) return true;
    if (loc.accuracy > _maxAcceptableAccuracy) return false;

    final now =DateTime.now();
    if(_isNightSleep(now)){
      return distanceKm >= 0.1;
    }
    switch (_motionState) {
      case MotionState.moving:
        return distanceKm >= 0.03; // 30m

      case MotionState.idle:
        return distanceKm >= 0.05; // 50m

      case MotionState.stationary:
        return false;
    }
  }

  void _updateMotionState(double distanceKm, DateTime now) {
    if (distanceKm >= _moveThresholdKm) {
      _motionState = MotionState.moving;
      _lastMoveAt = now;
      return;
    }

    if (_lastMoveAt == null) return;

    final idleFor = now.difference(_lastMoveAt!);

    if (idleFor >= const Duration(minutes: 5)) {
      _motionState = MotionState.stationary;
    } else if (idleFor >= const Duration(minutes: 1)) {
      _motionState = MotionState.idle;
    }
  }

  bool _isNightSleep(DateTime now){
    final h =now.hour;
    return h >=22 || h<6;
  }
  @override
  void dispose() {
    _gpsSub?.cancel();
    _keepAliveTimer?.cancel();
    super.dispose();
  }
}
