import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_auth_data_model.dart';

class UserAuthDataProvider with ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  UserAuthInfo? _userAuthData;

  UserAuthDataProvider() {
    _loadUserAuthData();
  }

  UserAuthInfo? get userAuthData => _userAuthData;

  Future<void> _loadUserAuthData() async {
    final userAuthDataJson = await storage.read(key: 'user_auth_data');
    if (userAuthDataJson != null) {
      _userAuthData = UserAuthInfo.fromJson(jsonDecode(userAuthDataJson));
    }
    notifyListeners();
  }

  Future<void> setUserAuthData(UserAuthInfo userAuthData) async {
    final userAuthDataJson = jsonEncode(userAuthData.toJson());
    await storage.write(key: 'user_auth_data', value: userAuthDataJson);
    _userAuthData = userAuthData;
    notifyListeners();
  }

  Future<void> clearUserAuthData() async {
    await storage.delete(key: 'user_auth_data');
    _userAuthData = null;
    notifyListeners();
  }
}
