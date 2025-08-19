import '../../../models/product.dart';
import 'package:flutter/material.dart';

// ====================================================================
// File: lib/features/products/services/product_service.dart
// Service to fetch product data with ChangeNotifier
// ====================================================================

class ProductService extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  // Load demo products
  void loadDemoProducts() {
    _products = [
      Product(
        id: 1,
        name: "Night Cream",
        price: 20.0,
        description: "Use during the night",
        imageUrl: "assets/images/night_cream_1.jpg",
        category: "Night cream",
      ),
      Product(
        id: 2,
        name: "Night Cream",
        price: 15.0,
        description: "Use during the night",
        imageUrl: "assets/images/night_cream_2.jpg",
        category: "Night cream",
      ),
      Product(
        id: 3,
        name: "Lip Stain",
        price: 10.0,
        description: "Use on your lip",
        imageUrl: "assets/images/lip_stain_1.jpg",
        category: "Lip Stain",
      ),
      Product(
        id: 4,
        name: "Day Cream",
        price: 15.0,
        description: "Use during the day",
        imageUrl: "assets/images/day_cream_1.jpg",
        category: "Day Cream",
      ),
      // Add more products here...
    ];

    notifyListeners(); // notify UI to rebuild when products change
  }
}
