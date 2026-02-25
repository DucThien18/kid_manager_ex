import 'package:firebase_core/firebase_core.dart';
import 'package:kid_manager/firebase_options.dart';
import 'package:kid_manager/services/usage_sync_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


const usageSyncTask = "usage_sync_task";

@pragma('vm:entry-point')
void callbackDispatcher() {
  // Workmanager().executeTask((task, inputData) async {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );

  //   final userId = inputData?["userId"] as String?;
  //   if (userId == null || userId.isEmpty) return Future.value(true);

  //   final service = UsageSyncService(FirebaseFirestore.instance);
  //   await service.syncTodayUsage(userId: userId);

  //   return Future.value(true);
  // });
}
