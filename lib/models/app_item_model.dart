import 'package:cloud_firestore/cloud_firestore.dart';

class AppItemModel {
  final String packageName;
  final String name;
  final String? iconBase64;

  // usage
  final String? usageTime; // "1h 20m"
  final Timestamp? lastSeen;

  const AppItemModel({
    required this.packageName,
    required this.name,
    this.iconBase64,
    this.usageTime,
    this.lastSeen,
  });

  /// From installed app (AppInfo)
  factory AppItemModel.fromInstalled({
    required String packageName,
    required String name,
    String? iconBase64,
  }) {
    return AppItemModel(
      packageName: packageName,
      name: name,
      iconBase64: iconBase64,
    );
  }

  /// From Firestore
  factory AppItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return AppItemModel(
      packageName: doc.id,
      name: data['name'] ?? '',
      iconBase64: data['iconBase64'],
      usageTime: data['usageTime'],
      lastSeen: data['lastSeen'],
    );
  }

  /// To Firestore (seed)
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'icon': iconBase64,
      'usageTime': usageTime,
      'lastSeen': lastSeen,
    };
  }

  AppItemModel copyWith({
    String? usageTime,
    Timestamp? lastSeen,
  }) {
    return AppItemModel(
      packageName: packageName,
      name: name,
      iconBase64: iconBase64,
      usageTime: usageTime ?? this.usageTime,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
