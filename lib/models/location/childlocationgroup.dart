import 'package:kid_manager/models/app_user.dart';
import 'package:latlong2/latlong.dart' as osm;

class ChildLocationGroup {
  final List<AppUser> children;
  final osm.LatLng center;

  ChildLocationGroup({
    required this.children,
    required this.center,
  });
}
