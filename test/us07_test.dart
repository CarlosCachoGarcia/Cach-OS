import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/repositories/product_repository.dart';
import 'support.dart';

void main() {
  test('US07: editar-producto', () async {
    final api = FakeApi();
    await ProductRepository(api, signedIn(1)).save(product, creating: false);
    expect(api.calls, ['PUT /products/1']);
    await expectLater(
        ProductRepository(api, signedIn(3)).save(product, creating: false),
        throwsException);
    expect(api.calls.length, 1);
  });
}
