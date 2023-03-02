import 'package:flutter/material.dart';

import 'colors.dart';

appBarDesignWithAction(txt, icon, iconAction, isort) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.deepPurple),
    title: Text(
      txt,
      style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
    ),
    // iconTheme: const IconThemeData(color: Color.fromARGB(255, 36, 98, 149)),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: accentColor,
          child: IconButton(
              onPressed: iconAction,
              icon: Icon(
                icon,
                color: sideBarColor,
              )),
        ),
      ),
      IconButton(
          onPressed: isort,
          icon: const Icon(
            Icons.sort,
            color: Colors.white,
          ))
    ],
  );
}

appBarDesign(txt) {
  return AppBar(
    title: Text(
      txt,
      style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
    ),
    // iconTheme: const IconThemeData(color: Color.fromARGB(255, 36, 98, 149)),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

roundedCornerAppBar(txt) {
  return AppBar(
    shape: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
        borderSide: BorderSide.none),
    title: Text(txt),
    backgroundColor: primaryColor,
  );
}
