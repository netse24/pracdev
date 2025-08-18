import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../config/app_routes.dart';
import 'package:procdev/database/product_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> allProducts = [];
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
    List<Map<String, dynamic>> filteredProducts = selectedCategory == "All"
        ? allProducts
        : allProducts.where((p) => p["category"] == selectedCategory).toList();

    // Get unique categories
    List<String> categories = [
      "All",
      ...{for (var p in allProducts) p["category"] ?? ""}
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          )
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
            const SizedBox(height: 20),

            // Category chips
            const Text("B.U.T Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((c) => categoryChip(c)).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Popular products
            const Text("Popular Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return productCard(filteredProducts[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryChip(String label) {
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
          backgroundColor: isSelected ? Colors.pink : Colors.grey[300],
          label: Text(
            label,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget productCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoute.productDetail, arguments: {
          'product': product,
          'allProducts': allProducts,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Expanded
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  product["image"] ?? 'assets/images/default.png',
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
                  Text(
                    product["name"] ?? "Unknown",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product["price"] ?? "\$0",
                    style: const TextStyle(fontSize: 16, color: Colors.pink),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
