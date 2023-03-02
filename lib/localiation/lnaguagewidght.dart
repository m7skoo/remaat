import '/localiation/language_constants.dart';
import '/main.dart';
import 'language.dart';
import 'package:flutter/material.dart';

class LanguageWidget extends StatefulWidget {
  const LanguageWidget({Key? key}) : super(key: key);

  @override
  State<LanguageWidget> createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  void _changeLanguage(Language language) async {
    Locale temp = await setLocale(language.languageCode);

    // ignore: use_build_context_synchronously
    MyApp.setLoocale(context, temp);
  }

  @override
  Widget build(BuildContext context) {
    // final language = Provider.of<Language>(context);
    return DropdownButton(
      hint: Row(children: [Text(getlang(context, 'languages'))]),
      borderRadius: BorderRadius.circular(18),
      underline: const SizedBox(),
      icon: const Icon(Icons.language),
      onChanged: (Language? language) {
        _changeLanguage(language!);
      },
      items: Language.languageList()
          .map((lang) => DropdownMenuItem(
              value: lang,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(lang.flag),
                    Text(lang.name),
                  ])))
          .toList(),
    );
  }
}
