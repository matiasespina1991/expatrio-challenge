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
  final AuthenticationService _authService = AuthenticationService();
  final storage = const FlutterSecureStorage();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isHelpButtonVisible = true;

  @override
  void initState() {
    super.initState();
    // Listeners para los FocusNode
    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isHelpButtonVisible =
          !_emailFocusNode.hasFocus && !_passwordFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 0,
            left: 50,
            child: Image.asset(
              'assets/images/cliparts/login_clipart.png',
              opacity: const AlwaysStoppedAnimation(.30),
            ),
          ),
          if (_isHelpButtonVisible)
            Positioned(
              left: 20,
              bottom: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  surfaceTintColor: ExpatrioTheme.secondaryColor,
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
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                      focusNode: _emailFocusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withAlpha(220),
                        hintText: 'Email',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withAlpha(220),
                        hintText: 'Password',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
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
