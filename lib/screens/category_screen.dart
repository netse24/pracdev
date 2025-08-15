import 'package:flutter/material.dart';
import 'package:procdev/screens/category_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Map<String, dynamic>> categories = [
    {
      "name": "Lipstick",
      "icon": Icons.brush,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Lipstick"
    },
    {
      "name": "Serum",
      "icon": Icons.science,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Serum"
    },
    {
      "name": "Brushes",
      "icon": Icons.brush,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Brushes"
    },
    {
      "name": "Foundation",
      "icon": Icons.format_paint,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Foundation"
    },
    {
      "name": "Mascara",
      "icon": Icons.remove_red_eye,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Mascara"
    },
    {
      "name": "Blush",
      "icon": Icons.color_lens,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Blush"
    },
    {
      "name": "Lipstick",
      "icon": Icons.brush,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Lipstick"
    },
    {
      "name": "Serum",
      "icon": Icons.science,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Serum"
    },
    {
      "name": "Brushes",
      "icon": Icons.brush,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Brushes"
    },
    {
      "name": "Foundation",
      "icon": Icons.format_paint,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Foundation"
    },
    {
      "name": "Mascara",
      "icon": Icons.remove_red_eye,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Mascara"
    },
    {
      "name": "Blush",
      "icon": Icons.color_lens,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Blush"
    },
    {
      "name": "Lipstick",
      "icon": Icons.brush,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Lipstick"
    },
    {
      "name": "Serum",
      "icon": Icons.science,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Serum"
    },
    {
      "name": "Brushes",
      "icon": Icons.brush,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Brushes"
    },
    {
      "name": "Foundation",
      "icon": Icons.format_paint,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Foundation"
    },
    {
      "name": "Mascara",
      "icon": Icons.remove_red_eye,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Mascara"
    },
    {
      "name": "Blush",
      "icon": Icons.color_lens,
      "description": "assets/images/lip_stain_2.jpg",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Blush"
    },
    {
      "name": "datScreem",
      "icon": Icons.color_lens,
      "description": "assets/images/day_cream_1.jpg",
      "image": "assets/images/day_cream_1.jpg",
      "category": "datScreem"
    },
    {
      "name": "datScreem",
      "icon": Icons.color_lens,
      "description": "assets/images/day_cream_3.jpg",
      "image": "assets/images/day_cream_3.jpg",
      "category": "datScreem"
    },
    {
      "name": "datScreem",
      "icon": Icons.color_lens,
      "description": "assets/images/day_cream_2.jpg",
      "image": "assets/images/day_cream_2.jpg",
      "category": "datScreem"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/images/small_logo.png',
          height: 50,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              key: ValueKey(categories[index]['name']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryDetailScreen(
                      category: categories[index]['name'],
                      description: categories[index]['description'],
                      image: categories[index]['image'],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(categories[index]['icon'], size: 40),
                    const SizedBox(height: 8),
                    Text(categories[index]['name']),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
