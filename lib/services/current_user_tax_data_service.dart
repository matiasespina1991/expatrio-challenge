import 'dart:convert';
import 'package:expatrio_challenge/models/user_tax_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CurrentUserTaxDataService {
  final storage = const FlutterSecureStorage();

  Future<UserTaxDataModel?> fetchUserTaxData() async {
    late String? userId;

    debugPrint('Fetching user tax data...');

    try {
      userId = await storage.read(key: 'user_id');

      if (userId == null) {
        debugPrint('Error: User ID not found.');
        return null;
      }

      final accessToken = await storage.read(key: 'auth_token');
      if (accessToken == null) {
        debugPrint('Access token not found.');
        return null;
      }

      String taxDataEndpoint =
          'https://dev-api.expatrio.com/v3/customers/$userId/tax-data';

      final response = await http.get(
        Uri.parse(taxDataEndpoint),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('User tax data fetched successfully.');
        final UserTaxDataModel data =
            UserTaxDataModel.fromJson(jsonDecode(response.body));

        return data;
      } else {
        debugPrint(
            'Failed to fetch tax data. Status: ${response.statusCode}. Reason: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint(
          'ERROR: An exception was thrown when trying to fetch current user tax data.');
      debugPrint(
          'The error was thrown at: CurrentUserTaxData.fetchUserTaxData()');
      debugPrint('Error: $e');
    }
    return null;
  }

  Future<bool> setUserTaxData(UserTaxDataModel userTaxData) async {
    try {
      String? userId = await storage.read(key: 'user_id');
      if (userId == null) {
        debugPrint('Error: User ID not found.');
        return false;
      }

      final accessToken = await storage.read(key: 'auth_token');
      if (accessToken == null) {
        debugPrint('Access token not found.');
        return false;
      }

      String taxDataEndpoint =
          'https://dev-api.expatrio.com/v3/customers/$userId/tax-data';

      Map<String, dynamic> userTaxDataJson = userTaxData.toJson();

      final response = await http.put(
        Uri.parse(taxDataEndpoint),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userTaxDataJson),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('User tax data updated successfully in the server.');
        return true;
      } else {
        debugPrint(
            'Failed to update tax data. Status: ${response.statusCode}. Reason: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint(
          'ERROR: An exception was thrown when trying to update user tax data.');
      return false;
    }
  }
}
