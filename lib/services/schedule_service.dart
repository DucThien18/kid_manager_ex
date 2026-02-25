import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule.dart';

class ScheduleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String parentUid) {
    return _db.collection('parents').doc(parentUid).collection('schedules');
  }

  Future<List<Schedule>> fetchByChildAndDate({
    required String parentUid,
    required String childId,
    required DateTime date,
  }) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final snap = await _col(parentUid)
        .where('childId', isEqualTo: childId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('startAt')
        .get();

    return snap.docs.map((doc) => Schedule.fromFirestore(doc)).toList();
  }

  Future<void> addSchedule(String parentUid, Schedule s) async {
    await _col(parentUid).add({
      ...s.toMap(),
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> updateSchedule(String parentUid, Schedule s) async {
    await _col(
      parentUid,
    ).doc(s.id).update({...s.toMap(), 'updatedAt': Timestamp.now()});
  }

  Future<void> deleteSchedule(String parentUid, String scheduleId) async {
    await _col(parentUid).doc(scheduleId).delete();
  }
}
