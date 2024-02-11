import 'package:expatrio_challenge/models/update_tax_data_callback_model.dart';
import 'package:expatrio_challenge/models/user_data_model.dart';
import 'package:expatrio_challenge/providers/current_user_data_provider.dart';
import 'package:expatrio_challenge/providers/current_user_tax_data_provider.dart';
import 'package:expatrio_challenge/widgets/buttons.dart';
import 'package:expatrio_challenge/widgets/tax_identification_number_input.dart';
import 'package:expatrio_challenge/widgets/tax_residence_input.dart';
import 'package:flutter/material.dart';

import '../../models/user_tax_data_model.dart';
import '../../utilities/get_country_based_on_country_code.dart';
import 'country_picker_modal_content.dart';

class TaxDataModalContent extends StatefulWidget {
  final UpdateTaxDataCallback onTapSaveTaxData;
  final CurrentUserDataProvider userDataProvider;
  final CurrentUserTaxDataProvider userTaxDataProvider;

  const TaxDataModalContent(
      {super.key,
      required this.onTapSaveTaxData,
      required this.userDataProvider,
      required this.userTaxDataProvider});

  @override
  TaxDataModalContentState createState() => TaxDataModalContentState();
}

class TaxDataModalContentState extends State<TaxDataModalContent> {
  String? primaryTaxResidenceSelectedCountry;
  late UserDataModel? userData;
  late UserTaxDataModel? userTaxData;
  late TextEditingController primaryTaxIdController;
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
      primaryTaxResidenceSelectedCountry =
          _userTaxData?.primaryTaxResidence.country;
      primaryTaxIdController =
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
      setState(() => primaryTaxResidenceSelectedCountry = result!);
    }
  }

  void handleTapSaveTaxData() {
    setState(() {
      userClickedUpdate = true;
    });
    if (primaryTaxResidenceSelectedCountry != null &&
        primaryTaxIdController.text.isNotEmpty &&
        userConfirmsTaxResidencyisTrueAndAccurate) {
      widget.onTapSaveTaxData(
        primaryTaxResidenceSelectedCountry!,
        primaryTaxIdController.text,
      );
    }
  }

  void handleTapAddAnotherTaxResidency() {}

  @override
  Widget build(BuildContext context) {
    if (userTaxData == null) {
      return const Column(
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }

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
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaxResidenceInput(
                      selectedCountry: primaryTaxResidenceSelectedCountry,
                      onTap: _showCountryPicker,
                      isError: primaryTaxResidenceSelectedCountry == null &&
                          userClickedUpdate,
                    ),
                    const SizedBox(height: 25),
                    TaxIdentificationNumberInput(
                      taxIdController: primaryTaxIdController,
                      taxIdFieldHasError: taxIdFieldHasError,
                      onValueChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            taxIdFieldHasError = true;
                          });
                        } else {
                          setState(() {
                            taxIdFieldHasError = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    userTaxData!.secondaryTaxResidence.isEmpty
                        ? const SizedBox()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                userTaxData?.secondaryTaxResidence.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TaxResidenceInput(
                                    isPrimaryResidence: false,
                                    selectedCountry: userTaxData
                                        ?.secondaryTaxResidence[index].country,
                                    onTap: () {
                                      _showCountryPicker();
                                    },
                                    isError:
                                        primaryTaxResidenceSelectedCountry ==
                                                null &&
                                            userClickedUpdate,
                                  ),
                                  const SizedBox(height: 6),
                                  TaxIdentificationNumberInput(
                                    taxIdController: primaryTaxIdController,
                                    taxIdFieldHasError: taxIdFieldHasError,
                                    onValueChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          taxIdFieldHasError = true;
                                        });
                                      } else {
                                        setState(() {
                                          taxIdFieldHasError = false;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            },
                          ),
                    ExpatrioTextButton(
                      onPressed: () {
                        handleTapAddAnotherTaxResidency();
                      },
                      text: '+ Add another',
                    ),
                  ],
                ),
                //add an 'Add another' button here aligned to the left

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
                    text: 'Save',
                    onPressed: () {
                      handleTapSaveTaxData();
                    }),
              ]),
        ),
      ),
    );
  }
}
