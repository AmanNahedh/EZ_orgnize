import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData getCustomAppTheme() {
  // Define the colors using the Material Design color palette
  const Color primaryColor = Colors.indigo;
  const Color accentColor = Colors.teal;
  final Color? scaffoldBackgroundColor = Colors.grey[100];
  const Color appBarColor = Colors.teal;

  return ThemeData(
    primaryColor: primaryColor,
    hintColor: accentColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    appBarTheme: const AppBarTheme(
      color: appBarColor,
      elevation: 0, systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: Colors.black87,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: accentColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}