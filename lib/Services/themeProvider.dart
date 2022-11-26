import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class DarkThemeProvider with ChangeNotifier {
//   DarkThemePreference darkThemePreference = DarkThemePreference();
//   bool _darkTheme = false;

//   bool get darkTheme => _darkTheme;

//   set darkTheme(bool value) {
//     _darkTheme = value;
//     darkThemePreference.setDarkTheme(value);
//     notifyListeners();
//   }
// }

class LanguageThemeProvider with ChangeNotifier {
  LanguagePreference languagePreference = LanguagePreference();
  bool _languageTheme = false;

  bool get languageTheme => _languageTheme;

  set languageTheme(bool value) {
    _languageTheme = value;
    languagePreference.setLanguage(value);
    notifyListeners();
  }
}

class LanguagePreference {
  static const LANGUAGE_STATUS = "LANGUAGESTATUS";

  setLanguage(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(LANGUAGE_STATUS, value);
  }

  Future<bool> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(LANGUAGE_STATUS) ?? false;
  }
}
