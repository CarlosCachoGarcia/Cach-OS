import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/repositories/audit_repository.dart';
import 'package:tienda_aula/repositories/product_repository.dart';
import 'package:tienda_aula/features/auditorias/audit_view_model.dart';
import 'support.dart';

void main() {
  test('US12: historico-carritos', () async {
    final api = FakeApi();
    final session = signedIn(3);
    final vm = AuditViewModel(
        AuditRepository(api, session), ProductRepository(api, session));
    expect(await vm.loadCarts(), true);
    expect(vm.titles[1], 'Mochila');
    expect(vm.carts.single.quantities[1], 2);
    await expectLater(
        AuditRepository(api, signedIn(4)).carts(), throwsException);
  });
}
