import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionInfo {
  final String plan; // free | pro
  final String status; // active | trial | expired
  final DateTime? startAt;
  final DateTime? endAt;

  const SubscriptionInfo({
    required this.plan,
    required this.status,
    this.startAt,
    this.endAt,
  });

  Map<String, dynamic> toMap() => {
    'plan': plan,
    'status': status,
    'startAt': startAt == null ? null : Timestamp.fromDate(startAt!),
    'endAt': endAt == null ? null : Timestamp.fromDate(endAt!),
  }..removeWhere((k, v) => v == null);

  factory SubscriptionInfo.fromMap(Map<String, dynamic> map) {
    return SubscriptionInfo(
      plan: map['plan'] ?? 'free',
      status: map['status'] ?? 'active',
      startAt: (map['startAt'] as Timestamp?)?.toDate(),
      endAt: (map['endAt'] as Timestamp?)?.toDate(),
    );
  }
}
