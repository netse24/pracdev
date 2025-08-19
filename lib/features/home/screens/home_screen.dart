import 'package:get/get.dart';
import '../../../models/product.dart';
import 'package:flutter/material.dart';
import '../../../config/app_routes.dart';
import '../../../services/theme_service.dart';
import 'package:procdev/database/product_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> allProducts = [];
  String selectedCategory = "All";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final products = await ProductDatabase.instance.getAllProducts();
    setState(() {
      allProducts = products;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Filter products by category
    List<Product> filteredProducts = selectedCategory == "All"
        ? allProducts
        : allProducts.where((p) => p.category == selectedCategory).toList();

    // Get unique categories
    List<String> categories = ["All", ...{for (var p in allProducts) p.category}];

    // Detect dark mode for dynamic colors
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color background = isDark ? Colors.black : Colors.white;
    Color cardBackground = isDark ? Colors.grey[900]! : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black;
    Color subTextColor = isDark ? Colors.grey[400]! : Colors.black54;

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
                  style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
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
          // Dark Mode toggle button
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: textColor),
            onPressed: () => ThemeService().switchTheme(),
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/banner.jpg',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 18),

            // Category chips / slider
            Text("B.U.T Category",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((c) => categoryChip(c, isDark)).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Popular products
            Text("Popular Now",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredProducts.length > 4 ? 4 : filteredProducts.length,
              itemBuilder: (context, index) {
                return productCard(filteredProducts[index], cardBackground, textColor);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryChip(String label, bool isDark) {
    bool isSelected = label == selectedCategory;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = label;
          });
        },
        child: Chip(
          backgroundColor: isSelected
              ? Colors.pink
              : isDark
                  ? Colors.grey[800]
                  : Colors.grey[300],
          label: Text(
            label,
            style: TextStyle(color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black)),
          ),
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
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  product.imageUrl.isNotEmpty ? product.imageUrl : 'assets/images/default.png',
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
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
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
}
