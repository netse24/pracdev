import 'dart:convert';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/product_database.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:procdev/config/app_routes.dart';
import 'package:procdev/translate/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:procdev/services/theme_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:procdev/config/firebase_options.dart';
import 'package:procdev/database/product_database.dart';
import 'features/products/services/product_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'features/shopping_cart/services/cart_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:procdev/features/products/services/product_service.dart';
import 'package:procdev/features/shopping_cart/services/cart_service.dart';
import 'package:procdev/features/authentication/services/auth_service.dart';
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
      appId: "919075587089007", // <-- Replace with your App ID
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
  await printKeyHash();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => CartService()),
      ],
      child: const RootApp(),
    ),
  );
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale("en", "US"), Locale("km", "KH")],
      locale: Get.deviceLocale,
      translations: Messages(),
      getPages: AppRoute.routes,
      themeMode: ThemeService().theme,
      initialRoute: AppRoute.splash,
    );
  }
}

Future<void> printKeyHash() async {
  print(
      "--- Attempting to get Key Hash ---"); // 1. Check if the function is even being called.
  try {
    final signature = await const MethodChannel('flutter_facebook_auth')
        .invokeMethod('getSignature');

    // 2. Print what we get back from the native code. It's probably null.
    print("Signature returned from native code: $signature");

    if (signature != null) {
      final decodedSignature = base64Decode(signature);
      final sha1Bytes = sha1.convert(decodedSignature);
      final keyHash = base64.encode(sha1Bytes.bytes);

      print('=====================================================');
      print('          Your Android Debug Key Hash is:');
      print(keyHash);
      print('=====================================================');
    } else {
      print("--- FAILED: The signature was null. ---");
      print(
          "--- This almost always means the Facebook SDK is not correctly set up in your Android files. Please check Step 2 below. ---");
    }
  } on PlatformException catch (e) {
    // 3. Catch a more specific error if the method doesn't exist.
    print("--- FAILED WITH A PLATFORM EXCEPTION ---");
    print("Error Message: ${e.message}");
    print(
        "This means the native method 'getSignature' could not be found. Please check your Android setup.");
  } catch (e) {
    // 4. Catch any other unexpected errors.
    print('--- FAILED WITH A GENERAL EXCEPTION ---');
    print('Error: $e');
  }
}
