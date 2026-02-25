import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

class UsageSyncService {
  final FirebaseFirestore _db;
  UsageSyncService(this._db);

  /// format millis -> "Xh Ym"
  String _formatDuration(int millis) {
    final totalMinutes = (millis / 60000).floor();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return "${h}h ${m}m";
  }

  /// Sync usage hôm nay cho tất cả app
  Future<void> syncTodayUsage({required String userId}) async {
    debugPrint("======== DEBUG ===========");
    
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 0, 0, 0);

    // Query usage stats (cần Usage Access)
    final stats = await UsageStats.queryUsageStats(start, now);

    // Map packageName -> usage info
    final Map<String, UsageInfo> map = {
      for (final s in stats) s.packageName ?? "": s,
    };

    // Lấy list apps đã seed trong firestore
    final appsSnap = await _db
        .collection("blocked_items")
        .doc(userId)
        .collection("apps")
        .get();

    final batch = _db.batch();

    debugPrint("Usage map keys: ${map.keys.take(10)}");

    for (final doc in appsSnap.docs) {
      final pkg = doc.id;
      final usage = map[pkg];

      debugPrint("Firestore pkg: $pkg");

      if (usage == null) continue;

      final totalTimeMs = int.tryParse(usage.totalTimeInForeground ?? "0") ?? 0;
      final lastTimeUsedMs = int.tryParse(usage.lastTimeUsed ?? "0") ?? 0;

      batch.set(doc.reference, {
        "usageTime": _formatDuration(totalTimeMs),
        "lastSeen": lastTimeUsedMs > 0
            ? Timestamp.fromMillisecondsSinceEpoch(lastTimeUsedMs)
            : null,
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }
}
