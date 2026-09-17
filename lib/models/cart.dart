import 'product.dart';

class CartLine {
  final Product product;
  final int quantity;
  const CartLine(this.product, this.quantity);
  int get subtotalCents => (product.price * 100).round() * quantity;
  Map<String, dynamic> toJson() => {
        'productId': product.id,
        'quantity': quantity,
      };
}

class CartRecord {
  final int id, userId;
  final String date;
  final Map<int, int> quantities;
  const CartRecord(this.id, this.userId, this.date, this.quantities);
  factory CartRecord.fromJson(Map<String, dynamic> j) => CartRecord(
        (j['id'] as num).toInt(),
        (j['userId'] as num).toInt(),
        j['date'] ?? '',
        {
          for (final p in j['products'] as List)
            (p['productId'] as num).toInt(): (p['quantity'] as num).toInt(),
        },
      );
}
