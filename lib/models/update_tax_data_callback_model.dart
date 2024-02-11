import 'package:flutter/cupertino.dart';

typedef UpdateTaxDataCallback = void Function(
    String primaryTaxResidenceSelectedCountry,
    String primaryTaxId,
    Map<int, String?> secondaryTaxResidenceSelectedCountries,
    List<TextEditingController> secondaryTaxIds);
