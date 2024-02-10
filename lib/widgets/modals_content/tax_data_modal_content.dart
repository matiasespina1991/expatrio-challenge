import 'package:expatrio_challenge/data/countries_list.dart';
import 'package:expatrio_challenge/models/user_data_model.dart';
import 'package:expatrio_challenge/providers/current_user_data_provider.dart';
import 'package:expatrio_challenge/providers/current_user_tax_data_provider.dart';
import 'package:expatrio_challenge/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../../models/user_tax_data_model.dart';
import '../../utilities/get_country_based_on_country_code.dart';
import 'country_picker_modal_content.dart';

class TaxDataModalContent extends StatefulWidget {
  final VoidCallback onTapUpdate;
  final CurrentUserDataProvider userDataProvider;

  final CurrentUserTaxDataProvider userTaxDataProvider;

  const TaxDataModalContent(
      {super.key,
      required this.onTapUpdate,
      required this.userDataProvider,
      required this.userTaxDataProvider});

  @override
  TaxDataModalContentState createState() => TaxDataModalContentState();
}

class TaxDataModalContentState extends State<TaxDataModalContent> {
  String? selectedCountry;
  late UserDataModel? userData;
  late UserTaxDataModel? userTaxData;
  late TextEditingController taxIdController;

  @override
  void initState() {
    super.initState();
    setState(() {
      userData = widget.userDataProvider.userData;
      userTaxData = widget.userTaxDataProvider.userTaxData;
    });
    ;
    setState(() {
      selectedCountry = userTaxData?.primaryTaxResidence.country;
      taxIdController =
          TextEditingController(text: userTaxData?.primaryTaxResidence.id);
    });
  }

  void _showCountryPicker() async {
    String? result;
    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => CountryPickerModal(
        onCountrySelected: (countrySelected) {
          result = countrySelected;
        },
      ),
    );

    if (result != null) {
      setState(() => selectedCountry = result!);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('selectedCountry: $selectedCountry');
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 20),
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
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Which country serves as your primary tax residence?*'
                            .toUpperCase(),
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _showCountryPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            selectedCountry == null
                                ? const Text('Select a country')
                                : Text(getCountryBasedOnCountryCode(
                                    selectedCountry!)),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text('Tax identification number*'.toUpperCase(),
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: taxIdController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        hintStyle: TextStyle(fontSize: 14),
                        hintText: 'Enter your tax identification number',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ExpatrioButton(
                    text: 'Update',
                    onPressed: () {
                      widget.onTapUpdate();
                    })
              ]),
        ),
      ),
    );
  }
}
