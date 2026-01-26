import 'package:flutter/material.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/themes/fonts.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: FontTheme().fontFamily,
      textTheme: TextTheme(
        displayLarge: TextStyle(fontFamily: FontTheme().fontFamily),
        displayMedium: TextStyle(fontFamily: FontTheme().fontFamily),
        displaySmall: TextStyle(fontFamily: FontTheme().fontFamily),
        headlineLarge: TextStyle(fontFamily: FontTheme().fontFamily),
        headlineMedium: TextStyle(fontFamily: FontTheme().fontFamily),
        headlineSmall: TextStyle(fontFamily: FontTheme().fontFamily),
        titleLarge: TextStyle(fontFamily: FontTheme().fontFamily),
        titleMedium: TextStyle(fontFamily: FontTheme().fontFamily),
        titleSmall: TextStyle(fontFamily: FontTheme().fontFamily),
        bodyLarge: TextStyle(fontFamily: FontTheme().fontFamily),
        bodyMedium: TextStyle(fontFamily: FontTheme().fontFamily),
        bodySmall: TextStyle(fontFamily: FontTheme().fontFamily),
        labelLarge: TextStyle(fontFamily: FontTheme().fontFamily),
        labelMedium: TextStyle(fontFamily: FontTheme().fontFamily),
        labelSmall: TextStyle(fontFamily: FontTheme().fontFamily),
      ),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: const CardThemeData(
        color: Colors.white,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorTheme.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorTheme.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ColorTheme.primary,
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
        ),
      ),
      chipTheme: const ChipThemeData(
        selectedColor: ColorTheme.primary,
      ),
      canvasColor: Colors.white,
    );
  }
}
