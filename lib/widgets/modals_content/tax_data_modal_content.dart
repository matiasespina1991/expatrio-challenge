import 'package:expatrio_challenge/models/update_tax_data_callback_model.dart';
import 'package:expatrio_challenge/models/user_data_model.dart';
import 'package:expatrio_challenge/providers/current_user_data_provider.dart';
import 'package:expatrio_challenge/providers/current_user_tax_data_provider.dart';
import 'package:expatrio_challenge/widgets/buttons.dart';
import 'package:expatrio_challenge/widgets/tax_identification_number_input.dart';
import 'package:expatrio_challenge/widgets/tax_residence_input.dart';
import 'package:flutter/material.dart';

import '../../models/user_tax_data_model.dart';
import '../../theme/expatrio_theme.dart';
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
  Map<int, String?> secondaryTaxResidenceSelectedCountry = {};
  late UserDataModel? userData;
  late UserTaxDataModel? userTaxData;
  late TextEditingController primaryTaxIdController;
  late List<TextEditingController> secondaryTaxIdControllers;
  bool userConfirmsTaxResidencyisTrueAndAccurate = false;
  bool userClickedUpdate = false;
  bool primaryTaxIdFieldHasError = false;
  Map<int, bool> secondaryTaxIdFieldHasError = {};

  @override
  void initState() {
    super.initState();
    final UserDataModel? fetchedUserData = widget.userDataProvider.userData;
    final UserTaxDataModel? fetchedUserTaxData =
        widget.userTaxDataProvider.userTaxData;

    setState(() {
      userData = fetchedUserData;
      userTaxData = fetchedUserTaxData;
      primaryTaxResidenceSelectedCountry =
          fetchedUserTaxData?.primaryTaxResidence.country;
      secondaryTaxResidenceSelectedCountry = fetchedUserTaxData
              ?.secondaryTaxResidence
              .asMap()
              .map((index, residence) => MapEntry(index, residence.country)) ??
          {};
      primaryTaxIdController = TextEditingController(
          text: fetchedUserTaxData?.primaryTaxResidence.id);
      secondaryTaxIdControllers = fetchedUserTaxData?.secondaryTaxResidence
              .map((residence) => TextEditingController(text: residence.id))
              .toList() ??
          [];
    });
  }

  void _showCountryForPrimaryResidence() async {
    String? result;
    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => CountryPickerModal(
        omitCountries: [
          ...secondaryTaxResidenceSelectedCountry.entries
              .map((entry) => entry.value)
              .whereType<String>()
        ],
        onCountrySelected: (countrySelected) {
          result = countrySelected;
        },
      ),
    );

    if (result != null) {
      setState(() => primaryTaxResidenceSelectedCountry = result);
    }
  }

  void _showCountryPickerForSecondaryResidence(index) async {
    String? result;
    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => CountryPickerModal(
        omitCountries: [
          primaryTaxResidenceSelectedCountry,
          ...secondaryTaxResidenceSelectedCountry.entries
              .where((entry) => entry.key != index) //
              .map((entry) => entry.value)
              .whereType<String>()
        ],
        onCountrySelected: (countrySelected) {
          result = countrySelected;
        },
      ),
    );

    if (result != null) {
      setState(() => secondaryTaxResidenceSelectedCountry[index] = result);
    }
  }

  void handleTapSaveTaxData() {
    setState(() {
      userClickedUpdate = true;
    });
    if (primaryTaxResidenceSelectedCountry != null &&
        primaryTaxIdController.text.isNotEmpty &&
        secondaryTaxResidenceSelectedCountry.values
            .every((element) => element != null) &&
        secondaryTaxIdControllers
            .every((controller) => controller.text.isNotEmpty) &&
        userConfirmsTaxResidencyisTrueAndAccurate) {
      widget.onTapSaveTaxData(
        primaryTaxResidenceSelectedCountry!,
        primaryTaxIdController.text,
        secondaryTaxResidenceSelectedCountry,
        secondaryTaxIdControllers,
      );
    }
  }

  void handleTapAddAnotherTaxResidency() {
    setState(() {
      userTaxData?.secondaryTaxResidence.add(
        TaxResidenceModel(
          country: null,
          id: null,
        ),
      );
      secondaryTaxIdControllers.add(TextEditingController());
    });
  }

  void reindexSecondaryTaxResidenceSelectedCountry() {
    final newMap = <int, String?>{};
    int newIndex = 0;
    secondaryTaxResidenceSelectedCountry.forEach((key, value) {
      newMap[newIndex++] = value;
    });
    setState(() {
      secondaryTaxResidenceSelectedCountry = newMap;
    });
  }

  void handleTapRemoveTaxResidency(int index) {
    setState(() {
      userTaxData?.secondaryTaxResidence.removeWhere((taxResidence) =>
          taxResidence.country == secondaryTaxResidenceSelectedCountry[index]);
      secondaryTaxIdControllers.removeAt(index);
      secondaryTaxResidenceSelectedCountry.remove(index);
      reindexSecondaryTaxResidenceSelectedCountry();
    });
  }

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
                      onTap: _showCountryForPrimaryResidence,
                      isError: primaryTaxResidenceSelectedCountry == null &&
                          userClickedUpdate,
                    ),
                    const SizedBox(height: 25),
                    TaxIdentificationNumberInput(
                      taxIdController: primaryTaxIdController,
                      taxIdFieldHasError: primaryTaxIdFieldHasError,
                      onValueChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            primaryTaxIdFieldHasError = true;
                          });
                        } else {
                          setState(() {
                            primaryTaxIdFieldHasError = false;
                          });
                        }
                      },
                    ),

                    /// SECONDARY TAX RESIDENCES
                    userTaxData!.secondaryTaxResidence.isEmpty
                        ? const SizedBox()
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                userTaxData?.secondaryTaxResidence.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 22,
                                  ),
                                  TaxResidenceInput(
                                    isPrimaryResidence: false,
                                    selectedCountry:
                                        secondaryTaxResidenceSelectedCountry[
                                            index],
                                    onTap: () {
                                      _showCountryPickerForSecondaryResidence(
                                          index);
                                    },
                                    isError:
                                        secondaryTaxResidenceSelectedCountry[
                                                    index] ==
                                                null &&
                                            userClickedUpdate,
                                  ),
                                  const SizedBox(height: 22),
                                  TaxIdentificationNumberInput(
                                    taxIdController:
                                        secondaryTaxIdControllers[index],
                                    taxIdFieldHasError: userClickedUpdate &&
                                            secondaryTaxIdControllers[index]
                                                .text
                                                .isEmpty ||
                                        (secondaryTaxIdFieldHasError[index] ??
                                            false),
                                    onValueChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          secondaryTaxIdFieldHasError[index] =
                                              true;
                                        });
                                      } else {
                                        setState(() {
                                          secondaryTaxIdFieldHasError[index] =
                                              false;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ExpatrioTextButton(
                                      color: ExpatrioTheme.errorColor,
                                      onPressed: () {
                                        handleTapRemoveTaxResidency(index);
                                      },
                                      text: '- remove',
                                    ),
                                  ),
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
                const SizedBox(height: 60)
              ]),
        ),
      ),
    );
  }
}
