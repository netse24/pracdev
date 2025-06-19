import 'package:flutter/material.dart';
import 'package:procdev/data/shared_pref_data.dart';
import 'package:procdev/routes/app_routes.dart';
import 'package:procdev/widgets/logo_widget.dart';
import 'package:procdev/widgets/social_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscureText = true;
  bool _isEmailValid = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Login')),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LogoWidget(),
                  _fullNameTextFormField,
                  const SizedBox(height: 16.0),
                  _emailTextFormField,
                  const SizedBox(height: 16.0),
                  _passwordTextFormField,
                  const SizedBox(height: 16.0),
                  SocialWidget(),
                  const SizedBox(height: 16.0),
                  _registerButton,
                  _navigateToLoginButton
                ],
              ),
            )));
  }

  Widget get _fullNameTextFormField {
    return TextFormField(
      controller: _fullNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your full name';
        }
        if (value.length < 3) {
          return 'Full name must be at least 3 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle, color: Colors.grey),
        labelText: 'Full Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget get _emailTextFormField {
    return TextFormField(
      controller: _emailController,
      onChanged: (value) => {
        setState(() {
          _isEmailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
        })
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail, color: Colors.grey),
        suffixIcon: _isEmailValid
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(Icons.check_circle, color: Colors.grey),
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget get _passwordTextFormField {
    return TextFormField(
      controller: _passwordController,
      obscureText: _isObscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.grey),
        suffixIcon: _isObscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
                icon: Icon(Icons.visibility_off),
                color: Colors.grey)
            : IconButton(
                onPressed: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
                icon: Icon(Icons.visibility),
                color: Colors.grey),
      ),
    );
  }

  Widget get _registerButton {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            String email = _emailController.text;
            String password = _passwordController.text;
            String fullName = _fullNameController.text;

            SharedPrefData.register(email, password, fullName);
            AppRoute.key.currentState?.pushReplacementNamed(AppRoute.main);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "Register",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget get _navigateToLoginButton {
    return TextButton(
      onPressed: () {
        AppRoute.key.currentState?.pushNamed(AppRoute.login);
      },
      child: const Text(
        "I already have an account. Login",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
