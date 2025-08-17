import 'package:get/get.dart';
import 'config/app_routes.dart';
import 'config/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/product_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'features/products/services/product_service.dart';
import 'features/shopping_cart/services/cart_service.dart';
import 'features/authentication/screens/splash_screen.dart';

// ====================================================================
// File: lib/main.dart
// Main entry point of the application.
// ====================================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize sqflite FFI for Windows
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi; // Must be set before using the database

  // Initialize SQLite database
  await ProductDatabase.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => CartService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Online B.U.T Store',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
