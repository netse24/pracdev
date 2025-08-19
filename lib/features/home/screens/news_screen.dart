import 'dart:async';
import 'package:get/get.dart';
import '../../../models/product.dart';
import 'package:flutter/material.dart';
import '../../../config/app_routes.dart';
import 'package:procdev/database/product_database.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<Product> products = [];
  bool isLoading = true;
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    loadProducts();
  }

  Future<void> loadProducts() async {
    final allProducts = await ProductDatabase.instance.getAllProducts();
    setState(() {
      products = allProducts;
      isLoading = false;
    });
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && products.isNotEmpty) {
        _currentPage = (_currentPage + 1) % products.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.jpg'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Online B.U.T Store",
                  style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
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
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final loremDescription =
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                    "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
                    "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";

                return GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoute.productDetail, arguments: {
                      'product': product,
                      'allProducts': products,
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 3)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.asset(
                              product.imageUrl.isNotEmpty
                                  ? product.imageUrl
                                  : 'assets/images/default.png',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '\$${product.price}',
                                  style: const TextStyle(
                                      color: Colors.pink,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  loremDescription,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(products.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 12 : 8,
                height: _currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.pink : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
