import 'package:flutter/material.dart';
import 'package:procdev/database/cart_database.dart';

class CartService extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  CartService() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    _cartItems = await CartDatabase.instance.getAllItems();
    notifyListeners();
  }

  Future<void> addItem(Map<String, dynamic> newItem) async {
    final existingItemIndex =
        _cartItems.indexWhere((item) => item['id'] == newItem['id']);

    if (existingItemIndex != -1) {
      await increaseQuantity(newItem['id']);
    } else {
      // If item is new, insert it into the database
      await CartDatabase.instance.insertItem(newItem);
      await _loadCart(); // Refresh cart items from DB
    }
  }

  Future<void> removeItem(int id) async {
    await CartDatabase.instance.deleteItem(id);
    await _loadCart();
  }

  Future<void> clearCart() async {
    await CartDatabase.instance.clearCart();
    await _loadCart();
  }

  Future<void> increaseQuantity(int id) async {
    final item = _cartItems.firstWhere((item) => item['id'] == id);
    int newQuantity = (item['quantity'] as int) + 1;
    await CartDatabase.instance.updateQuantity(id, newQuantity);
    await _loadCart();
  }

  Future<void> decreaseQuantity(int id) async {
    final item = _cartItems.firstWhere((item) => item['id'] == id);
    int newQuantity = (item['quantity'] as int) - 1;
    if (newQuantity < 1) newQuantity = 1;
    if (newQuantity < 1) {
      await removeItem(id);
    } else {
      await CartDatabase.instance.updateQuantity(id, newQuantity);
      await _loadCart();
    }
  }

  double totalPrice() {
    double total = 0;
    for (var item in _cartItems) {
      final price = (item['price'] as num).toDouble();
      final quantity = item['quantity'] ?? 1;
      total += price * quantity;
    }
    return total;
  }
}
