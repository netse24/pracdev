import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<Map<String, String>> newsItems = [
    {
      "title": "Lipstick",
      "date": "11/03/2025",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "image": "assets/images/night_cream_3.jpg"
    },
    {
      "title": "Lipstick",
      "date": "11/03/2025",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "image": "assets/images/day_cream_3.jpg"
    },
    {
      "title": "Lipstick",
      "date": "11/03/2025",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "image": "assets/images/night_cream_1.jpg"
    },
    {
      "title": "Lipstick",
      "date": "11/03/2025",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "image": "assets/images/lip_stain_3.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar background color
        elevation: 0, // Optional: Removes AppBar shadow
        // centerTitle: true, // Centers the logo
        title: Image.asset(
          'assets/images/small_logo.png', // Path to your logo image
          height: 50, // Adjust the height as needed
        ),
      ),
      
      body: ListView.builder(
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          final news = newsItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      news['image']!,
                      width: double.infinity,
                      height: 150,
                      // fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(news["title"]!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(news["date"]!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 5),
                  Text(
                    news["description"]!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text(
                        "Read More",
                        style: TextStyle(
                          color: Color(0xFFF275A7),
                        ),
                      ),
                      onPressed: () {
                        // Add your tap handler here
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
