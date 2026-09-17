import '../../core/base_view_model.dart';
import '../../models/product.dart';
import '../../repositories/product_repository.dart';

class ProductFormViewModel extends BaseViewModel {
  final ProductRepository repository;
  Product? saved;
  ProductFormViewModel(this.repository);
  Future<bool> save(Product product, bool creating) => run(() async {
        saved = await repository.save(product, creating: creating);
      });
  static String? requiredText(String? text) =>
      text == null || text.trim().isEmpty ? 'Campo obligatorio' : null;
  static String? price(String? text) {
    final value = double.tryParse((text ?? '').replaceAll(',', '.'));
    return value == null || !value.isFinite || value <= 0
        ? 'Introduce un precio mayor a cero'
        : null;
  }

  static String? imageUrl(String? text) {
    final uri = Uri.tryParse(text?.trim() ?? '');
    return uri == null ||
            !['http', 'https'].contains(uri.scheme) ||
            uri.host.isEmpty
        ? 'Introduce una URL http o https válida'
        : null;
  }
}
