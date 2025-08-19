import 'package:get/get.dart';
import 'config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/product_database.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'features/products/services/product_service.dart';
import 'features/shopping_cart/services/cart_service.dart';

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

  // Initialize GetStorage for theme persistence
  await GetStorage.init();

  // Initialize sqflite for Windows/Linux/macOS
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Initialize SQLite database
  await ProductDatabase.instance.init();
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
