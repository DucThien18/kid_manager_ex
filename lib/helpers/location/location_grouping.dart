import 'package:latlong2/latlong.dart' as osm;
import 'package:kid_manager/models/app_user.dart';
import 'package:kid_manager/models/location/location_data.dart';
import 'location_distance.dart';

class ChildLocationGroup {
  final List<AppUser> children;
  final osm.LatLng center;

  ChildLocationGroup({
    required this.children,
    required this.center,
  });
}

List<ChildLocationGroup> groupChildrenByDistance({
  required List<AppUser> children,
  required Map<String, LocationData> locations,
  double thresholdMeters = 5,
}) {
  final groups = <ChildLocationGroup>[];

  for (final child in children) {
    final loc = locations[child.uid];
    if (loc == null) continue;

    final point = osm.LatLng(loc.latitude, loc.longitude);
    bool added = false;

    for (final group in groups) {
      final d = distanceInMeters(group.center, point);
      if (d <= thresholdMeters) {
        group.children.add(child);
        added = true;
        break;
      }
    }

    if (!added) {
      groups.add(
        ChildLocationGroup(
          children: [child],
          center: point,
        ),
      );
    }
  }

  return groups;
}
