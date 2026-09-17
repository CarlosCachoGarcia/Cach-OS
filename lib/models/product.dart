class Product {
  final int id;
  final String title, description, category, image;
  final double price;
  final double rating;
  final int ratingCount;
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating = 0,
    this.ratingCount = 0,
  });
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: (json['id'] as num).toInt(),
        title: json['title'] ?? '',
        price: (json['price'] as num).toDouble(),
        description: json['description'] ?? '',
        category: json['category'] ?? '',
        image: json['image'] ?? '',
        rating: (json['rating']?['rate'] as num?)?.toDouble() ?? 0,
        ratingCount: (json['rating']?['count'] as num?)?.toInt() ?? 0,
      );
  Map<String, dynamic> toJson() => {
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
      };
}
