import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CurrentUserTaxData {
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> fetchUserTaxData() async {
    final accessToken = await storage.read(key: 'auth_token');
    if (accessToken == null) {
      debugPrint('Access token not found.');
      return null;
    }

    const taxDataEndpoint =
        'https://dev-api.expatrio.com/v3/customers/:id/tax-data'; // Reemplaza :id con el ID real del cliente.

    final response = await http.get(
      Uri.parse(taxDataEndpoint),
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
          'Failed to fetch tax data. Status: ${response.statusCode}. Reason: ${response.body}');
      return null;
    }
  }
}
