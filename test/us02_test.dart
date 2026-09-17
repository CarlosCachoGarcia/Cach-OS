import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/repositories/auth_repository.dart';
import 'support.dart';

void main() {
  test('US02: cierre-sesion', () async {
    final storage = MemoryStorage();
    final session = signedIn(4);
    final repo = AuthRepository(FakeApi(), storage, session);
    await storage.save(tokenFor(4));
    await repo.logout();
    expect(session.active, false);
    expect(session.role, isNull);
    expect(await storage.readToken(), isNull);
  });
}
