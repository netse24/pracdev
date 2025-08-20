import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:procdev/data/shared_pref_data.dart';
import 'package:procdev/features/authentication/screens/register_screen.dart';
import 'package:procdev/features/home/screens/main_screen.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../../config/app_routes.dart';
import '../../../widgets/logo_widget.dart';

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
                  LogoWidget(),
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
                        onPressed: () {
                          print("Facebook login button pressed");
                          _signInWithFacebook();
                        },
                        icon: Image.asset(
                          'assets/images/fb.jpg',
                          width: 30,
                          height: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
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
        labelText: 'Email',
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
        labelText: 'Password',
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

            print("Email : $email");
            print("Password : $password");
            onLogin(email, password);
          }
        },
        child: Text("Login"),
      ),
    );
  }

  Widget get _skip {
    return TextButton(
      onPressed: () {
        Get.off(MainScreen());
      },
      child: const Text("Skip", style: TextStyle(color: Colors.blue)),
    );
  }

  Widget get _navigateToRegisterButton {
    return TextButton(
      onPressed: () {
        // Navigate to the registration screen
        // Navigator.of(context).pushNamed(AppRoute.register);
        Get.to(RegisterScreen());
      },
      child: const Text(
        "Don't have an account? Register",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  Future<void> onLogin(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((UserCredential user) {
        print("User :  $user");
        SharedPrefData.login(email, password);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful.')));
        // Navigation
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => MainScreen()),
        // );

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

  Future<void> _signInWithFacebook() async {
    try {
      LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // OAuthCredential credential = FacebookAuthProvider.credential(
        //   result.accessToken!.tokenString,
        // );
        // await FirebaseAuth.instance.signInWithCredential(credential);
        Get.offAll(MainScreen());

        print("Data : ${result.accessToken!.tokenString}");
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error ${result.message}")));
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$error")));
    }
  }
}
