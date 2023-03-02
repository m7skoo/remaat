import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remaat/localiation/language.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/main.dart';

class LanguagePickericon extends StatefulWidget {
  final double width;

  const LanguagePickericon({Key? key, required this.width}) : super(key: key);

  @override
  State<LanguagePickericon> createState() => _LanguagePickericonState();
}

class _LanguagePickericonState extends State<LanguagePickericon> {
  void _changeLanguage(Language language) async {
    Locale temp = await setLocale(language.languageCode);

    // ignore: use_build_context_synchronously
    MyApp.setLoocale(context, temp);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      // padding: const EdgeInsets.all(4),
      height: 40,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: Colors.transparent, style: BorderStyle.solid, width: 0.80),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton(
          isExpanded: true,
          // isDense: false,
          autofocus: false,
          underline: const SizedBox(),
          hint: Text(
            getlang(context, 'language'),
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
          borderRadius: BorderRadius.circular(18),
          dropdownColor: Colors.deepPurple,
          elevation: 0,
          style: GoogleFonts.patuaOne(
              textStyle: const TextStyle(color: Colors.white)),

          icon: const Icon(
            Icons.language,
            color: Colors.white,
          ),
          onChanged: (Language? language) {
            _changeLanguage(language!);
          },
          items: Language.languageList()
              .map((lang) => DropdownMenuItem(
                  value: lang,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            lang.flag,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            lang.name,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ])))
              .toList(),
          // onChanged: (_) {},
        ),
      ),
    );
  }
}
