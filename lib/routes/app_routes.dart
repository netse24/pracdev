import 'package:flutter/material.dart';
import 'package:procdev/screens/account_screent.dart';
import 'package:procdev/screens/home_screen.dart';
import 'package:procdev/screens/main_screen.dart';
import 'package:procdev/screens/splash_screen.dart';
import 'package:procdev/screens/login_screen.dart';
import 'package:procdev/screens/register_screen.dart';
import 'package:procdev/screens/otp_screen.dart';
import 'package:procdev/screens/otp_confirm_screen.dart';

class AppRoute {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String otpConfirm = '/otpConfirm';
  static const String main = '/main';
  static const String account = '/account';

  static final key = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // return MaterialPageRoute(builder: (_) => const SplashScreen());
      case splash:
        return _buildRoute(settings, SplashScreen());
      case home:
        return _buildRoute(settings, HomeScreen());
      case login:
        return _buildRoute(settings, LoginScreen());
      case register:
        return _buildRoute(settings, RegisterScreen());
      case otp:
        return _buildRoute(settings, OtpScreen());
      case otpConfirm:
        return _buildRoute(settings, OtpConfirmScreen());
      case main:
        return _buildRoute(settings, MainScreen());
      case account:
        return _buildRoute(settings, AccountScreent());
      default:
        throw Exception('Route not found: ${settings.name}');
    }
  }

  static Route<dynamic> _buildRoute(RouteSettings settings, Widget newScreen) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => newScreen,
    );
  }
}
