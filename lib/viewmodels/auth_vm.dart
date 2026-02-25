import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';

class AuthVM extends ChangeNotifier {
  final AuthRepository _repo;

  AuthVM(this._repo) {
    _listenAuthState();
  }

  User? _user;
  User? get user => _user;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  StreamSubscription<User?>? _sub;

  void _listenAuthState() {
    _sub = _repo.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    return _runAuthAction(() => _repo.login(email, password));
  }

  Future<void> onLoginSuccess(String userId) async {
  }

  Future<bool> register(String email, String password) async {
    return _runAuthAction(
      () => _repo.register(email: email, password: password),
    );
  }

  Future<void> logout() async {
    await _repo.logout();
  }

  Future<bool> _runAuthAction(Future<void> Function() action) async {
    _setLoading(true);
    _error = null;

    try {
      await action();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapFirebaseError(e);
      return false;
    } catch (e) {
      _error = 'Có lỗi xảy ra. Vui lòng thử lại.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Tài khoản không tồn tại';
      case 'wrong-password':
        return 'Sai mật khẩu';
      case 'email-already-in-use':
        return 'Email đã được sử dụng';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'weak-password':
        return 'Mật khẩu quá yếu';
      default:
        return e.message ?? 'Đăng nhập thất bại';
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
