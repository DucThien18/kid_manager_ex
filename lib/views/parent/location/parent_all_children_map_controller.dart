import 'package:flutter/cupertino.dart';

class ParentAllChildrenMapController extends ChangeNotifier {
  String? _activeChildId;

  String? get activeChildId => _activeChildId;

  bool isActive(String childId) => _activeChildId == childId;

  void activate(String childId) {
    _activeChildId = childId;
    notifyListeners();
  }

  void clear() {
    _activeChildId = null;
    notifyListeners();
  }
}
