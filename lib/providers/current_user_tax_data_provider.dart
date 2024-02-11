import 'package:expatrio_challenge/models/user_tax_data_model.dart'; // Asegúrate de importar el modelo correcto
import 'package:expatrio_challenge/services/current_user_tax_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CurrentUserTaxDataProvider with ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  UserTaxDataModel? _userTaxData;

  CurrentUserTaxDataProvider() {
    loadUserTaxData();
  }

  UserTaxDataModel? get userTaxData => _userTaxData;

  Future<void> loadUserTaxData() async {
    final UserTaxDataModel? userTaxData =
        await CurrentUserTaxDataService().fetchUserTaxData();
    _userTaxData = userTaxData;

    notifyListeners();
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
