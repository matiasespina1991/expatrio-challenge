import 'package:expatrio_challenge/models/country_list_model.dart';

import '../shared/countries_list.dart';

String getCountryBasedOnCountryCode(String code) {
  List<CountryList> countries =
      countriesList.map((map) => CountryList.fromMap(map)).toList();

  return countries.firstWhere((country) => country.codeName == code).name;
}
