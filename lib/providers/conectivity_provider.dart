import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  ConnectivityResult _connectivityStatus = ConnectivityResult.none;

  ConnectivityProvider() {
    _initConnectivity();
    Connectivity().onConnectivityChanged.listen(_updateConnectivityStatus);
  }

  void _initConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectivityStatus(connectivityResult);
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      debugPrint('USER HAS NO INTERNET CONNECTION.');
    }

    _connectivityStatus = result;
    notifyListeners();
  }

  bool get isConnected => _connectivityStatus != ConnectivityResult.none;
}
