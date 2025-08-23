import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:procdev/features/shopping_cart/services/cart_service.dart';
import 'package:procdev/features/shopping_cart/screens/payment_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final theme = Theme.of(context);

    void _confirmDelete(BuildContext context, CartService cartService,
        Map<String, dynamic> item) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Image.asset(
                item['image'],
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Text("removeItem".tr),
            ],
          ),
          content: Text(
              "Are you sure you want to remove '${item['name']}' from your cart?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("cancel".tr),
            ),
            TextButton(
              onPressed: () {
                cartService.removeItem(item['id']);
                Navigator.pop(context);
              },
              child: Text("delete".tr, style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 1,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.jpg'),
              radius: 25,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Online B.U.T Store",
                  style: TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Beauty with Us",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
      body: cartService.cartItems.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(
                    fontSize: 18, color: theme.textTheme.bodyMedium?.color),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartService.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartService.cartItems[index];
                      final quantity = item['quantity'] ?? 1;
                      final price = (item['price'] as num).toDouble();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.brightness == Brightness.dark
                                  ? Colors.black54
                                  : Colors.black12,
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item['image'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: theme
                                              .textTheme.bodyLarge?.color)),
                                  const SizedBox(height: 4),
                                  Text('\$${price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () => cartService
                                              .decreaseQuantity(item['id'])),
                                      Text('$quantity',
                                          style: TextStyle(
                                              color: theme.textTheme.bodyMedium
                                                  ?.color)),
                                      IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () => cartService
                                              .increaseQuantity(item['id'])),
                                      const Spacer(),
                                      IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () => _confirmDelete(
                                              context, cartService, item)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    boxShadow: [
                      BoxShadow(
                          color: theme.brightness == Brightness.dark
                              ? Colors.black54
                              : Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 2)
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total:",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                              "\$${cartService.totalPrice().toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const PaymentScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("proceedToCheckout".tr,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
