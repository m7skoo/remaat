import 'package:flutter/material.dart';
import 'package:remaat/localiation/language.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/main.dart';
import 'package:remaat/util/design/button_design.dart';
import 'package:remaat/util/design/colors.dart';
import 'package:remaat/util/design/general_design.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  void _changeLanguage(Language language) async {
    Locale temp = await setLocale(language.languageCode);

    // ignore: use_build_context_synchronously
    MyApp.setLoocale(context, temp);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                color: blueColor,
                iconSize: 30,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: logoDesign('assets/images/logo/gradient_logo.png'),
            ),
            const SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    children: <TextSpan>[
                      // TextSpan(text: '* ${"select_Language"}'),
                    ]),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            primaryButton(
                onPressed: (value) {
                  _changeLanguage(value);
                },

                // onPressed: () {
                //   _changeLanguage();
                //   // onLanguageButtonPressed(context, 'ar');
                // },
                txt: 'عربي'),
            const SizedBox(
              height: 20,
            ),
            primaryButton(
                onPressed: (value) {
                  _changeLanguage(value);
                },
                txt: 'English'),
          ],
        ),
      ],
    );
  }
}
