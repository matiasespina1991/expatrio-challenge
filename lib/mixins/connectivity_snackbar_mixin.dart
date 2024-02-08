import 'package:flutter/material.dart';

mixin ConnectivitySnackBarMixin {
  void showConnectivitySnackBar(BuildContext context, bool isConnected) {
    if (!isConnected) {
      const snackBar = SnackBar(
        duration: Duration(days: 1),
        content: Row(
          children: [
            Text('No internet connection'),
          ],
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
  }
}
