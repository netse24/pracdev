import '../../../models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ====================================================================
// File: lib/features/products/services/product_service.dart
// Service to fetch product data.
// ====================================================================

class ProductService extends ChangeNotifier {
  // In a real app, this would fetch data from an API or Firebase
  List<Product> getPopularProducts() {
    return [
      Product(
        id: 1,
        name: 'Product 1',
        price: 29.99,
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        imageUrl: 'https://placehold.co/300x400/F4D7D7/FFFFFF?text=Product+1',
      ),
      Product(
        id: 2,
        name: 'Product 2',
        price: 19.99,
        description: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
        imageUrl: 'https://placehold.co/300x400/F4D7D7/FFFFFF?text=Product+2',
      ),
      Product(
        id: 3,
        name: 'Product 3',
        price: 39.99,
        description: 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum.',
        imageUrl: 'https://placehold.co/300x400/F4D7D7/FFFFFF?text=Product+3',
      ),
      Product(
        id: 4,
        name: 'Product 4',
        price: 12.50,
        description: 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia.',
        imageUrl: 'https://placehold.co/300x400/F4D7D7/FFFFFF?text=Product+4',
      ),
    ];
  }
}
