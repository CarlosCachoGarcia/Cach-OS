import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SessionStorage {
  Future<String?> readToken();
  Future<void> save(String token);
  Future<void> clear();
}

class SecureSessionStorage implements SessionStorage {
  final FlutterSecureStorage storage;
  SecureSessionStorage(this.storage);
  @override
  Future<String?> readToken() => storage.read(key: 'token');
  @override
  Future<void> save(String token) => storage.write(key: 'token', value: token);
  @override
  Future<void> clear() => storage.deleteAll();
}
