import 'package:flutter/material.dart';

import '../theme/expatrio_theme.dart';
import 'buttons.dart';

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
                ExpatrioButton(
                  onPressed: () {
                    onTapConfirm();
                  },
                  text: 'Got it',
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
                const Text('Login failed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                const Text('Please try again', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ExpatrioButton(
                    isPrimary: false,
                    onPressed: () {
                      onTapConfirm();
                    },
                    text: 'Ok'),
              ],
            ),
          ),
        );
      },
    );
  }

  void loginFieldsAreEmpty({
    required BuildContext context,
    required Function onTapConfirm,
    required List<String> emptyFields,
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
                const Icon(Icons.warning, size: 50, color: Colors.amber),
                const SizedBox(height: 20),
                const Text('Some fields are empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                const Text('Please fill in all fields:',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                ...emptyFields.map((element) => Text(element,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 15),
                ExpatrioButton(
                  isPrimary: false,
                  onPressed: () {
                    onTapConfirm();
                  },
                  text: 'Ok',
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
                const SizedBox(height: 8),
                const Text(
                  'There was an error when trying to logout. Please try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ExpatrioButton(
                  isPrimary: false,
                  onPressed: () {
                    onTapConfirm();
                  },
                  text: 'OK',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void unauthorizedAccess({
    required BuildContext context,
    required onTapConfirm,
    required String screenName,
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
                const Text('Unauthorized Access',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                Text('You need to login to access $screenName.',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ExpatrioButton(
                  isPrimary: false,
                  onPressed: () {
                    onTapConfirm();
                  },
                  text: 'OK',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void unableToLoginDueToNoInternet({
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
                const Icon(Icons.signal_wifi_connected_no_internet_4_outlined,
                    size: 50, color: Colors.grey),
                const SizedBox(height: 20),
                const Text('Unable to Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                const SizedBox(
                  width: 300,
                  child: Text(
                      'You tried to login to login but you dont have internet connection. Please connect to internet and try to login again.',
                      style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20),
                ExpatrioButton(
                  isPrimary: false,
                  onPressed: () {
                    onTapConfirm();
                  },
                  text: 'OK',
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
                  ExpatrioButton(
                    onPressed: () {
                      onTapConfirm();
                    },
                    text: 'Got it',
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
