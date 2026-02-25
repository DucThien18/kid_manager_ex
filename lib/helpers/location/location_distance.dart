import 'package:latlong2/latlong.dart';

final _distance = Distance();

double distanceInMeters(LatLng a, LatLng b) {
  return _distance.as(LengthUnit.Meter, a, b);
}
