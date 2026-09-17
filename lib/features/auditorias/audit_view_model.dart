import '../../core/base_view_model.dart';
import '../../models/app_user.dart';
import '../../repositories/audit_repository.dart';
import '../../repositories/product_repository.dart';

class AuditViewModel extends BaseViewModel {
  final AuditRepository repository;
  final ProductRepository products;
  List<AppUser> users = [];
  AuditViewModel(this.repository, this.products);
  Future<bool> loadUsers() => run(() async {
        users = await repository.users();
      });
}
