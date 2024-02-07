import 'package:expatrio_challenge/screens/home.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                _authService.login(
                  context: context,
                  emailController: _emailController,
                  passwordController: _passwordController,
                );
              },
              child: const Text('LOGIN'),
            ),
          ],
        ),
      ),
    );
  }
}
