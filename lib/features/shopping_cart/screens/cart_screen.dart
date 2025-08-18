import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart", style: TextStyle(color: Colors.pink)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: cartService.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
              itemCount: cartService.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartService.cartItems[index];
                return ListTile(
                  leading: Image.asset(item['image'], width: 50, height: 50),
                  title: Text(item['name']),
                  subtitle: Text("\$${item['price']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => cartService.removeItem(item['id']),
                  ),
                );
              },
            ),
    );
  }
}
