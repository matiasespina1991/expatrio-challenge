import 'dart:developer';

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
    loadUserData();
  }

  UserDataModel? get userData => _userData;

  Future<void> loadUserData() async {
    hasError = false;
    fetchingUserData = true;
    notifyListeners();
    final UserDataModel? userData = await CurrentUserData().fetchUserData();

    if (userData != null) {
      _userData = userData;
      fetchingUserData = false;
      userDataFetchedSuccessfully = true;
      notifyListeners();
    } else {
      hasError = true;
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
