import 'package:flutter/material.dart';

import '../theme/expatrio_theme.dart';

class ShowModal {
  void successfulLogin({
    required BuildContext context,
    required onTapConfirm,
  }) {
    showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const CircleAvatar(
                  backgroundColor: ExpatrioTheme.primaryColor,
                  radius: 30,
                  child: Icon(Icons.check, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text('Successful Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 5),
                const Text('You will be redirected to your dashboard',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    onTapConfirm();
                  },
                  child: const Text('GOT IT'), // Texto del botón
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void failedLogin({
    required BuildContext context,
    required onTapConfirm,
  }) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  radius: 30,
                  child: const Icon(Icons.close, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text('Failed Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 5),
                const Text('Please try again', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () {
                    onTapConfirm();
                  },
                  child: const Text('OK'), // Texto del botón
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void failedLogout({
    required BuildContext context,
    required onTapConfirm,
  }) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  radius: 30,
                  child: const Icon(Icons.close, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text('Failed Logout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 5),
                const Text(
                    'There was an error when trying to logout. Please try again.',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () {
                    onTapConfirm();
                  },
                  child: const Text('OK'), // Texto del botón
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateTaxData({
    required BuildContext context,
    required onTapConfirm,
  }) {
    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Declaration of financial information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () {
                      onTapConfirm();
                    },
                    child: const Text('GOT IT'), // Texto del botón
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
