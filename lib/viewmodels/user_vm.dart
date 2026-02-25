import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:kid_manager/models/app_user.dart';
import 'package:kid_manager/models/user/user_profile.dart';
import 'package:kid_manager/repositories/user_repository.dart';
import 'package:kid_manager/services/storage_service.dart';

class UserVm extends ChangeNotifier {
  final UserRepository _userRepo;
  final StorageService _storage;

  UserVm(this._userRepo, this._storage);

  /* ============================================================
     GENERAL STATE
  ============================================================ */

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;
  UserProfile? profile;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void _setError(String msg) {
    _error = msg;
    notifyListeners();
  }

  /* ============================================================
     CHILDREN (USER DOMAIN)
  ============================================================ */

  final List<AppUser> _children = [];
  List<AppUser> get children => _children;

  List<String> get childrenIds => _children.map((c) => c.uid).toList();

  StreamSubscription<List<AppUser>>? _childrenSub;

  void watchChildren(String parentUid) {
    _childrenSub?.cancel();
    _childrenSub = _userRepo.watchChildren(parentUid).listen((list) {
      debugPrint('USER_VM children=${list.length}');
      _children
        ..clear()
        ..addAll(list);
      notifyListeners();
    }, onError: (e) => _setError('Lỗi load children: $e'));
  }

  /* ============================================================
     CREATE CHILD
  ============================================================ */

  Future<bool> createChildAccount({
    required String parentUid,
    required String email,
    required String password,
    required String displayName,
    required DateTime? dob,
    required String locale,
    required String timezone,
  }) async {
    try {
      _setLoading(true);

      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final childUid = cred.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(childUid).set({
        "uid": childUid,
        "email": email,
        "displayName": displayName,
        "parentUid": parentUid,
        "role": "child",
        "dob": dob?.millisecondsSinceEpoch,
        "locale": locale,
        "timezone": timezone,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e, s) {
      debugPrint('CreateChildAccount error: $e');
      debugPrintStack(stackTrace: s);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadProfile() async {
    _error = null;
    _loading = true;
    notifyListeners();

    try {
      final uid = await _storage.getString('uid');

      debugPrint(" PROFILE: " + uid.toString());
      if (uid == null) {
        _error = "Không tìm thấy userId";
        _loading = false;
        notifyListeners();
        return;
      }

      profile = await _userRepo.getUserProfile(uid);

      debugPrint("==== PROFILE OBJECT ====");
      debugPrint(profile?.toMap().toString());
      debugPrint("========================");
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> updateUserInfo({
    required String name,
    required String phone,
    required String gender,
    required String dob,
    required String address,
    required bool allowTracking,
  }) async {
    // reset state
    _error = null;

    final userId = await _storage.getString('uid');

    if (userId == null) {
      _error = "Không tìm thấy userId";
      notifyListeners();
      return false;
    }

    // ✅ validate basic (bạn tự nâng cấp)
    if (name.trim().isEmpty) {
      _error = "Họ và tên không được để trống";
      notifyListeners();
      return false;
    }

    _loading = true;
    notifyListeners();

    try {
      final profile = UserProfile(
        id: userId,
        name: name.trim(),
        phone: phone.trim(),
        gender: gender.trim(),
        dob: dob.trim(),
        address: address.trim(),
        allowTracking: allowTracking,
      );

      await _userRepo.updateUserProfile(profile);

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _childrenSub?.cancel();
    super.dispose();
  }
}
