import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remaat/util/design/colors.dart';

Widget logoDesign(txt) {
  return Center(
    child: SizedBox(
      height: 180,
      width: 180,
      child: Image.asset(
        txt,
        fit: BoxFit.contain,
      ),
    ),
  );
}

/////////////////////////////

Widget centerLabel(txt) {
  return Center(
    child: Text(
      txt,
      style: GoogleFonts.josefinSans(
        textStyle: const TextStyle(
          color: accentColor,
          fontWeight: FontWeight.w900,
          fontSize: 34,
        ),
      ),
    ),
  );
}
