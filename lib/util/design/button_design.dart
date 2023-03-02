import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

primaryButton({onPressed, txt}) {
  return Container(
    width: double.infinity,
    height: 50,
    decoration: const BoxDecoration(
      // color: primaryColor,
      gradient: lightGradient,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: TextButton(
      onPressed: onPressed,
      child: Text(
        txt,
        maxLines: 1,
        style: GoogleFonts.tajawal(
          color: primaryColor,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    ),
  );
}
