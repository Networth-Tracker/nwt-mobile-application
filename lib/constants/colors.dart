import 'package:flutter/material.dart';

class AppColors {
  // Light Theme
  static const Color lightBackground = Colors.white;
  static const Color lightPrimary = Colors.blue;
  static const Color lightSecondary = Colors.grey;

  static const Color lightTextPrimary = Colors.black;
  static const Color lightTextSecondary = Color.fromRGBO(70, 71, 72, 1);
  static const Color lightTextTertiary = Color.fromRGBO(0, 51, 78, 1);
  static const Color lightTextMuted = Color.fromRGBO(124, 125, 126, 1);
  static const Color lightTextGray = Color.fromRGBO(139, 139, 139, 1);

  static const Color lightButtonPrimaryText = Colors.white;
  static const Color lightButtonPrimaryBackground = Colors.black;
  static const Color lightButtonPrimaryBorder = Colors.black;
  static const Color lightButtonBorder = Color.fromRGBO(230, 230, 230, 1);

  // Exact match to keypad button background
  static const Color lightInputPrimaryBackground = Color.fromRGBO(249, 250, 251, 1);
  static const Color lightInputPrimaryBorder = Color.fromRGBO(0, 0, 0, 0.05);
  static const Color lightInputPrimaryText = Color.fromRGBO(70, 71, 72, 1);

  static const Color lightInputSecondaryBackground = Color.fromRGBO(245, 245, 245, 1);
  static const Color lightInputSecondaryBorder = Color.fromRGBO(255, 255, 255, 0.2); // 0.2 alpha
  static const Color lightInputSecondaryText = Color.fromRGBO(70, 71, 72, 1);

  // Dark Theme
  static const Color darkBackground = Color.fromRGBO(0, 0, 0, 1);
  static const Color darkPrimary = Color.fromRGBO(85, 136, 163, 1);

  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color.fromRGBO(232, 232, 232, 1);
  static const Color darkTextTertiary = Color.fromRGBO(252, 252, 252, 1);
  static const Color darkTextMuted = Color.fromRGBO(124, 125, 126, 1);
  static const Color darkTextGray = Color.fromRGBO(139, 139, 139, 1);

  static const Color darkButtonPrimaryText = Color.fromRGBO(45, 46, 47, 1); // Dark text
  static const Color darkButtonPrimaryBackground = Color.fromRGBO(232, 232, 232, 1); // Light gray background
  static const Color darkButtonPrimaryBorder = Color.fromRGBO(232, 232, 232, 1); // Light gray border

  // These colors match the KeyPad button styling exactly
  // For dark mode, we need to match theme.colorScheme.surface.withValues(alpha: 0.8)
  static const Color darkInputBackground = Color.fromRGBO(30, 30, 30, 0.8);
  static const Color darkInputBorder = Color.fromRGBO(255, 255, 255, 0.1); // Matches white.withValues(alpha: 0.1)
  static const Color darkInputText = Colors.white;
  static const Color darkInputHintText = Color.fromRGBO(255, 255, 255, 0.6);
  static const Color darkButtonBorder = Color.fromRGBO(36, 36, 36, 1);
  static const Color darkRoundedButtonBackground = Color.fromRGBO(12, 12, 12, 1); 
}
