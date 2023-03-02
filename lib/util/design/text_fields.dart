import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remaat/util/design/colors.dart';

textFieldDesignWithIcon(
    {obscureText, controller, icon, hintTxt, iconAction, validator}) {
  return TextFormField(
    obscureText: obscureText,
    cursorColor: primaryColor,
    controller: controller,
    validator: validator,
    style: const TextStyle(color: whiteColor),
    decoration: InputDecoration(
        border: InputBorder.none,
        suffixIcon: IconButton(
          splashRadius: 20,
          icon: Icon(
            // Based on passwordVisible state choose the icon
            icon,
            color: Colors.grey,
          ),
          onPressed: iconAction,
        ),
        fillColor: Colors.deepPurple.withOpacity(0.3),
        filled: true,
        hintText: hintTxt,
        hintStyle: GoogleFonts.tajawal(
          color: Colors.white,
          fontSize: 16,
        ),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none)
        // enabledBorder: UnderlineInputBorder(
        //   borderRadius: BorderRadius.circular(12.0),
        //   borderSide: const BorderSide(color: primaryColor),
        // ),
        ),
  );
}

textFieldDesign({obscureText = false, controller, hintTxt, validator}) {
  return TextFormField(
    obscureText: obscureText,
    cursorColor: whiteColor,
    controller: controller,
    validator: validator,
    style: const TextStyle(color: whiteColor),
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.deepPurple.withOpacity(0.3),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(16.0),
        //     borderSide: BorderSide.none),
        border: InputBorder.none,
        hintText: hintTxt,
        hintStyle: GoogleFonts.tajawal(
          color: whiteColor,
          fontSize: 16,
        ),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none)
        // enabledBorder: const UnderlineInputBorder(
        //   borderSide: BorderSide(color: whiteColor),
        // ),
        ),
  );
}

textFieldText(txt) {
  return Text(
    txt,
    style: GoogleFonts.tajawal(
      textStyle: const TextStyle(
        color: accentColor,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
    ),
  );
}
