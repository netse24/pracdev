import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/product_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'features/products/services/product_service.dart';
import 'features/shopping_cart/services/cart_service.dart';
// ====================================================================
// File: lib/main.dart
// Main entry point of the application.
// ====================================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize sqflite for Windows/Linux/macOS
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize Firebase (uncomment when firebase_options.dart is available)
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // Initialize SQLite database
  await ProductDatabase.instance.init();

  // ✅ Insert demo products if table is empty
  await ProductDatabase.instance.insertDemoProductsIfEmpty();

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
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: AppRoute.splash,
      getPages: AppRoute.routes,
    );
  }
}
