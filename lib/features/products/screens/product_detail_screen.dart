import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shopping_cart/services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Map<String, dynamic> product;
  late List<Map<String, dynamic>> allProducts;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = Get.arguments as Map<String, dynamic>;
    product = args['product'] as Map<String, dynamic>;
    allProducts = args['allProducts'] as List<Map<String, dynamic>>;
  }

  @override
  Widget build(BuildContext context) {
    final relatedProducts =
        allProducts.where((p) => p["id"] != product["id"]).toList();
    final cartService = Provider.of<CartService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(product["category"] ?? "",
            style: const TextStyle(color: Colors.pink)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Card
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.asset(
                              product["image"] ?? 'assets/images/default.png',
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product["name"] ?? "Unknown",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "\$${product["price"] ?? 0}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  product["description"] ?? "No description",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Related Products
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Related Products",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: relatedProducts.length,
                            itemBuilder: (context, index) {
                              final item = relatedProducts[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      setState(() {
                                        product = item;
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 4,
                                                  spreadRadius: 2)
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.asset(
                                              item["image"] ??
                                                  'assets/images/default.png',
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            item["name"] ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          "\$${item["price"] ?? 0}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.pink),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add to Cart Button
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {
                cartService.addItem(product);
                Get.toNamed('/cart');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Add to Cart",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
