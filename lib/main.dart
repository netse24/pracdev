import 'package:flutter/material.dart';
import 'package:procdev/routes/app_routes.dart';
// import 'package:procdev/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PracDev',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: HomeScreen(),

      initialRoute: AppRoute.splash,
      onGenerateRoute: AppRoute.generateRoute,
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRoute.key,
    );
  }
}
