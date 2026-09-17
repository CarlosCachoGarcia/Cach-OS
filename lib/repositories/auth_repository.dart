import 'dart:convert';

import '../core/api_client.dart';
import '../core/session_storage.dart';
import '../core/session.dart';
import '../core/app_error.dart';
import '../models/app_user.dart';

class AuthRepository {
  final ApiClient api;
  final SessionStorage storage;
  final Session session;
  AuthRepository(this.api, this.storage, this.session);
  int userId(String token) {
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))),
      );
      return int.parse(payload['sub'].toString());
    } catch (_) {
      throw const AppError(
        'La sesión recibida no es válida. Inicia sesión nuevamente.',
      );
    }
  }

  Future<void> login(String username, String password) async {
    final json = await api.request('POST', '/auth/login', {
      'username': username.trim(),
      'password': password,
    });
    final token = json['token'] as String;
    final user = AppUser.fromJson(
      await api.request('GET', '/users/${userId(token)}'),
    );
    await storage.save(token);
    session.start(user, token);
  }

  Future<void> restore() async {
    final token = await storage.readToken();
    if (token == null) return;
    final id = userId(token);
    final user = AppUser.fromJson(await api.request('GET', '/users/$id'));
    session.start(user, token);
  }
}
