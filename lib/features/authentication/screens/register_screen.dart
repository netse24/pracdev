import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:procdev/features/authentication/screens/login_screen.dart';
import 'package:procdev/widgets/social_widget.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../../config/app_routes.dart';
import '../../../widgets/logo_widget.dart';

// ====================================================================
// File: lib/features/authentication/screens/register_screen.dart
// Handles new user registration.
// ====================================================================

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isObscureText = true;
  bool _isEmailValid = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoWidget(),
            const Text(
              'Create Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _fullNameTextFormField,
            const SizedBox(height: 20),
            _emailTextFormField,
            const SizedBox(height: 20),
            _passwordTextFormField,
            const SizedBox(height: 20),
            _registerButton,
            const SizedBox(height: 20),
            SocialWidget(),
            _navigateToLoginButton,
          ],
        ),
      ),
    );
  }

  Widget get _fullNameTextFormField {
    return TextFormField(
      controller: _nameController,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter your full name' : null,
      decoration: InputDecoration(
        prefix: Icon(Icons.account_circle, color: Colors.grey),
        labelText: 'Full Name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
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

  Widget get _registerButton {
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
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            final authService =
                Provider.of<AuthService>(context, listen: false);
            String fullName = _nameController.text;
            String email = _emailController.text;
            String password = _passwordController.text;
            final success = await authService.register(
              _nameController.text,
              _emailController.text,
              _passwordController.text,
            );

            print("Full Name : $fullName");
            print("Email : $email");
            print("Password : $password");
            print("Sucess: $success");
            // Firebase Auth
            if (success) {
              Get.offAllNamed(AppRoute.main);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Register successful.')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Register failed.')),
              );
            }
            _nameController.text = "";
            _emailController.text = "";
            _passwordController.text = "";
          }
        },
        child: Text("Register"),
      ),
    );
  }

  Widget get _navigateToLoginButton {
    return TextButton(
      onPressed: () {
        // Navigate to the login screen
        // Navigator.of(context).pushNamed(AppRoute.login);
        Get.to(LoginScreen());
      },
      child: const Text(
        "Already an exist Login",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
