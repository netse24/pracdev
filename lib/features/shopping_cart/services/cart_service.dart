import 'package:flutter/material.dart';

class CartService extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addItem(Map<String, dynamic> product) {
    // Check if product already in cart
    final index = _cartItems.indexWhere((p) => p['id'] == product['id']);
    if (index == -1) {
      _cartItems.add(product);
    } else {
      // Optional: update quantity
      _cartItems[index]['quantity'] =
          (_cartItems[index]['quantity'] ?? 1) + 1;
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _cartItems.removeWhere((p) => p['id'] == productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
