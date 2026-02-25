import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as osm;

enum MapRouteMode {
  none,
  singleRoute,
}

class MapViewController extends ChangeNotifier {
  final MapController controller = MapController();

  /* ============================================================
     MAP READY
  ============================================================ */

  bool _mapReady = false;
  bool get mapReady => _mapReady;

  void markMapReady() {
    if (_mapReady) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapReady = true;
      debugPrint('🗺️ MAP REALLY READY');
      notifyListeners();
    });
  }

  /* ============================================================
     CAMERA / FOLLOW STATE
  ============================================================ */

  bool _autoFollow = true;
  bool get autoFollow => _autoFollow;

  bool _fittedOnce = false;

  osm.LatLng? _lastKnownCenter;

  void setAutoFollow(bool v) {
    if (_autoFollow == v) return;
    _autoFollow = v;
    notifyListeners();
  }

  void resetFit() {
    _fittedOnce = false;
  }

  /* ============================================================
     BASIC MOVE
  ============================================================ */

  void moveTo(osm.LatLng point, {double zoom = 16}) {
    if (!_mapReady) {
      debugPrint('⛔ moveTo ignored (map not ready)');
      return;
    }

    _lastKnownCenter = point;
    controller.move(point, zoom);
  }

  void moveToIfAllowed(osm.LatLng point, {double zoom = 16}) {
    if (!_autoFollow) return;
    moveTo(point, zoom: zoom);
  }

  /* ============================================================
     FIT POINTS
  ============================================================ */

  void fitPoints(
      List<osm.LatLng> points, {
        EdgeInsets padding = const EdgeInsets.all(60),
      }) {
    if (!_mapReady) {
      debugPrint('⛔ fitPoints ignored (map not ready)');
      return;
    }

    if (points.isEmpty) return;

    if (points.length == 1) {
      moveTo(points.first);
      return;
    }

    final bounds = LatLngBounds.fromPoints(points);
    controller.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: padding,
      ),
    );
  }

  /// 👉 dùng cho auto-zoom 1 lần duy nhất
  void fitOnce(
      List<osm.LatLng> points, {
        EdgeInsets padding = const EdgeInsets.all(60),
      }) {
    if (_fittedOnce) return;
    _fittedOnce = true;
    fitPoints(points, padding: padding);
  }

  /* ============================================================
     ROUTE
  ============================================================ */

  MapRouteMode _routeMode = MapRouteMode.none;
  List<osm.LatLng> _routePoints = [];

  MapRouteMode get routeMode => _routeMode;
  bool get isRouteActive => _routeMode != MapRouteMode.none;
  List<osm.LatLng> get routePoints => List.unmodifiable(_routePoints);

  void showRoute(List<osm.LatLng> points) {
    if (points.length < 2) return;
    if (!_mapReady) return;

    _routeMode = MapRouteMode.singleRoute;
    _routePoints = List.from(points);

    _autoFollow = false;
    _fitRoute();
    notifyListeners();
  }

  void clearRoute() {
    _routeMode = MapRouteMode.none;
    _routePoints.clear();
    notifyListeners();
  }

  void toggleRoute(List<osm.LatLng> points) {
    if (isRouteActive) {
      clearRoute();
    } else {
      showRoute(points);
    }
  }

  void _fitRoute({EdgeInsets padding = const EdgeInsets.all(60)}) {
    if (_routePoints.length < 2) return;

    final bounds = LatLngBounds.fromPoints(_routePoints);
    controller.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: padding),
    );
  }

  Future<void> animateTo(
      TickerProvider vsync,
      osm.LatLng target, {
        double targetZoom = 16,
        Duration duration = const Duration(milliseconds: 650),
        Curve curve = Curves.easeInOutCubic,
      }) async {
    if (!_mapReady) return;

    final startCenter = controller.camera.center;
    final startZoom = controller.camera.zoom;

    final latTween =
    Tween<double>(begin: startCenter.latitude, end: target.latitude);
    final lngTween =
    Tween<double>(begin: startCenter.longitude, end: target.longitude);
    final zoomTween = Tween<double>(begin: startZoom, end: targetZoom);

    final controllerAnim = AnimationController(
      vsync: vsync,
      duration: duration,
    );

    final animation = CurvedAnimation(
      parent: controllerAnim,
      curve: curve,
    );

    controllerAnim.addListener(() {
      controller.move(
        osm.LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        ),
        zoomTween.evaluate(animation),
      );
    });

    await controllerAnim.forward();
    controllerAnim.dispose();
  }

  Future<void> animateFitBounds(
      TickerProvider vsync,
      List<osm.LatLng> points, {
        EdgeInsets padding = const EdgeInsets.all(60),
        Duration duration = const Duration(milliseconds: 700),
        Curve curve = Curves.easeInOutCubic,
      }) async {
    if (!_mapReady || points.isEmpty) return;

    final bounds = LatLngBounds.fromPoints(points);

    final cameraFit = CameraFit.bounds(
      bounds: bounds,
      padding: padding,
    );

    final targetCamera = cameraFit.fit(controller.camera);

    await animateTo(
      vsync,
      targetCamera.center,
      targetZoom: targetCamera.zoom,
      duration: duration,
      curve: curve,
    );
  }

}
