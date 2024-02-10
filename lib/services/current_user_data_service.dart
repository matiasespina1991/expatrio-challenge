import 'dart:convert';
import 'package:expatrio_challenge/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/user_data_model.dart';
import 'authentication_service.dart';

class CurrentUserData {
  final storage = const FlutterSecureStorage();

  Future<UserDataModel?> fetchUserData() async {
    late String? userId;

    debugPrint('Fetching user data...');

    try {
      userId = await storage.read(key: 'user_id');
      if (userId == null) {
        debugPrint('Error: User ID not found.');
        return null;
      }

      final accessToken = await storage.read(key: 'auth_token');
      if (accessToken == null) {
        debugPrint('Error: Access token not found.');
        return null;
      }

      String userProfileEndpoint =
          'https://dev-api.expatrio.com/portal/users/$userId/profile';

      final Response response = await http.get(
        Uri.parse(userProfileEndpoint),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        debugPrint('User data fetched successfully.');
        return UserDataModel.fromJson(data);
      } else {
        debugPrint(
            'Failed to fetch user profile. Status: ${response.statusCode}. Reason: ${response.body}');
        if (response.statusCode == 401) {
          debugPrint(
              'Error: Unauthorized. The access token is invalid. User will be logged out.');
          final AuthProvider authProvider = AuthProvider();
          final AuthenticationService authService = AuthenticationService(
              authProvider: authProvider, userDataProvider: null);
          await authService.logout();
          await authProvider.clearAuthToken();

          return null;
        }
        return null;
      }
    } catch (e) {
      debugPrint(
          'ERROR: An exception was thrown when trying to fetch current user data.');
      debugPrint('The error was thrown at: CurrentUserData.fetchUserData()');
      debugPrint('Error: $e');
    }
    return null;
  }
}
