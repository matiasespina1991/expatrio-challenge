import 'package:expatrio_challenge/utilities/get_country_based_on_country_code.dart';
import 'package:flutter/material.dart';

class TaxResidenceInput extends StatelessWidget {
  final String? selectedCountry;
  final VoidCallback onTap;
  final bool isError;
  final String errorMessage;
  final bool isPrimaryResidence;

  const TaxResidenceInput({
    super.key,
    this.selectedCountry,
    required this.onTap,
    this.isError = false,
    this.errorMessage = 'Please choose a country.',
    this.isPrimaryResidence = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isPrimaryResidence
              ? 'Which country serves as your primary tax residence?*'
                  .toUpperCase()
              : 'Do you have other tax residences?*'.toUpperCase(),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isError ? Colors.red : Colors.black54,
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
                      : getCountryBasedOnCountryCode(selectedCountry!),
                  style: TextStyle(color: isError ? Colors.red : Colors.black),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.black),
              ],
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage,
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
