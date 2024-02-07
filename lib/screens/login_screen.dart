import 'package:expatrio_challenge/services/authentication_service.dart';
import 'package:expatrio_challenge/theme/expatrio_theme.dart';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  final AuthenticationService _authService = AuthenticationService();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 0,
            child: Image.asset(
              'assets/images/cliparts/health_insurance_clipart.png',
              opacity: const AlwaysStoppedAnimation(.4),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ExpatrioTheme.secondaryColor,
                minimumSize: const Size(100, 50),
              ),
              onPressed: () {},
              child: const Row(
                children: [
                  Icon(Icons.help_outline,
                      size: 25, color: ExpatrioTheme.primaryColor),
                  SizedBox(width: 2),
                  Text('Help',
                      style: TextStyle(
                          color: ExpatrioTheme.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35.0),
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo/ExpatrioLogoBlack_LogoBlack.png',
                          width: 230,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.email_outlined),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'EMAIL ADDRESS',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withAlpha(220),
                        hintText: 'Email',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'PASSWORD',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withAlpha(220),
                        hintText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: ExpatrioTheme.primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    const SizedBox(height: 25.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        attemptLogin(context);
                      },
                      child: const Text('LOGIN'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 450,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void attemptLogin(context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Trying to login...',
        ),
      ),
    );

    await _authService.login(
      context: context,
      emailController: _emailController,
      passwordController: _passwordController,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
