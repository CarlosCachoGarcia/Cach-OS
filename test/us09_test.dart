import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/repositories/cart_repository.dart';
import 'package:tienda_aula/features/compras/cart_view_model.dart';
import 'support.dart';

void main() {
  test('US09: agregar-carrito', () async {
    final vm = CartViewModel(CartRepository(FakeApi(), signedIn(4)));
    await vm.add(product, 2);
    await vm.add(product, 1);
    expect(vm.lines.length, 1);
    expect(vm.count, 3);
    vm.clear();
    expect(vm.count, 0);
  });
}
