import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/features/catalogo/detail_view_model.dart';
import 'package:tienda_aula/repositories/product_repository.dart';
import 'support.dart';

void main() {
  test('US05: detalle', () async {
    final api = FakeApi();
    final vm = DetailViewModel(ProductRepository(api, signedIn(4)));
    expect(await vm.load(1), true);
    expect(vm.product!.id, 1);
    api.fail = true;
    expect(await vm.load(1), false);
    expect(vm.busy, false);
  });
}
