import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:procdev/config/firebase_options.dart';
import 'package:procdev/features/authentication/services/auth_service.dart';
import 'config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/product_database.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'features/products/services/product_service.dart';
import 'features/shopping_cart/services/cart_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // <-- Keep this import

// ================= Theme Service =================
class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}

// ================= Main =================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Initialize the Facebook SDK for web
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "YOUR_FACEBOOK_APP_ID", // <-- Replace with your App ID
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }
  try {
    if (Firebase.apps.isEmpty) {
      print("Initializing Firebase...");
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      print("Firebase already initialized: ${Firebase.apps.first.name}");
    }
  } catch (e) {
    print("Firebase init error: $e");
  }
  // ✅ Initialize sqflite for Windows/Linux/macOS
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // Initialize GetStorage

  // Initialize SQLite database
  await ProductDatabase.instance.init();
  await ProductDatabase.instance.insertDemoProductsIfEmpty();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
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
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.pink,
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      themeMode: ThemeService().theme,
      initialRoute: AppRoute.splash,
      getPages: AppRoute.routes,
    );
  }
}
