
import 'package:kid_manager/models/location/location_data.dart';

abstract class LocationRepository {
  Future<void> updateMyLocation(LocationData location);

  Stream<LocationData> watchChildLocation(String childId);

  Future<List<LocationData>> getLocationHistory(String childId);
}
