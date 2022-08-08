import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
      ));

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme(
          primary: Color.fromRGBO(253, 216, 53, 1),
          background: Color.fromRGBO(253, 216, 53, 1),
          brightness: Brightness.dark,
          error: Color.fromARGB(255, 253, 53, 113),
          onBackground: Color.fromRGBO(253, 216, 53, 1),
          onError: Color.fromRGBO(0, 0, 0, 1),
          onPrimary: Color.fromRGBO(0, 0, 0, 1),
          onSecondary: Color.fromRGBO(253, 216, 53, 1),
          onSurface: Color.fromRGBO(253, 216, 53, 1),
          secondary: Color.fromRGBO(253, 216, 53, 1),
          surface: Color.fromRGBO(253, 216, 53, 1)),
      primaryColor: Colors.yellow[600],
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: Colors.yellow[600])),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
      ));
}
