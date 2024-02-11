import 'package:expatrio_challenge/models/user_tax_data_model.dart';
import 'package:expatrio_challenge/services/current_user_tax_data_service.dart';
import 'package:flutter/material.dart';

class CurrentUserTaxDataProvider with ChangeNotifier {
  UserTaxDataModel? _userTaxData;
  bool fetchingUserData = false;

  CurrentUserTaxDataProvider() {
    loadUserTaxData();
  }

  UserTaxDataModel? get userTaxData => _userTaxData;

  Future<void> loadUserTaxData() async {
    if (fetchingUserData) return;
    fetchingUserData = true;
    notifyListeners();

    try {
      final UserTaxDataModel? userTaxData =
          await CurrentUserTaxDataService().fetchUserTaxData();
      _userTaxData = userTaxData;
    } finally {
      fetchingUserData = false;
      notifyListeners();
    }
  }

  Future<void> setUserTaxData(UserTaxDataModel userTaxData) async {
    _userTaxData = userTaxData;
    notifyListeners();
  }

  Future<void> clearUserTaxData() async {
    _userTaxData = null;
    notifyListeners();
  }
}
