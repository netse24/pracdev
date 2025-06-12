import 'package:flutter/material.dart';

class SocialWidget extends StatelessWidget {
  const SocialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(
            onPressed: () {},
            icon: Image.asset("assets/images/gg.png", width: 30, height: 30)),
        IconButton(
            onPressed: () {},
            icon: Image.asset("assets/images/fb.jpg", width: 30, height: 30)),
      ]),
    );
  }
}
