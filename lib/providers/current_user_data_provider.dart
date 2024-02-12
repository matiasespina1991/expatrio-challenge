import 'package:expatrio_challenge/services/current_user_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_data_model.dart';

class CurrentUserDataProvider with ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  UserDataModel? _userData;
  bool hasError = false;
  bool fetchingUserData = false;
  bool userDataFetchedSuccessfully = false;

  CurrentUserDataProvider() {
    debugPrint('User data provider initialized.');
    loadUserData();
  }

  UserDataModel? get userData => _userData;

  Future<String> loadUserData() async {
    if (fetchingUserData) return 'fetching';
    hasError = false;
    fetchingUserData = true;
    notifyListeners();

    try {
      String? userId = await storage.read(key: 'user_id');
      String? accessToken = await storage.read(key: 'auth_token');
      if (userId == null || accessToken == null) {
        debugPrint(
            'User ID and Auth Token not found. User is probably yet not authenticated.');
        return 'not_authenticated';
      }

      final UserDataModel? userData =
          await CurrentUserDataService().fetchUserData();

      if (userData != null) {
        _userData = userData;
        userDataFetchedSuccessfully = true;
        return 'success';
      } else {
        hasError = true;
        return 'error';
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      hasError = true;
      return 'error';
    } finally {
      fetchingUserData = false;
      notifyListeners();
    }
  }

  Future<void> setUserData(UserDataModel userData) async {
    _userData = userData;
    notifyListeners();
  }

  Future<void> clearUserData() async {
    _userData = null;
    notifyListeners();
  }

  void clearError() {
    hasError = false;
    fetchingUserData = false;
    notifyListeners();
  }
}
