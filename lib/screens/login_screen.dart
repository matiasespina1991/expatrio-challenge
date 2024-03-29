import 'package:expatrio_challenge/models/login_attempt_response_model.dart';

import 'package:expatrio_challenge/services/authentication_service.dart';
import 'package:expatrio_challenge/theme/expatrio_theme.dart';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../mixins/connectivity_snackbar_mixin.dart';
import '../providers/authentication_provider.dart';
import '../providers/conectivity_provider.dart';
import '../providers/current_user_data_provider.dart';
import '../utilities/error_code_to_message.dart';
import '../utilities/validate_email.dart';
import '../widgets/buttons.dart';
import '../widgets/modals.dart';

class LoginScreen extends StatefulWidget {
  /// If the user tries to access a screen without being authenticated,
  /// this variable will be populated with the name of the screen the
  /// user tried to access.
  final String? userTriedUnauthorizedAccess;
  const LoginScreen({
    this.userTriedUnauthorizedAccess,
    super.key,
  });

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with ConnectivitySnackBarMixin {
  late AuthenticationService _authService;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late String? lastUsedLoginEmail;
  final showModal = ShowModal();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  late ConnectivityProvider _connectivityProvider;

  bool _isEmailValid = true;
  bool _isPasswordVisible = false;
  bool _isHelpButtonVisible = true;
  bool _attemptingLogin = false;

  void _loadLastUsedLoginEmail() async {
    lastUsedLoginEmail = await storage.read(key: 'last_used_login_email');
    if (lastUsedLoginEmail != null) {
      _emailController.text = lastUsedLoginEmail!;
    }
  }

  @override
  void initState() {
    super.initState();

    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
    _authService = AuthenticationService(
      authProvider: Provider.of<AuthProvider>(context, listen: false),
      userDataProvider:
          Provider.of<CurrentUserDataProvider>(context, listen: false),
    );

    _connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);

    // _connectivityProvider.addListener(() {
    //   if (mounted) {
    //     debugPrint(
    //         'Connectivity changed: ${_connectivityProvider.isConnected}');
    //     showConnectivitySnackBar(context, _connectivityProvider.isConnected);
    //   }
    // });

    _connectivityProvider.addListener(() {
      if (mounted) {
        showConnectivitySnackBar(context, _connectivityProvider.isConnected);
      }
    });

    _loadLastUsedLoginEmail();

    if (widget.userTriedUnauthorizedAccess != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModal.unauthorizedAccess(
          screenName: widget.userTriedUnauthorizedAccess!,
          context: context,
          onTapConfirm: () {
            Navigator.of(context).pop();
          },
        );
      });
    }
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _connectivityProvider.removeListener(() {});

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
                      onChanged: (value) {
                        if (isEmailValid(value)) {
                          setState(() {
                            _isEmailValid = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withAlpha(220),
                        hintText: 'Email',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        errorText: _isEmailValid
                            ? null
                            : 'Please insert a valid email',
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
                    ExpatrioButton(
                      disabled: _attemptingLogin,
                      fullWidth: true,
                      onPressed: () {
                        attemptLogin(context);
                      },
                      text: 'Login',
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 450,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isHelpButtonVisible)
            Positioned(
              left: 20,
              bottom: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  surfaceTintColor: ExpatrioTheme.secondaryColor,
                  backgroundColor: ExpatrioTheme.secondaryColor,
                  minimumSize: const Size(100, 50),
                ),
                onPressed: () {
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     builder: (context) => const DashboardScreen()));
                },
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
        ],
      ),
    );
  }

  void attemptLogin(context) async {
    setState(() {
      _isEmailValid = true;
    });
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      List<String> emptyFields = [];
      if (_emailController.text.isEmpty) {
        emptyFields.add('email');
      }
      if (_passwordController.text.isEmpty) {
        emptyFields.add('password');
      }

      showModal.loginFieldsAreEmpty(
        emptyFields: emptyFields,
        context: context,
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
      );
      return;
    }

    if (!isEmailValid(_emailController.text)) {
      setState(() {
        _isEmailValid = false;
      });
      return;
    }

    if (!_connectivityProvider.isConnected) {
      showModal.unableToLoginDueToNoInternet(
          context: context, onTapConfirm: () => Navigator.of(context).pop());
      return;
    }

    setState(() {
      _attemptingLogin = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 25),
        content: Text(
          'Trying to login...',
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 26), () {
      if (_attemptingLogin && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: ExpatrioTheme.warningColor,
            content: Text('Fetching user data is taking too long...'),
            duration: Duration(seconds: 40),
          ),
        );
      }
    });

    LoginAttemptResponseModel loginAttempt = await _authService.login(
      context: context,
      emailController: _emailController,
      passwordController: _passwordController,
    );

    String errorMessage = errorCodesToMessage(loginAttempt.errorCode);

    if (loginAttempt.successful) {
      showModal.successfulLogin(
        context: context,
        onTapConfirm: () async {
          Navigator.of(context).pop();

          bool authenticationSuccessful =
              await _authService.authenticate(context);

          if (!authenticationSuccessful) {
            debugPrint(
                'ERROR: Authentication failed despite successful login.');
            showModal.failedLogin(
              errorMessage:
                  'There was an error when trying to authenticate your credentials. Please try again later or contact the administrators.',
              context: context,
              onTapConfirm: () {
                setState(() {
                  _attemptingLogin = false;
                });

                Navigator.of(context).pop();
              },
            );
            return;
          }
        },
      );
    } else {
      showModal.failedLogin(
        errorMessage: errorMessage,
        context: context,
        onTapConfirm: () {
          setState(() {
            _attemptingLogin = false;
          });
          Navigator.of(context).pop();
        },
      );
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
