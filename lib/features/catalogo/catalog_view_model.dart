import '../../core/base_view_model.dart';
import '../../models/product.dart';
import '../../repositories/product_repository.dart';

class CatalogViewModel extends BaseViewModel {
  final ProductRepository repository;
  List<Product> products = [];
  List<String> categories = [];
  String? category;
  CatalogViewModel(this.repository);
  Future<bool> load([String? selected]) => run(() async {
        category = selected;
        products = [];
        categories = await repository.categories();
        products = await repository.list(selected);
      });
}
