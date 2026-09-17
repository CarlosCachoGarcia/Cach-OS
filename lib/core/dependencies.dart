import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_client.dart';
import 'session.dart';
import 'session_storage.dart';
import '../repositories/auth_repository.dart';
import '../features/autenticacion/auth_view_model.dart';

// Inyección manual: se construyen los objetos una vez y se pasan por constructor.
class Dependencies {
  final Session session = Session();
  final ApiClient api;
  final SessionStorage storage;
  late final auth = AuthViewModel(AuthRepository(api, storage, session));
  Dependencies({ApiClient? api, SessionStorage? storage})
      : api = api ?? HttpApiClient(http.Client()),
        storage = storage ?? SecureSessionStorage(const FlutterSecureStorage());
}
