import 'package:expatrio_challenge/theme/expatrio_theme.dart';
import 'package:flutter/material.dart';

import '../../data/countries_list.dart';
import '../../models/country_list_model.dart';

class CountryPickerModal extends StatefulWidget {
  final Function(String) onCountrySelected;
  const CountryPickerModal({super.key, required this.onCountrySelected});

  @override
  CountryPickerModalState createState() => CountryPickerModalState();
}

class CountryPickerModalState extends State<CountryPickerModal> {
  final List<CountryList> countries =
      countriesList.map((map) => CountryList.fromMap(map)).toList();

  List<CountryList> filteredCountries = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredCountries = countries;
  }

  void _filterCountries(String query) {
    setState(() {
      searchQuery = query;
      filteredCountries = countries
          .where((country) =>
              country.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  void handleSelectedCountry(index) {
    String countrySelected = filteredCountries[index].codeName;

    widget.onCountrySelected(countrySelected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      expand: false,
      builder: (_, controller) {
        return Column(
          children: [
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: ExpatrioTheme.primaryColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(27),
                ),
              ),
              child: const Center(
                child: Text(
                  'Country',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                onChanged: _filterCountries,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Search for a country',
                  hintStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount:
                    filteredCountries.isEmpty ? 1 : filteredCountries.length,
                itemBuilder: (context, index) {
                  if (filteredCountries.isEmpty) {
                    return const ListTile(
                        title: Text('No coincidences found...'));
                  }
                  return ListTile(
                    title: Text(filteredCountries[index].name),
                    onTap: () => handleSelectedCountry(index),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
