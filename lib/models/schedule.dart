import 'package:cloud_firestore/cloud_firestore.dart';

enum SchedulePeriod { morning, afternoon, evening }

SchedulePeriod periodFromString(String v) {
  switch (v) {
    case 'afternoon':
      return SchedulePeriod.afternoon;
    case 'evening':
      return SchedulePeriod.evening;
    default:
      return SchedulePeriod.morning;
  }
}

String periodToString(SchedulePeriod p) {
  switch (p) {
    case SchedulePeriod.afternoon:
      return 'chiều';
    case SchedulePeriod.evening:
      return 'tối';
    default:
      return 'sáng';
  }
}

class Schedule {
  final String id;

  final String childId;
  final String parentUid;

  final String title;
  final String? description;

  /// ngày (00:00) – phục vụ UI
  final DateTime date;

  /// thời gian thật – dùng để query
  final DateTime startAt;
  final DateTime endAt;

  final SchedulePeriod period;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Schedule({
    required this.id,
    required this.childId,
    required this.parentUid,
    required this.title,
    this.description,
    required this.date,
    required this.startAt,
    required this.endAt,
    required this.period,
    this.createdAt,
    this.updatedAt,
  });

  // -------------------------
  // Firestore → Model
  // -------------------------
  factory Schedule.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};

    return Schedule(
      id: doc.id,
      childId: (d['childId'] ?? '') as String,
      parentUid: (d['parentUid'] ?? '') as String,
      title: (d['title'] ?? '') as String,
      description: d['description'] as String?,
      date: (d['date'] as Timestamp).toDate(),
      startAt: (d['startAt'] as Timestamp).toDate(),
      endAt: (d['endAt'] as Timestamp).toDate(),
      period: periodFromString((d['period'] ?? 'morning') as String),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // -------------------------
  // Model → Firestore
  // -------------------------
  Map<String, dynamic> toMap() => {
        'childId': childId,
        'parentUid': parentUid,
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'startAt': Timestamp.fromDate(startAt),
        'endAt': Timestamp.fromDate(endAt),
        'period': periodToString(period),
        'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
        'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      }..removeWhere((k, v) => v == null);

  // -------------------------
  // Copy with
  // -------------------------
  Schedule copyWith({
    String? title,
    String? description,
    DateTime? date,
    DateTime? startAt,
    DateTime? endAt,
    SchedulePeriod? period,
    DateTime? updatedAt,
  }) {
    return Schedule(
      id: id,
      childId: childId,
      parentUid: parentUid,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      period: period ?? this.period,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
