import 'package:get/get.dart';
import '../features/home/screens/main_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/screens/news_screen.dart';
import '../features/account/screens/account_screen.dart';
import '../features/home/screens/notification_screen.dart';
import '../features/shopping_cart/screens/cart_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/splash_screen.dart';
import '../features/authentication/screens/register_screen.dart';
import '../features/products/screens/product_detail_screen.dart';

// ====================================================================
// File: lib/config/app_routes.dart
// Defines the named routes for the application.
// ====================================================================

class AppRoute {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';
  static const home = '/home';
  static const productDetail = '/product_detail';
  static const cart = '/cart';
  static const account = '/account';
  static const news = '/news';
  static const notification = '/notification';

  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: main, page: () => const MainScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: productDetail, page: () => const ProductDetailScreen()),
    GetPage(name: cart, page: () => const CartScreen()),
    GetPage(name: account, page: () => const AccountScreen()),
    GetPage(name: news, page: () => const NewsScreen()),
    GetPage(name: notification, page: () => const NotificationScreen()),
  ];
}
