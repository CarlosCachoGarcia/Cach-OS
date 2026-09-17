import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import 'app_error.dart';

class Session extends ChangeNotifier {
  AppUser? user;
  String? token;
  bool get active => user != null && token != null;
  Role? get role => user?.role;
  bool get canManage => active && role == Role.admin;
  bool get canAudit => active && (role == Role.admin || role == Role.auditor);
  bool get canShop => active && role == Role.client;
  void require(bool allowed) {
    if (!active || !allowed) {
      throw const AppError('No tienes permiso para realizar esta acción.');
    }
  }

  void start(AppUser value, String credential) {
    user = value;
    token = credential;
    notifyListeners();
  }

  void clear() {
    user = null;
    token = null;
    notifyListeners();
  }
}
