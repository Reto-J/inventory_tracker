import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      side: BorderSide(
        color: Colors.black,
      )
      ),
      color: Colors.white,
      elevation: 2
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w900,
        fontSize: 20
      )
    )
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      side: BorderSide(
        color: Colors.white,
      )
      ),
      color: Colors.black
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w900,
        fontSize: 20,
        fontFamily: 'Consolas'
      )
    )
  );
}