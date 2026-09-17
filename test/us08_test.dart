import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/repositories/product_repository.dart';
import 'support.dart';

void main() {
  test('US08: eliminar-producto', () async {
    final api = FakeApi();
    await expectLater(
        ProductRepository(api, signedIn(4)).delete(1), throwsException);
    expect(api.calls, isEmpty);
    await ProductRepository(api, signedIn(1)).delete(1);
    expect(api.calls, ['DELETE /products/1']);
  });
}
