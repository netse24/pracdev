import 'package:flutter/material.dart';
import 'package:procdev/data/file_storage_data.dart';
import 'package:procdev/data/shared_pref_data.dart';
import 'package:procdev/widgets/logo_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fullName;
  int _cartTotal = 0;
  // ignore: unused_field, prefer_final_fields
  bool _isLoggedIn = false;
  String selectedCategory = "All";
  final List<Map<String, String>> allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCartOrder();
  }

  Future<void> _loadCartOrder() async {
    await FileStorageData.readDataFromFile().then((List<String> data) {
      setState(() {
        _cartTotal = data.length;
      });
    }).then((error) {
      print("Error loading data");
    });
  }

  Future<void> _loadData() async {
    final sharedPref = await SharedPreferences.getInstance();
    String? username = await sharedPref.getString(SharedPrefData.fullNameKey);
    String? email = await sharedPref.getString(SharedPrefData.emailKey);

    setState(() {
      fullName = username ?? email ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<Map<String, String>> filteredProducts = selectedCategory == "All"
    //     ? "All"
    //     : widget.allProducts
    //         .where((product) => product["category"] == selectedCategory)
    //         .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const LogoWidget(),
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
            _searchWidget,
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/banner.jpg',
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 10),
            const Text("B.U.T Category",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                categoryChip("All"),
                categoryChip("Night cream"),
                categoryChip("Day cream"),
                categoryChip("Lip Stain"),
              ],
            ),
            // const SizedBox(height: 20),
            // const Text("Popular Now",
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // const SizedBox(height: 10),
            // GridView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 10,
            //     mainAxisSpacing: 10,
            //     childAspectRatio: 0.8,
            //   ),
            //   itemCount: filteredProducts.length,
            //   itemBuilder: (context, index) {
            //     return productCard(
            //         filteredProducts[index]); // ✅ Pass correct product data
            //   },
            // )
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

  Widget get _searchWidget {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
