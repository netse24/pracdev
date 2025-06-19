import 'package:flutter/material.dart';
import 'package:procdev/routes/app_routes.dart';
import 'package:procdev/widgets/logo_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(),
            SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      AppRoute.key.currentState
                          ?.pushReplacementNamed(AppRoute.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text("Create Account",
                        style: TextStyle(fontSize: 16, color: Colors.white)))),
            SizedBox(height: 10),
            SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    AppRoute.key.currentState
                        ?.pushReplacementNamed(AppRoute.main);
                  },
                  child: Text("Login as Guest",
                      style: TextStyle(fontSize: 16, color: Colors.red)),
                )),
          ],
        ),
      ),
    ));
  }
}
