import '../../core/base_view_model.dart';
import '../../core/app_error.dart';
import '../../models/cart.dart';
import '../../models/product.dart';
import '../../repositories/cart_repository.dart';

class CartViewModel extends BaseViewModel {
  final CartRepository repository;
  List<CartLine> _lines = [];
  int? cartId;
  CartViewModel(this.repository);
  List<CartLine> get lines => List.unmodifiable(_lines);
  int get totalCents => _lines.fold(0, (sum, line) => sum + line.subtotalCents);
  int get count => _lines.fold(0, (sum, line) => sum + line.quantity);
  Future<bool> add(Product product, int quantity) => run(() async {
        if (quantity <= 0) {
          throw const AppError('La cantidad debe ser mayor a cero.');
        }
        final next = [..._lines];
        final index = next.indexWhere((line) => line.product.id == product.id);
        if (index < 0) {
          next.add(CartLine(product, quantity));
        } else {
          next[index] = CartLine(product, next[index].quantity + quantity);
        }
        final id = await repository.add(next);
        cartId = id;
        _lines = next;
      });
  Future<bool> change(CartLine line, int quantity) => run(() async {
        final before = _lines;
        final next = [
          for (final item in _lines)
            if (item.product.id != line.product.id)
              item
            else if (quantity > 0)
              CartLine(item.product, quantity),
        ];
        _lines = next;
        notifyListeners(); // Total inmediato; se revierte si falla la red.
        try {
          if (quantity <= 0) {
            await repository.delete(cartId!);
          } else {
            await repository.update(cartId!, next);
          }
        } catch (_) {
          _lines = before;
          rethrow;
        }
      });
  void clear() {
    _lines = [];
    cartId = null;
    error = null;
    notifyListeners();
  }
}
