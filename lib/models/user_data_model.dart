class UserDataModel {
  final int id;
  final String dateOfBirth;
  final String title;
  final String firstName;
  final String profession;
  final String lastName;
  final String nationality;
  final String emailAddress;
  final String beginOfStudy;
  final String phoneCountryCode;
  final String phoneNumber;
  final String birthPlace;
  final String birthCountry;
  final AddressModel germanAddress;
  final AddressModel foreignAddress;
  final String arrivalInGermany;
  final String universityName;
  final String universityCampus;
  final String specialization;
  final bool taxDataUpdatable;
  final bool newTaxDataUpdatable;
  final bool showAdditionalQuestions;
  final bool showInterestMajor;

  UserDataModel({
    required this.id,
    required this.dateOfBirth,
    required this.title,
    required this.firstName,
    required this.profession,
    required this.lastName,
    required this.nationality,
    required this.emailAddress,
    required this.beginOfStudy,
    required this.phoneCountryCode,
    required this.phoneNumber,
    required this.birthPlace,
    required this.birthCountry,
    required this.germanAddress,
    required this.foreignAddress,
    required this.arrivalInGermany,
    required this.universityName,
    required this.universityCampus,
    required this.specialization,
    required this.taxDataUpdatable,
    required this.newTaxDataUpdatable,
    required this.showAdditionalQuestions,
    required this.showInterestMajor,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id'],
      dateOfBirth: json['dateOfBirth'],
      title: json['title'],
      firstName: json['firstName'],
      profession: json['profession'],
      lastName: json['lastName'],
      nationality: json['nationality'],
      emailAddress: json['emailAddress'],
      beginOfStudy: json['beginOfStudy'],
      phoneCountryCode: json['phoneCountryCode'],
      phoneNumber: json['phoneNumber'],
      birthPlace: json['birthPlace'],
      birthCountry: json['birthCountry'],
      germanAddress: AddressModel.fromJson(json['germanAddress']),
      foreignAddress: AddressModel.fromJson(json['foreignAddress']),
      arrivalInGermany: json['arrivalInGermany'],
      universityName: json['universityName'],
      universityCampus: json['universityCampus'],
      specialization: json['specialization'],
      taxDataUpdatable: json['taxDataUpdatable'],
      newTaxDataUpdatable: json['newTaxDataUpdatable'],
      showAdditionalQuestions: json['showAdditionalQuestions'],
      showInterestMajor: json['showInterestMajor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateOfBirth': dateOfBirth,
      'title': title,
      'firstName': firstName,
      'profession': profession,
      'lastName': lastName,
      'nationality': nationality,
      'emailAddress': emailAddress,
      'beginOfStudy': beginOfStudy,
      'phoneCountryCode': phoneCountryCode,
      'phoneNumber': phoneNumber,
      'birthPlace': birthPlace,
      'birthCountry': birthCountry,
      'germanAddress': germanAddress.toJson(),
      'foreignAddress': foreignAddress.toJson(),
      'arrivalInGermany': arrivalInGermany,
      'universityName': universityName,
      'universityCampus': universityCampus,
      'specialization': specialization,
      'taxDataUpdatable': taxDataUpdatable,
      'newTaxDataUpdatable': newTaxDataUpdatable,
      'showAdditionalQuestions': showAdditionalQuestions,
      'showInterestMajor': showInterestMajor,
    };
  }
}

class AddressModel {
  final String streetName;
  final String streetNumber;
  final String postalCode;
  final String city;
  final String coAddress;
  final String countryCode;
  final String state;
  final String province;
  final String district;

  AddressModel({
    required this.streetName,
    required this.streetNumber,
    required this.postalCode,
    required this.city,
    required this.coAddress,
    required this.countryCode,
    required this.state,
    required this.province,
    required this.district,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      streetName: json['streetName'],
      streetNumber: json['streetNumber'],
      postalCode: json['postalCode'],
      city: json['city'],
      coAddress: json['coAddress'],
      countryCode: json['countryCode'],
      state: json['state'],
      province: json['province'],
      district: json['district'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'streetName': streetName,
      'streetNumber': streetNumber,
      'postalCode': postalCode,
      'city': city,
      'coAddress': coAddress,
      'countryCode': countryCode,
      'state': state,
      'province': province,
      'district': district,
    };
  }
}
