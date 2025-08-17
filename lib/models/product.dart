import '../database/product_database.dart';

// ====================================================================
// File: lib/models/product.dart
// Data model for a product.
// ====================================================================
final db = ProductDatabase.instance;

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      ProductDatabase.columnId: id,
      ProductDatabase.columnName: name,
      ProductDatabase.columnPrice: price,
      ProductDatabase.columnDescription: description,
      ProductDatabase.columnImageUrl: imageUrl,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map[ProductDatabase.columnId],
      name: map[ProductDatabase.columnName],
      price: map[ProductDatabase.columnPrice],
      description: map[ProductDatabase.columnDescription] ?? '',
      imageUrl: map[ProductDatabase.columnImageUrl] ?? '',
    );
  }
}
