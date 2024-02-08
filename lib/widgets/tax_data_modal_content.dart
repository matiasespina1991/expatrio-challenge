import 'package:flutter/material.dart';

import '../data/countries_list.dart';
import 'country_picker_modal_content.dart';

class TaxDataModalContent extends StatefulWidget {
  final VoidCallback onTapConfirm;

  const TaxDataModalContent({super.key, required this.onTapConfirm});

  @override
  TaxDataModalContentState createState() => TaxDataModalContentState();
}

class TaxDataModalContentState extends State<TaxDataModalContent> {
  String selectedCountry = 'Choose a country...';

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
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 20),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              // Resto del contenido
              Text('Which country serves as your primary tax residence?*'),
              InkWell(
                onTap: _showCountryPicker,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedCountry),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Continúa con los otros elementos como el número de identificación fiscal
            ],
          ),
        ),
      ),
    );
  }
}
