import 'package:get/get.dart';
import 'package:procdev/features/shopping_cart/services/cart_service.dart';
import 'package:procdev/services/theme_service.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:procdev/models/product.dart';
import 'package:flutter/material.dart';
import 'package:procdev/config/app_routes.dart';
import 'package:procdev/database/product_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> allProducts = [];
  bool isLoading = true;

  final _searchController = TextEditingController();
  String _searchQuery = "";
  @override
  void initState() {
    super.initState();
    loadProducts();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  final List<String> _bannerImages = [
    'assets/images/banner.jpg',
    'assets/images/banner1.png',
    'assets/images/banner2.jpg',
    'assets/images/banner3.png',
    'assets/images/banner4.jpg',
  ];
  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    await Future.delayed(const Duration(seconds: 2));

    final products = await ProductDatabase.instance.getAllProducts();
    setState(() {
      allProducts = products;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Detect dark mode for dynamic colors
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color background = isDark ? Colors.black : Colors.white;
    Color cardBackground = isDark ? Colors.grey[900]! : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black;
    Color subTextColor = isDark ? Colors.grey[400]! : Colors.black54;

    final List<Product> displayedProducts = allProducts.where((product) {
      final productName = product.name.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return productName.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.jpg'),
              radius: 25,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Online B.U.T Store",
                  style: TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Beauty with Us",
                  style: TextStyle(fontSize: 12, color: subTextColor),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode,
                color: textColor),
            onPressed: () => ThemeService().switchTheme(),
          ),
          Consumer<CartService>(
            builder: (context, cartService, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    // 1. Reduce the visual padding around the icon.
                    visualDensity: VisualDensity.compact,

                    // 2. Set explicit padding to zero to remove extra space.
                    padding: EdgeInsets.zero,

                    // 3. Constrain the size of the IconButton's tap area.
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.shopping_cart_outlined, color: textColor),
                    onPressed: () {
                      Get.toNamed(AppRoute.cart);
                    },
                  ),
                  if (cartService.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cartService.itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? _buildShimmerEffect(isDark) // Show skeleton loading screen
          : SingleChildScrollView(
              // Show real data once loaded
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar - now connected to a controller
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search for products...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Banner
                  _buildBanner(), // Replace the old ClipRRect with this new widget

                  const SizedBox(height: 18),

                  // Popular products Title
                  Text("Popular Now",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor)),
                  const SizedBox(height: 10),

                  // Product Grid - now uses 'displayedProducts'
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: displayedProducts.length,
                    itemBuilder: (context, index) {
                      return productCard(
                          displayedProducts[index], cardBackground, textColor);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  // --- NEW: Helper Widget for the Shimmer Effect ---
  Widget _buildShimmerEffect(bool isDark) {
    Color baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    Color highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer for Search Bar
            Container(height: 50, width: double.infinity, color: Colors.white),
            const SizedBox(height: 20),
            // Shimmer for Banner
            Container(
                height: 175,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12))),
            const SizedBox(height: 18),
            // Shimmer for "Popular Now" Title
            Container(height: 20, width: 150, color: Colors.white),
            const SizedBox(height: 10),
            // Shimmer Grid for 4 products
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: 4, // <-- Shows 4 placeholder items as requested
              itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
      ),
    );
  }

  Widget productCard(Product product, Color bgColor, Color textColor) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoute.productDetail, arguments: {
          'product': product,
          'allProducts': allProducts,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  product.imageUrl.isNotEmpty
                      ? product.imageUrl
                      : 'assets/images/default.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 4),
                  Text('\$${product.price}',
                      style: const TextStyle(fontSize: 16, color: Colors.pink)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Column(
      children: [
        // The scrolling banner itself
        SizedBox(
          height: 175,
          child: PageView.builder(
            controller: _bannerController,
            // This is called whenever the user scrolls to a new page
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemCount: _bannerImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    _bannerImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // The dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerImages.length, (index) {
            return GestureDetector(
              onTap: () {
                // Animate to the tapped page
                _bannerController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // The active dot is pink, others are grey
                  color: _currentBannerIndex == index
                      ? Colors.pink
                      : Colors.grey.shade400,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
