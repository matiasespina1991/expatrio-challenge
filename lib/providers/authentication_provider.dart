import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String? _authToken;

  AuthProvider() {
    _loadAuthToken();
  }

  String? get authToken => _authToken;

  Future<void> _loadAuthToken() async {
    _authToken = await storage.read(key: 'auth_token');

    notifyListeners();
  }

  Future<void> setAuthToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
    _authToken = token;
    notifyListeners();
  }

  Future<void> clearAuthToken() async {
    await storage.delete(key: 'auth_token');
    _authToken = null;
    if (_authToken != null) {
      debugPrint('Error: Failed to clear auth token.');
      debugPrint('User current session might not be finished properly.');
    } else {
      debugPrint('Auth token cleared.');
      debugPrint('User will be logged out.');
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await clearAuthToken();
  }

  bool get isAuthenticated => _authToken != null && _authToken!.isNotEmpty;
}
