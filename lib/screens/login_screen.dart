import 'package:flutter/material.dart';
import 'package:procdev/data/shared_pref_data.dart';
import 'package:procdev/routes/app_routes.dart';
import 'package:procdev/widgets/logo_widget.dart';
import 'package:procdev/widgets/social_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscureText = true;
  bool _isEmailValid = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                  _emailTextFormField,
                  const SizedBox(height: 16.0),
                  _passwordTextFormField,
                  const SizedBox(height: 16.0),
                  SocialWidget(),
                  const SizedBox(height: 16.0),
                  _loginButton,
                  _navigateToRegisterButton
                ],
              ),
            )));
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

  Widget get _loginButton {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            // Perform login action
            String email = _emailController.text;
            String password = _passwordController.text;

            SharedPrefData.login(email, password);
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
          "Login",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget get _navigateToRegisterButton {
    return TextButton(
      onPressed: () {
        // Navigator.pushNamed(context, "/register");
        AppRoute.key.currentState?.pushNamed(AppRoute.register);
      },
      child: const Text(
        "Don't have an account? Register",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
