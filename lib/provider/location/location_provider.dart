import 'package:flutter/material.dart';

class LocationProvider extends ChangeNotifier {
  int _selectedCountry = 2;

  final List<CountryName> _countryNameList = [
    CountryName.nepal,
    CountryName.usa,
    CountryName.india,
    CountryName.sriLanka,
    CountryName.england,
    CountryName.sweden,
    CountryName.pacificIsland
  ];

  int get selectedCountry => _selectedCountry;

  List<CountryName> get countryNameList => _countryNameList;

  String get fetchCountryName => _countryNameList[_selectedCountry].displayText;

  void setCountry(int selected) {
    _selectedCountry = selected;
    notifyListeners();
  }
}

enum CountryName { nepal, usa, india, sriLanka, england, sweden, pacificIsland }

extension ParseStringForCountry on CountryName {
  String get text {
    return toString().split('.').last;
  }

  String get displayText {
    switch (this) {
      case CountryName.nepal:
        return "Nepal";
      case CountryName.usa:
        return "USA";
      case CountryName.india:
        return "India";
      case CountryName.sriLanka:
        return "Relevancy";
      case CountryName.england:
        return "Sri Lanka";
      case CountryName.sweden:
        return "Sweden";
      case CountryName.pacificIsland:
        return "Pacific Island";
      default:
        return "Others";
    }
  }
}
