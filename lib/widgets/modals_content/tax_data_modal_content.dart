import 'package:expatrio_challenge/models/update_tax_data_callback_model.dart';
import 'package:expatrio_challenge/models/user_data_model.dart';
import 'package:expatrio_challenge/providers/current_user_data_provider.dart';
import 'package:expatrio_challenge/providers/current_user_tax_data_provider.dart';
import 'package:expatrio_challenge/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../../models/user_tax_data_model.dart';
import '../../utilities/get_country_based_on_country_code.dart';
import 'country_picker_modal_content.dart';

class TaxDataModalContent extends StatefulWidget {
  final UpdateTaxDataCallback onTapUpdate;
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
  bool userConfirmsTaxResidencyisTrueAndAccurate = false;
  bool userClickedUpdate = false;
  bool taxIdFieldHasError = false;

  @override
  void initState() {
    super.initState();
    final UserDataModel? _userData = widget.userDataProvider.userData;
    final UserTaxDataModel? _userTaxData =
        widget.userTaxDataProvider.userTaxData;

    setState(() {
      userData = _userData;
      userTaxData = _userTaxData;
      selectedCountry = _userTaxData?.primaryTaxResidence.country;
      taxIdController =
          TextEditingController(text: _userTaxData?.primaryTaxResidence.id);
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

  void handleClickUpdate() {
    setState(() {
      userClickedUpdate = true;
    });
    if (selectedCountry != null &&
        taxIdController.text.isNotEmpty &&
        userConfirmsTaxResidencyisTrueAndAccurate) {
      widget.onTapUpdate(
        selectedCountry!,
        taxIdController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Which country serves as your primary tax residence?*'
                          .toUpperCase(),
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _showCountryPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedCountry == null && userClickedUpdate
                                ? Colors.red
                                : Colors
                                    .black54, // Cambia el color del borde si no se ha seleccionado un país y el usuario intentó actualizar
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCountry == null
                                  ? 'Select a country'
                                  : getCountryBasedOnCountryCode(
                                      selectedCountry!),
                              style: TextStyle(
                                  color: selectedCountry == null &&
                                          userClickedUpdate
                                      ? Colors.red
                                      : Colors
                                          .black), // Cambia el color del texto si es necesario
                            ),
                            const Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                    if (selectedCountry == null &&
                        userClickedUpdate) // Solo muestra el mensaje de error si es necesario
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Please choose a country.',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: taxIdController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        bool isNumeric = RegExp(r'^[0-9]*$').hasMatch(value);
                        if (!isNumeric || value.isEmpty) {
                          setState(() {
                            taxIdFieldHasError = true;
                          });
                        } else {
                          setState(() {
                            taxIdFieldHasError = false;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText:
                            'Tax Identification Number', // Opcional: agrega un labelText para claridad
                        errorText: taxIdFieldHasError
                            ? 'Please enter a valid tax identification number.'
                            : null,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15),
                        hintStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                          isError: userClickedUpdate &&
                              !userConfirmsTaxResidencyisTrueAndAccurate,
                          value: userConfirmsTaxResidencyisTrueAndAccurate,
                          onChanged: (value) {
                            setState(() {
                              userConfirmsTaxResidencyisTrueAndAccurate =
                                  value!;
                            });
                          }),
                      const Flexible(
                        child: Text(
                          'I confirm above tax residency and US self-declaration is true and accurate.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                ExpatrioButton(
                    text: 'Update',
                    onPressed: () {
                      handleClickUpdate();
                    }),
              ]),
        ),
      ),
    );
  }
}
