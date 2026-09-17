import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/features/catalogo/catalog_view_model.dart';
import 'package:tienda_aula/repositories/product_repository.dart';
import 'support.dart';

void main() {
  test('US04: categorias', () async {
    final api = FakeApi();
    final vm = CatalogViewModel(ProductRepository(api, signedIn(4)));
    await vm.load('Accesorios');
    expect(api.calls, contains('GET /products/category/Accesorios'));
    await vm.load();
    expect(vm.category, isNull);
  });
}
