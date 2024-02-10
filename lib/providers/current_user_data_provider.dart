import 'package:expatrio_challenge/services/current_user_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_data_model.dart';

class CurrentUserDataProvider with ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  UserDataModel? _userData;

  CurrentUserDataProvider() {
    _loadUserData();
  }

  UserDataModel? get userData => _userData;

  Future<void> _loadUserData() async {
    final UserDataModel? userData = await CurrentUserData().fetchUserProfile();
    if (userData != null) {
      _userData = userData;
    }
    notifyListeners();
  }

  Future<void> setUserData(UserDataModel userData) async {
    _userData = userData;
    notifyListeners();
  }

  Future<void> clearUserData() async {
    _userData = null;
    notifyListeners();
  }
}
