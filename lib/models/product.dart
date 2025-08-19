import 'package:procdev/models/db_constant.dart';

class Product {
  final int? id;
  final String name;
  final double price;
  final String description;
  final String imageUrl; // Keep imageUrl
  final String category;

  const Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
  final priceValue = map[DBConstant.colPrice];
  double parsedPrice;

  if (priceValue is int) {
    parsedPrice = priceValue.toDouble();
  } else if (priceValue is double) {
    parsedPrice = priceValue;
  } else {
    parsedPrice = 0.0;
  }

  return Product(
    id: map[DBConstant.colId] as int?,
    name: map[DBConstant.colName] as String? ?? '',
    price: parsedPrice,
    description: map[DBConstant.colDescription] as String? ?? '',
    imageUrl: map[DBConstant.colImage] as String? ?? '',
    category: map[DBConstant.colCategory] as String? ?? '',
  );
}


  Map<String, dynamic> toMap() {
    return {
      if (id != null) DBConstant.colId: id,
      DBConstant.colName: name,
      DBConstant.colPrice: price, // Always store as double (REAL in SQLite)
      DBConstant.colDescription: description,
      DBConstant.colImage: imageUrl,
      DBConstant.colCategory: category,
    };
  }
}
