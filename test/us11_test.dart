import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/repositories/audit_repository.dart';
import 'support.dart';

void main() {
  test('US11: usuarios', () async {
    final api = FakeApi();
    await expectLater(
        AuditRepository(api, signedIn(4)).users(), throwsException);
    expect(api.calls, isEmpty);
    final users = await AuditRepository(api, signedIn(3)).users();
    expect(users.single.fullName, 'Ana Pérez');
  });
}
