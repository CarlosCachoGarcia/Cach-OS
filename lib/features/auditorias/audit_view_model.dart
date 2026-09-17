import '../../core/base_view_model.dart';
import '../../models/app_user.dart';
import '../../models/cart.dart';
import '../../repositories/audit_repository.dart';
import '../../repositories/product_repository.dart';

class AuditViewModel extends BaseViewModel {
  final AuditRepository repository;
  final ProductRepository products;
  List<AppUser> users = [];
  List<CartRecord> carts = [];
  Map<int, String> titles = {};
  AuditViewModel(this.repository, this.products);
  Future<bool> loadUsers() => run(() async {
        users = await repository.users();
      });
  Future<bool> loadCarts() => run(() async {
        carts = await repository.carts();
        titles = {for (final p in await products.list()) p.id: p.title};
      });
}
