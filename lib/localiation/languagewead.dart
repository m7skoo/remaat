import 'package:flutter/material.dart';
import 'package:remaat/localiation/language.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/main.dart';

class LanguagePickerWidget extends StatefulWidget {
  final double width;

  const LanguagePickerWidget({Key? key, required this.width}) : super(key: key);

  @override
  State<LanguagePickerWidget> createState() => _LanguagePickerWidgetState();
}

class _LanguagePickerWidgetState extends State<LanguagePickerWidget> {
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
            color: Colors.white, style: BorderStyle.solid, width: 0.80),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isDense: true,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text(
              getlang(context, 'language'),
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            borderRadius: BorderRadius.circular(18),
            dropdownColor:
                const Color.fromARGB(255, 30, 16, 55).withOpacity(0.9),
            elevation: 0,
            style: const TextStyle(color: Colors.white),

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              lang.flag,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.grey),
                            ),
                          ),
                          Text(
                            lang.name,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ])))
                .toList(),
            // onChanged: (_) {},
          ),
        ),
      ),
    );
  }
}
