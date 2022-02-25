import 'package:expense_tracker_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Themes {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(backgroundColor: Colors.white));

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      primarySwatch: Colors.deepPurple,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black);
}
