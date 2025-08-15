import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String category;
  final String description;
  final String image;

  CategoryDetailScreen(
      {required this.category, required this.image, required this.description});

  final List<Map<String, String>> items = [
    {
      "name": "Lipstick A",
      "category": "Lipstick",
      "image": "assets/images/lipstick_a.jpg",
      "price": "12",
      "description": "A long-lasting lipstick with a matte finish."
    },
    {
      "name": "Lipstick B",
      "category": "Lipstick",
      "image": "assets/images/product.jpg",
      "price": "13",
      "description": "A creamy lipstick with a glossy finish."
    },
    {
      "name": "Serum A",
      "category": "Serum",
      "image": "assets/images/night_cream_3.jpg",
      "price": "14",
      "description": "Moisturizing serum for glowing skin."
    },
    {
      "name": "Brush A",
      "category": "Brushes",
      "image": "assets/images/night_cream_2.jpg",
      "price": "14",
      "description": "Soft makeup brush for blending."
    },
    {
      "name": "Foundation A",
      "category": "Foundation",
      "image": "assets/images/night_cream_1.jpg",
      "price": "14",
      "description": "Lightweight foundation for flawless skin."
    },
    {
      "name": "Mascara A",
      "category": "Mascara",
      "image": "assets/images/lip_stain_3.jpg",
      "price": "15",
      "description": "Volumizing mascara for bold lashes."
    },
    {
      "name": "Blush A",
      "category": "Blush",
      "image": "assets/images/lip_stain_2.jpg",
      "price": "16",
      "description": "Pigmented blush for a natural flush."
    },
    {
      "name": "Blush B",
      "category": "Blush",
      "image": "assets/images/lip_stain_1.jpg",
      "price": "17",
      "description": "Soft blush for everyday wear."
    },
    {
      "name": "Day Cream A",
      "category": "Day Cream",
      "image": "assets/images/day_cream_3.jpg",
      "price": "18",
      "description": "Hydrating day cream with SPF protection."
    },
    {
      "name": "Day Cream B",
      "category": "Day Cream",
      "image": "assets/images/day_cream_1.jpg",
      "price": "19",
      "description": "Nourishing day cream for all skin types."
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter items that belong to the selected category
    final categoryItems =
        items.where((item) => item['category'] == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
          ),
          // Display the filtered items in a grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: categoryItems.length,
                itemBuilder: (context, index) {
                  return _buildCard(categoryItems[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, String> item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                item['image'] ??
                    "assets/images/placeholder.jpg", // Default image
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item['name'] ?? "Unnamed Product", // Default name
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "\$${item['price'] ?? "N/A"}", // Default price
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item['description'] ??
                  "No description available.", // Default description
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
