import 'package:flutter/material.dart';
import 'package:bisonte_app/core/constants.dart';

ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: Constants.appFont,
  useMaterial3: true,
  scaffoldBackgroundColor: Constants.scaffoldColor,
  cardColor: Constants.cardColor,
  primaryColor: Constants.indicatorColor,
  indicatorColor: Constants.indicatorColor,
  colorScheme: const ColorScheme.dark().copyWith(
    primary: Constants.indicatorColor,
    secondary: Constants.indicatorColor,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Constants.scaffoldColor,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
  ),
);



// OLD THEME

// ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   fontFamily: _appFont,
//   useMaterial3: true,
//   scaffoldBackgroundColor: const Color(0XFFf8f9fe),
//   primaryColor: Colors.black,
//   indicatorColor: const Color(0XFFB8860B),
//   colorScheme: const ColorScheme.light().copyWith(
//     primary: Colors.black,
//     secondary: const Color(0XFFB8860B),
//   ),
// );

// ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   fontFamily: _appFont,
//   useMaterial3: true,
//   scaffoldBackgroundColor: const Color(0XFFf8f9fe),
//   primaryColor: Colors.black,
// );
