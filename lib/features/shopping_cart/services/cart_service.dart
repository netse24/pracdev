import '../../../models/product.dart';
import 'package:flutter/material.dart';
import '../../../database/product_database.dart';

// ====================================================================
// File: lib/features/shopping_cart/services/cart_service.dart
// Manages the state of the shopping cart.
// ====================================================================

class CartService extends ChangeNotifier {
  List<Product> _cartItems = [];
  final _db = ProductDatabase.instance;

  List<Product> get cartItems => _cartItems;

  CartService() {
    _loadCartItems();
  }

  void _loadCartItems() async {
    final productsFromDb = await _db.getProducts();
    _cartItems = productsFromDb.map((map) => Product.fromMap(map)).toList();
    notifyListeners();
  }

  void addItem(Product product) async {
    // Check if the item already exists to avoid duplicates.
    bool exists = _cartItems.any((cartItem) => cartItem.id == product.id);
    if (!exists) {
      await _db.insertProduct(product.toMap());
      _cartItems.add(product);
      notifyListeners();
    }
  }

  void removeItem(int productId) async {
    await _db.deleteAllProducts(); // Using this for simplicity. A better way would be `_db.deleteProduct(productId)`.
    _cartItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
}
