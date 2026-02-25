import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:kid_manager/models/location/location_data.dart';
import 'package:kid_manager/repositories/location/location_repository.dart';


class LocationRepositoryImpl implements LocationRepository {
  final FirebaseDatabase _database;
  final FirebaseAuth _auth;

  LocationRepositoryImpl({
    FirebaseDatabase? database,
    FirebaseAuth? auth,
  })  : _database = database ?? FirebaseDatabase.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String _requireUid() {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception("Chưa đăng nhập -> không thể gửi vị trí");
    }
    return uid;
  }

  @override
  Future<void> updateMyLocation(LocationData location) async {
    final uid = _requireUid();

    // LẤY parentUid TỪ FIRESTORE
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final parentUid = snap.data()?['parentUid'];
    debugPrint("parentUid : ${parentUid}");
    if (parentUid == null) {
      throw Exception('Không tìm thấy parentUid');
    }

    final baseRef = _database.ref('locations/$uid');

    // meta (để parent đọc)
    await baseRef.child('meta').set({
      'parentUid': parentUid,
      'updatedAt': ServerValue.timestamp,
    });

    // current
    await baseRef.child('current').set({
      ...location.toJson(),
      'updatedAt': ServerValue.timestamp,
    });

    // history
    await baseRef.child('history').push().set(location.toJson());
  }

  @override
  Stream<LocationData> watchChildLocation(String childId) {
    return _database
        .ref('locations/$childId/current')
        .onValue
        .where((event) => event.snapshot.exists) // ⭐ tránh null
        .map((event) {
      final value = event.snapshot.value;

      final raw = Map<dynamic, dynamic>.from(value as Map);

      final json = raw.map(
            (k, v) => MapEntry(k.toString(), v),
      );

      debugPrint('📍 RTDB LOCATIONS [$childId] = $json');

      return LocationData.fromJson(json);
    });
  }





  @override
  Future<List<LocationData>> getLocationHistory(String childId) async {
    final snapshot = await _database.ref('locations/$childId/history').get();
    if (!snapshot.exists) return [];

    final list = <LocationData>[];
    for (final data in snapshot.children) {
      if (data.value is Map) {
        final json = Map<String, dynamic>.from(data.value as Map);
        list.add(LocationData.fromJson(json));
      }
    }

    // sort by timestamp to be safe
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }
}
