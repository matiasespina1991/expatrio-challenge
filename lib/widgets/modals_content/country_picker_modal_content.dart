import 'package:flutter/material.dart';

import '../../data/countries_list.dart';

class CountryPickerModal extends StatefulWidget {
  final Function(String) onCountrySelected;
  const CountryPickerModal({super.key, required this.onCountrySelected});

  @override
  CountryPickerModalState createState() => CountryPickerModalState();
}

class CountryPickerModalState extends State<CountryPickerModal> {
  List<String> countries = [...countriesList];
  List<String> filteredCountries = [];
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
              country.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (_, controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                onChanged: _filterCountries,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
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
                    title: Text(filteredCountries[index]),
                    onTap: () {
                      widget.onCountrySelected(filteredCountries[index]);
                      Navigator.pop(context);
                    },
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
