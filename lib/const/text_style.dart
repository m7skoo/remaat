import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget normalText({
  String? text,
  Color? color,
  double? size,
}) {
  return Text(
    text!,
    style: TextStyle(
      fontFamily: "quick_semi",
      fontSize: size,
      color: color,
    ),
  );
}

Widget headingText({
  String? text,
  Color? color,
  double? size,
}) {
  return Text(
    text!,
    style: GoogleFonts.tajawal(
      fontSize: size,
      color: color,
    ),
  );
}
