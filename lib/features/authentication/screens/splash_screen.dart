import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../config/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              "assets/images/logo.jpg",
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),

            // Store Title
            const Text(
              "ONLINE B.U.T STORE",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF275A7), // Pink color
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // Description Text
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: "Welcome to "),
                  TextSpan(
                    text: "Online B.U.T Store.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF275A7),
                    ),
                  ),
                  TextSpan(
                    text:
                        " We are thrilled to have you here and truly appreciate your visit. Whether you are exploring our products, looking for information, or just browsing, we hope you have a great experience.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Get Started Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // ✅ Use GetX instead of AppRoute.key
                  Get.offNamed(AppRoute.main);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF275A7), // Pink button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "GET STARTED",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
