import '../core/api_client.dart';
import '../core/session.dart';
import '../models/product.dart';

class ProductRepository {
  final ApiClient api;
  final Session session;
  ProductRepository(this.api, this.session);
  Future<List<Product>> list([String? category]) async {
    session.require(true);
    final path = category == null
        ? '/products'
        : '/products/category/${Uri.encodeComponent(category)}';
    return (await api.request('GET', path) as List)
        .map((j) => Product.fromJson(j))
        .toList();
  }

  Future<List<String>> categories() async {
    session.require(true);
    return (await api.request('GET', '/products/categories') as List)
        .cast<String>();
  }

  Future<Product> detail(int id) async {
    session.require(true);
    return Product.fromJson(await api.request('GET', '/products/$id'));
  }

  Future<Product> save(Product p, {required bool creating}) async {
    session.require(session.canManage);
    return Product.fromJson(
      await api.request(
        creating ? 'POST' : 'PUT',
        creating ? '/products' : '/products/${p.id}',
        p.toJson(),
      ),
    );
  }
}
