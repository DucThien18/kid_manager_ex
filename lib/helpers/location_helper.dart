import 'package:kid_manager/models/location/location_data.dart';

class LocationHelper {
  static bool isOnline(LocationData? loc) {
    if (loc == null) return false;

    final last = DateTime.fromMillisecondsSinceEpoch(loc.timestamp);
    return DateTime.now().difference(last).inMinutes <= 5;
  }



}
