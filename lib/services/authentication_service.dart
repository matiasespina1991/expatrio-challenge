import 'dart:convert';
import 'package:expatrio_challenge/models/login_attempt_response_model.dart';
import 'package:expatrio_challenge/models/user_auth_data_model.dart';
import 'package:expatrio_challenge/models/user_data_model.dart';
import 'package:expatrio_challenge/services/current_user_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/authentication_provider.dart';

import '../providers/current_user_data_provider.dart';
import '../widgets/modals.dart';

class AuthenticationService {
  final storage = const FlutterSecureStorage();
  final showModal = ShowModal();
  final AuthProvider authProvider;
  final CurrentUserDataProvider? userDataProvider;

  AuthenticationService(
      {required this.authProvider, required this.userDataProvider});

  Future<LoginAttemptResponseModel> login(
      {context, emailController, passwordController}) async {
    const authEndpoint = 'https://dev-api.expatrio.com/auth/login';

    debugPrint('Attempting to login...');

    try {
      final response = await http.post(
        Uri.parse(authEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final UserAuthDataModel data =
            UserAuthDataModel.fromJson(jsonDecode(response.body));
        final String accessToken = data.accessToken;
        final String userId = data.userId;

        await storage.write(key: 'auth_token', value: accessToken);
        await storage.write(key: 'user_id', value: userId);
        await storage.write(
            key: 'last_used_login_email', value: emailController.text);

        debugPrint('Login successful.');

        debugPrint('Proceeding to load user data.');

        UserDataModel? currentUserData =
            await CurrentUserDataService().fetchUserData();

        if (currentUserData != null) {
          debugPrint('User data fetched successfully.');

          userDataProvider?.setUserData(currentUserData);
        } else {
          debugPrint('ERROR: User data not found.');
          return LoginAttemptResponseModel(
              successful: false,
              message: 'Login failed.',
              statusCode: 400,
              errorCode: 'USER_DATA_SERVICE_RETURNED_NULL');
        }

        return LoginAttemptResponseModel(
            successful: true,
            message: 'Login successful',
            statusCode: 200,
            errorCode: null);
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String errorMessage =
            responseBody['message'] ?? 'Unkown error. Please try again later.';
        final String errorCode = responseBody['errorCode'];

        debugPrint('Login failed.');
        debugPrint('Login error status: ${response.statusCode}');
        debugPrint('Reason of failed login: $errorMessage');
        debugPrint('Error code: $errorCode');
        return LoginAttemptResponseModel(
            successful: false,
            message: errorMessage,
            statusCode: response.statusCode,
            errorCode: errorCode);
      }
    } catch (e) {
      debugPrint('Login failed.');
      debugPrint('Login failed due to the following error: $e');

      return LoginAttemptResponseModel(
          successful: false,
          message:
              'Unknown Error. Please try again later or contact administrators.',
          statusCode: 500,
          errorCode: 'UNKNOWN_ERROR');
    }
  }

  Future<bool> authenticate(context) async {
    debugPrint('Authenticating user...');
    try {
      final accessToken = await storage.read(key: 'auth_token').catchError((e) {
        debugPrint('Error reading token: $e');
        return e;
      });

      if (accessToken != null) {
        await authProvider.setAuthToken(accessToken);
        debugPrint('User authenticated.');
      }

      return accessToken != null;
    } catch (e) {
      debugPrint('Error reading token: $e');

      return false;
    }
  }

  Future<bool> logout({context}) async {
    try {
      await storage.delete(key: 'auth_token');
      await storage.delete(key: 'user_id');
      try {
        debugPrint('User will be logged out.');
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        final userDataProvider =
            Provider.of<CurrentUserDataProvider>(context, listen: false);
        final authenticationService = AuthenticationService(
            authProvider: authProvider, userDataProvider: userDataProvider);

        await authProvider.logout();
        await authenticationService.logout();
      } catch (e) {
        debugPrint('Error when attempting to logout: $e');
      }
      return true;
    } catch (e) {
      debugPrint('Logout error: $e');
      return false;
    }
  }
}
