import 'package:flutter/foundation.dart';

import 'app_error.dart';

class BaseViewModel extends ChangeNotifier {
  bool busy = false;
  String? error;
  bool _disposed = false;
  Future<bool> run(Future<void> Function() action) async {
    if (busy) return false;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on AppError catch (e) {
      error = e.message;
      return false;
    } catch (_) {
      error = 'No se pudo completar la operación. Intenta nuevamente.';
      return false;
    } finally {
      busy = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
