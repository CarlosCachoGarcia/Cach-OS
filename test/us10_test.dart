import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/repositories/cart_repository.dart';
import 'package:tienda_aula/features/compras/cart_view_model.dart';
import 'support.dart';

void main() {
  test('US10: gestionar-carrito', () async {
    final api = FakeApi();
    final vm = CartViewModel(CartRepository(api, signedIn(4)));
    await vm.add(product, 2);
    await vm.change(vm.lines.single, 3);
    expect(vm.totalCents, 5997);
    api.fail = true;
    expect(await vm.change(vm.lines.single, 0), false);
    expect(vm.count, 3);
    api.fail = false;
    await vm.change(vm.lines.single, 0);
    expect(vm.totalCents, 0);
  });
}
