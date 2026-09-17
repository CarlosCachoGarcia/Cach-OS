import '../../core/base_view_model.dart';
import '../../models/product.dart';
import '../../repositories/product_repository.dart';

class DetailViewModel extends BaseViewModel {
  final ProductRepository repository;
  Product? product;
  DetailViewModel(this.repository);
  Future<bool> load(int id) => run(() async {
        product = await repository.detail(id);
      });
}
