import '../core/api_client.dart';
import '../core/session.dart';
import '../models/product.dart';

class ProductRepository {
  final ApiClient api;
  final Session session;
  ProductRepository(this.api, this.session);
  Future<List<Product>> list() async {
    session.require(true);
    return (await api.request('GET', '/products') as List)
        .map((j) => Product.fromJson(j))
        .toList();
  }
}
