import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightTheme['base']!['background'] as Color,
    primaryColor: AppColors.lightTheme['base']!['primary'] as Color,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.lightTheme['text']!['primary'] as Color,
      ),
      bodyMedium: TextStyle(
        color: AppColors.lightTheme['text']!['secondary'] as Color,
      ),
      bodySmall: TextStyle(
        color: AppColors.lightTheme['text']!['tertiary'] as Color,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.lightTheme['input']!['primary']!['background'] as Color,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.lightTheme['input']!['primary']!['border'] as Color,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.lightTheme['base']!['primary'] as Color,
        ),
      ),
      hintStyle: TextStyle(
        color: AppColors.lightTheme['input']!['primary']!['text'] as Color,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightTheme['button']!['primary']!['background'] as Color,
        foregroundColor: AppColors.lightTheme['button']!['primary']!['text'] as Color,
        side: BorderSide(
          color: AppColors.lightTheme['button']!['primary']!['border'] as Color,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkTheme['base']!['background'] as Color,
    primaryColor: AppColors.darkTheme['base']!['primary'] as Color,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.darkTheme['text']!['primary'] as Color,
      ),
      bodyMedium: TextStyle(
        color: AppColors.darkTheme['text']!['secondary'] as Color,
      ),
      bodySmall: TextStyle(
        color: AppColors.darkTheme['text']!['tertiary'] as Color,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.darkTheme['input']!['background'] as Color,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.darkTheme['input']!['border'] as Color,
        ),
      ),
      hintStyle: TextStyle(
        color: AppColors.darkTheme['input']!['text'] as Color,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkTheme['button']!['primary']!['background'] as Color,
        foregroundColor: AppColors.darkTheme['button']!['primary']!['text'] as Color,
        side: BorderSide(
          color: AppColors.darkTheme['button']!['primary']!['border'] as Color,
        ),
      ),
    ),
  );
}
