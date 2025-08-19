import 'package:flutter/material.dart';
import '../../../database/cart_database.dart';

class CartService extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  CartService() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    _cartItems = await CartDatabase.instance.getAllItems();
    notifyListeners();
  }

  Future<void> addItem(Map<String, dynamic> newItem) async {
    await CartDatabase.instance.insertItem(newItem);
    await _loadCart(); // refresh cart items from DB
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
    await CartDatabase.instance.updateQuantity(id, newQuantity);
    await _loadCart();
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
