import 'package:latlong2/latlong.dart' as osm;

class MapViewState {
  final osm.LatLng? center;
  final double zoom;

  const MapViewState({
    this.center,
    this.zoom = 15,
  });

  MapViewState copyWith({
    osm.LatLng? center,
    double? zoom,
  }) {
    return MapViewState(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
    );
  }
}
