class CountryList {
  final String name;
  final String codeName;

  CountryList({required this.name, required this.codeName});

  factory CountryList.fromMap(Map<String, String> map) {
    return CountryList(
      name: map['name']!,
      codeName: map['codeName']!,
    );
  }
}
