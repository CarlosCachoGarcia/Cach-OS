import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/models/app_user.dart';

void main() {
  test('US01: autenticacion', () async {
    expect([1, 2, 3, 4].map(roleFor),
        [Role.admin, Role.admin, Role.auditor, Role.client]);
  });
}
