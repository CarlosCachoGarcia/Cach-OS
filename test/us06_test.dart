import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/features/inventario/product_form_view_model.dart';
import 'package:tienda_aula/repositories/product_repository.dart';
import 'support.dart';

void main() {
  test('US06: crear-producto', () async {
    expect(ProductFormViewModel.price('abc'), isNotNull);
    expect(ProductFormViewModel.imageUrl('bad'), isNotNull);
    final api = FakeApi();
    await expectLater(
        ProductRepository(api, signedIn(4)).save(product, creating: true),
        throwsException);
    expect(api.calls, isEmpty);
    await ProductRepository(api, signedIn(1)).save(product, creating: true);
    expect(api.calls, ['POST /products']);
  });
}
