import 'package:expatrio_challenge/models/update_tax_data_callback_model.dart';
import 'package:expatrio_challenge/providers/current_user_data_provider.dart';
import 'package:expatrio_challenge/widgets/modals_content/tax_data_modal_content.dart';
import 'package:flutter/material.dart';

import '../providers/current_user_tax_data_provider.dart';
import '../theme/expatrio_theme.dart';
import 'buttons.dart';
import 'modals_content/country_picker_modal_content.dart';

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
                const SizedBox(height: 8),
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
    required String errorMessage,
  }) {
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
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
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text('Login failed',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                  child: Text(errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 12),
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
    required UpdateTaxDataCallback onTapSaveTaxData,
    required CurrentUserDataProvider userDataProvider,
    required CurrentUserTaxDataProvider userTaxDataProvider,
  }) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return TaxDataModalContent(
          onTapSaveTaxData: onTapSaveTaxData,
          userDataProvider: userDataProvider,
          userTaxDataProvider: userTaxDataProvider,
        );
      },
    );
  }

  Future<void> showCountryPicker({
    required BuildContext context,
    required void Function(String) onCountrySelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) =>
          CountryPickerModal(onCountrySelected: onCountrySelected),
    );
  }
}
