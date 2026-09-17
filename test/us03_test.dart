import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/repositories/product_repository.dart';
import 'support.dart';

void main() {
  test('US03: catalogo', () async {
    final api = FakeApi();
    final list = await ProductRepository(api, signedIn(4)).list();
    expect(list.single.title, 'Mochila');
    expect(api.calls, ['GET /products']);
  });
}
