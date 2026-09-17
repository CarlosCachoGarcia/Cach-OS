import '../../core/base_view_model.dart';
import '../../models/product.dart';
import '../../repositories/product_repository.dart';

class CatalogViewModel extends BaseViewModel {
  final ProductRepository repository;
  List<Product> products = [];
  CatalogViewModel(this.repository);
  Future<bool> load() => run(() async {
        products = [];
        products = await repository.list();
      });
}
