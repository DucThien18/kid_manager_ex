import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kid_manager/models/user/user_role.dart';
import 'package:kid_manager/models/user/user_subscription.dart';


class AppUser {
  final String uid;
  final UserRole role;

  final String? email;
  final String? displayName;
  final String? photoUrl;

  final String? locale;
  final String? timezone;

  final DateTime? createdAt;
  final DateTime? lastActiveAt;

  /// child only
  final String? parentUid;

  /// parent only
  final SubscriptionInfo? subscription;

  const AppUser({
    required this.uid,
    required this.role,
    this.email,
    this.displayName,
    this.photoUrl,
    this.locale,
    this.timezone,
    this.createdAt,
    this.lastActiveAt,
    this.parentUid,
    this.subscription,
  });

  bool get isParent => role == UserRole.parent;
  bool get isChild => role == UserRole.child;

  // ================= FIRESTORE =================

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'role': roleToString(role),
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'locale': locale,
    'timezone': timezone,
    'createdAt': createdAt == null
        ? null
        : Timestamp.fromDate(createdAt!),
    'lastActiveAt': lastActiveAt == null
        ? null
        : Timestamp.fromDate(lastActiveAt!),
    'parentUid': parentUid,
    'subscription': subscription?.toMap(),
  }..removeWhere((k, v) => v == null);

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};

    return AppUser(
      uid: d['uid'] ?? doc.id,
      role: roleFromString(d['role'] ?? 'parent'),
      email: d['email'],
      displayName: d['displayName'],
      photoUrl: d['photoUrl'],
      locale: d['locale'],
      timezone: d['timezone'],
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
      lastActiveAt: (d['lastActiveAt'] as Timestamp?)?.toDate(),
      parentUid: d['parentUid'],
      subscription: d['subscription'] == null
          ? null
          : SubscriptionInfo.fromMap(
        Map<String, dynamic>.from(d['subscription']),
      ),
    );
  }

  AppUser copyWith({
    String? email,
    String? displayName,
    String? photoUrl,
    String? locale,
    String? timezone,
    DateTime? lastActiveAt,
    SubscriptionInfo? subscription,
  }) {
    return AppUser(
      uid: uid,
      role: role,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      locale: locale ?? this.locale,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      parentUid: parentUid,
      subscription: subscription ?? this.subscription,
    );
  }
}
