import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:procdev/data/sqflite_db_data.dart';
import 'package:procdev/routes/app_routes.dart';
// import 'package:procdev/screens/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // FileStorageData.readDataFromFile();
  // FileStorageData.writeDataToFile("Hello, World!");

  // Initialize the database
  // await SqfliteDbData.instance.database;
  await Firebase.initializeApp();

  final app = App();
  runApp(app);
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PracDev',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      initialRoute: AppRoute.splash,
      onGenerateRoute: AppRoute.generateRoute,
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRoute.key,
    );
  }
}
