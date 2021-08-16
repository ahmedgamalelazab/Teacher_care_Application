// in this file we will create the application light theme and dark theme

import 'package:flutter/material.dart';

class ApplicationThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xff283C63),
    colorScheme: ColorScheme.dark(),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xffffffff),
    colorScheme: ColorScheme.light(),
  );
}
