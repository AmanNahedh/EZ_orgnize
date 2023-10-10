import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData getCustomAppTheme() {
  // Define the colors using the Material Design color palette
  final Color primaryColor = Colors.indigo;
  final Color accentColor = Colors.teal;
  final Color? scaffoldBackgroundColor = Colors.grey[100];
  final Color appBarColor = Colors.teal;

  return ThemeData(
    primaryColor: primaryColor,
    hintColor: accentColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    appBarTheme: AppBarTheme(
      color: appBarColor,
      elevation: 0, systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(
        color: Colors.black87,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: accentColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}