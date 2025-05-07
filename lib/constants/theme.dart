import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.lightPrimary,
    
    // Make sure to use ColorScheme to properly handle theme transitions
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      background: AppColors.lightBackground,
    ),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: Colors.black12,
      selectionHandleColor: Colors.black54,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
      bodySmall: TextStyle(color: AppColors.lightTextTertiary),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      fillColor: AppColors.lightInputPrimaryBackground,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightInputPrimaryBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightPrimary),
      ),
      hintStyle: TextStyle(color: AppColors.lightInputPrimaryText),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightButtonPrimaryBackground,
        foregroundColor: AppColors.lightButtonPrimaryText,
        side: const BorderSide(color: AppColors.lightButtonPrimaryBorder),
      ),
    ),

    // Add extension data to store our custom text colors
    extensions: <ThemeExtension<dynamic>>[
      AppTextThemeColors.light,
    ],
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.darkPrimary,
    
    // Make sure to use ColorScheme to properly handle theme transitions
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      background: AppColors.darkBackground,
    ),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.white24,
      selectionHandleColor: Colors.white70,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
      bodySmall: TextStyle(color: AppColors.darkTextTertiary),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      fillColor: AppColors.darkInputBackground,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkInputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkPrimary),
      ),
      hintStyle: TextStyle(color: AppColors.darkInputText),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkButtonPrimaryBackground,
        foregroundColor: AppColors.darkButtonPrimaryText,
        side: const BorderSide(color: AppColors.darkButtonPrimaryBorder),
      ),
    ),

    // Add extension data to store our custom text colors
    extensions: <ThemeExtension<dynamic>>[
      AppTextThemeColors.dark,
    ],
  );
}

// Theme extension to properly handle text colors in theme changes
class AppTextThemeColors extends ThemeExtension<AppTextThemeColors> {
  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color mutedText;
  final Color buttonText;

  const AppTextThemeColors({
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.mutedText,
    required this.buttonText,
  });

  // Light theme text colors
  static const light = AppTextThemeColors(
    primaryText: AppColors.lightTextPrimary,
    secondaryText: AppColors.lightTextSecondary,
    tertiaryText: AppColors.lightTextTertiary,
    mutedText: AppColors.lightTextMuted,
    buttonText: AppColors.lightButtonPrimaryText,
  );

  // Dark theme text colors
  static const dark = AppTextThemeColors(
    primaryText: AppColors.darkTextPrimary,
    secondaryText: AppColors.darkTextSecondary,
    tertiaryText: AppColors.darkTextTertiary,
    mutedText: AppColors.darkTextMuted,
    buttonText: AppColors.darkButtonPrimaryText,
  );

  @override
  ThemeExtension<AppTextThemeColors> copyWith({
    Color? primaryText,
    Color? secondaryText,
    Color? tertiaryText,
    Color? mutedText,
    Color? buttonText,
  }) {
    return AppTextThemeColors(
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      tertiaryText: tertiaryText ?? this.tertiaryText,
      mutedText: mutedText ?? this.mutedText,
      buttonText: buttonText ?? this.buttonText,
    );
  }

  @override
  ThemeExtension<AppTextThemeColors> lerp(
    covariant ThemeExtension<AppTextThemeColors>? other,
    double t,
  ) {
    if (other is! AppTextThemeColors) {
      return this;
    }
    return AppTextThemeColors(
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      tertiaryText: Color.lerp(tertiaryText, other.tertiaryText, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      buttonText: Color.lerp(buttonText, other.buttonText, t)!,
    );
  }
}

// Helper extension to get theme colors
extension AppTextThemeColorsExtension on BuildContext {
  AppTextThemeColors get textThemeColors => 
      Theme.of(this).extension<AppTextThemeColors>() ?? AppTextThemeColors.light;
}