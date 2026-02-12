import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.grey,
      primary: Colors.deepPurple,
      secondary: Colors.green.shade400,

    )
);

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Colors.black,
      primary: Colors.deepPurple,
      secondary: Colors.green.shade400,

    )
);
