import '/localiation/demo_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getlang(BuildContext context, String key) {
  return DemoLocalization.of(context)!.translate(key);
}

// ignore: constant_identifier_names
const String LAGUAGE_CODE = 'languageCode';
// ignore: constant_identifier_names
const String ENGLISH = "en";
// ignore: constant_identifier_names
const String ARABIC = 'ar';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(LAGUAGE_CODE) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');

    case ARABIC:
      return const Locale(ARABIC, "SA");

    default:
      return const Locale(ARABIC, 'SA');
  }
}
