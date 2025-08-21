import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:procdev/data/shared_pref_data.dart';
import 'package:procdev/features/authentication/screens/register_screen.dart';
import 'package:procdev/features/authentication/services/auth_service.dart';
import 'package:procdev/features/home/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:procdev/config/app_routes.dart';
import 'package:procdev/widgets/logo_widget.dart';

// ====================================================================
// File: lib/features/authentication/screens/login_screen.dart
// Handles user login.
// ====================================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isEmailValid = false;
  bool _isObscureText = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body);
  }

  Widget get _body {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.pink,
                      child: const Icon(Icons.person,
                          size: 50, color: Colors.white)),
                  Text(
                    'login'.tr + ' ' + 'account'.tr,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  _emailTextFormField,
                  const SizedBox(height: 20),
                  _passwordTextFormField,
                  const SizedBox(height: 20),
                  _loginButton,
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          // print("Facebook login button pressed");
                          if (await _authService.signInWithFacebook()) {
                            Get.offAll(MainScreen());
                          } else {
                            Get.snackbar('Login Error',
                                'Failed to login with Facebook.');
                          }
                        },
                        icon: Image.asset(
                          'assets/images/fb.jpg',
                          width: 30,
                          height: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          print("Google login button pressed");

                          // 1. Get the AuthService from Provider
                          final authService =
                              Provider.of<AuthService>(context, listen: false);

                          try {
                            // 2. Await the result of the sign-in attempt
                            final bool success =
                                await authService.signInWithGoogle();

                            // 3. Check the boolean result directly
                            if (success) {
                              // If true, the login was successful. Navigate to the main screen.
                              print(
                                  "Google sign-in successful, navigating to MainScreen.");
                              Get.offAll(() =>
                                  MainScreen()); // Use a callback for better performance
                            } else {
                              // If false, the AuthService already handled showing a specific
                              // error snackbar. You could log it here if you want.
                              print(
                                  "Google sign-in failed (handled by AuthService).");
                            }
                          } catch (e) {
                            // 4. Add a final catch block for any unexpected errors
                            // that the service might not have handled.
                            print("An unexpected error occurred in the UI: $e");
                            Get.snackbar('Login Error',
                                'An unexpected error occurred. Please try again.');
                          }
                        },
                        icon: Image.asset(
                          'assets/images/gg.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                  _skip,
                ],
              ),
            ),
            _navigateToRegisterButton,
          ],
        ),
      ),
    );
  }

  Widget get _emailTextFormField {
    return TextFormField(
      controller: _emailController,
      onChanged: (value) => {
        if (value.contains("@"))
          {
            setState(() {
              _isEmailValid = true;
            }),
          }
        else
          {
            setState(() {
              _isEmailValid = false;
            }),
          },
      },
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter your email' : null,
      decoration: InputDecoration(
        prefix: Icon(Icons.email, color: Colors.grey),
        suffixIcon: _isEmailValid
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(Icons.check_circle, color: Colors.grey),
        labelText: 'email'.tr,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget get _passwordTextFormField {
    return TextFormField(
      controller: _passwordController,
      obscureText: _isObscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your password";
        }
        if (value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'pwd'.tr,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
        suffixIcon: _isObscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
                icon: const Icon(Icons.visibility_off, color: Colors.grey),
              )
            : IconButton(
                onPressed: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
                icon: const Icon(Icons.visibility, color: Colors.grey),
              ),
      ),
    );
  }

  Widget get _loginButton {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            String email = _emailController.text;
            String password = _passwordController.text;

            // print("Email : $email");
            // print("Password : $password");
            onLogin(email, password);
          }
        },
        child: Text(
          "login".tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Pink color
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget get _skip {
    return TextButton(
      onPressed: () {
        Get.offAll(MainScreen());
      },
      child: Text("skip".tr, style: TextStyle(color: Colors.blue)),
    );
  }

  Widget get _navigateToRegisterButton {
    return TextButton(
      onPressed: () {
        // Navigate to the registration screen
        // Navigator.of(context).pushNamed(AppRoute.register);
        Get.to(RegisterScreen());
      },
      child: Text(
        "iDontHaveAccount".tr,
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  Future<void> onLogin(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((UserCredential user) {
        // print("User :  $user");
        SharedPrefData.login(email, password);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful.')));

        Get.offAllNamed(AppRoute.main);
      }).catchError((e) {
        print("Error : $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login : $e")));
      });
    } catch (e) {
      print("Error : $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login : $e")));
    }
  }
}
