import 'package:flutter/material.dart';
import 'package:procdev/models/product.dart';

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
        name: "Night Cream 1",
        price: 15.0,
        description: "Use during the night",
        imageUrl: "assets/images/night_cream_3.jpg",
        category: "Night cream",
      ),
      Product(
        id: 4,
        name: "Lip Stain 1",
        price: 10.0,
        description: "Use on your lip",
        imageUrl: "assets/images/lip_stain_1.jpg",
        category: "Lip Stain",
      ),
      Product(
        id: 5,
        name: "Lip Stain 2",
        price: 10.0,
        description: "Use on your lip",
        imageUrl: "assets/images/lip_stain_2.jpg",
        category: "Lip Stain",
      ),
      Product(
        id: 6,
        name: "Lip Stain 3",
        price: 10.0,
        description: "Use on your lip",
        imageUrl: "assets/images/lip_stain_3.jpg",
        category: "Lip Stain",
      ),
      Product(
        id: 7,
        name: "Day Cream 1",
        price: 15.0,
        description: "Use during the day",
        imageUrl: "assets/images/day_cream_1.jpg",
        category: "Day Cream",
      ),
      Product(
        id: 8,
        name: "Day Cream 2",
        price: 15.0,
        description: "Use during the day",
        imageUrl: "assets/images/day_cream_2.jpg",
        category: "Day Cream",
      ),
      Product(
        id: 9,
        name: "Day Cream 3",
        price: 15.0,
        description: "Use during the day",
        imageUrl: "assets/images/day_cream_3.jpg",
        category: "Day Cream",
      ),
      // Add more products here...
    ];

    notifyListeners(); // notify UI to rebuild when products change
  }
}
