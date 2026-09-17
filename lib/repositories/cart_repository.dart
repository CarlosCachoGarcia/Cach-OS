import '../core/api_client.dart';
import '../core/session.dart';
import '../models/cart.dart';

class CartRepository {
  final ApiClient api;
  final Session session;
  CartRepository(this.api, this.session);
  Future<int> add(List<CartLine> lines) async {
    session.require(session.canShop);
    final result = await api.request('POST', '/carts', _body(lines));
    return (result['id'] as num).toInt();
  }

  Map<String, dynamic> _body(List<CartLine> lines) => {
        'userId': session.user!.id,
        'date': DateTime.now().toUtc().toIso8601String(),
        'products': lines.map((e) => e.toJson()).toList(),
      };
}
