import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule.dart';

class ScheduleRepository {
  final FirebaseFirestore _firestore;

  ScheduleRepository(this._firestore);

  // =========================
  // GET SCHEDULES BY MONTH
  // =========================
  Future<List<Schedule>> getSchedulesByMonth({
    required String parentUid,
    required String childId,
    required DateTime month,
  }) async {
    //  đầu tháng
    final startOfMonth = DateTime(month.year, month.month, 1);

    // đầu tháng sau
    final startOfNextMonth =
        DateTime(month.year, month.month + 1, 1);

    final snapshot = await _firestore
        .collection('parents')
        .doc(parentUid)
        .collection('schedules')
        .where('childId', isEqualTo: childId)
        .where(
          'startAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
        )
        .where(
          'startAt',
          isLessThan: Timestamp.fromDate(startOfNextMonth),
        )
        .orderBy('startAt')
        .get();

    return snapshot.docs
        .map((doc) => Schedule.fromFirestore(doc))
        .toList();
  }

  // =========================
  // CRUD 
  // =========================

  Future<void> createSchedule(String parentUid, Schedule s) async {
    await _firestore
        .collection('parents')
        .doc(parentUid)
        .collection('schedules')
        .add(s.toMap());
  }

  Future<void> updateSchedule(String parentUid, Schedule s) async {
    await _firestore
        .collection('parents')
        .doc(parentUid)
        .collection('schedules')
        .doc(s.id)
        .update(s.toMap());
  }

  Future<void> deleteSchedule(String parentUid, String id) async {
    await _firestore
        .collection('parents')
        .doc(parentUid)
        .collection('schedules')
        .doc(id)
        .delete();
  }
}
