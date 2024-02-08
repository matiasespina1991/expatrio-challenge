import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CurrentUserData {
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final accessToken = await storage.read(key: 'auth_token');
    if (accessToken == null) {
      debugPrint('Access token not found.');
      return null;
    }

    const userProfileEndpoint =
        'https://dev-api.expatrio.com/portal/users/:userId/profile';

    final response = await http.get(
      Uri.parse(userProfileEndpoint),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      debugPrint(
          'Failed to fetch user profile. Status: ${response.statusCode}. Reason: ${response.body}');
      return null;
    }
  }
}
