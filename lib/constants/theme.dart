import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';

class AppTheme {
    /// Defines the light theme for the application, specifying colors, typography, 
    /// and component styles. This theme includes settings for app bar, text selection,
    /// text styles, input decoration, and button themes, ensuring a cohesive and 
    /// visually appealing design across the app in light mode.
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.lightPrimary,
    fontFamily: 'Poppins',

    // Make sure to use ColorScheme to properly handle theme transitions
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightBackground,
    ),

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
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

    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.lightInputPrimaryBackground, // Exact match to keypad
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppColors.lightInputPrimaryBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppColors.lightInputPrimaryBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppColors.lightPrimary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.lightInputPrimaryText, fontSize: 16, fontWeight: FontWeight.w400),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightButtonPrimaryBackground,
        foregroundColor: AppColors.lightButtonPrimaryText,
        side: const BorderSide(color: AppColors.lightButtonPrimaryBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    ),

    // Add extension data to store our custom text colors
    extensions: <ThemeExtension<dynamic>>[AppTextThemeColors.light],
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.darkPrimary,
    fontFamily: 'Poppins',

    // Make sure to use ColorScheme to properly handle theme transitions
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      surface: AppColors.darkBackground,
    ),

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
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

    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.darkInputBackground, // Matches surface.withValues(alpha: 0.8)
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppColors.darkInputBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppColors.darkInputBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppColors.darkPrimary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.darkInputHintText, fontSize: 16, fontWeight: FontWeight.w400),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkButtonPrimaryBackground,
        foregroundColor: AppColors.darkButtonPrimaryText,
        side: const BorderSide(color: AppColors.darkButtonPrimaryBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    ),

    // Add extension data to store our custom text colors
    extensions: <ThemeExtension<dynamic>>[AppTextThemeColors.dark],
  );
}

// Theme extension to properly handle text colors in theme changes
class AppTextThemeColors extends ThemeExtension<AppTextThemeColors> {
  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color mutedText;
  final Color grayText;
  final Color buttonText;

  const AppTextThemeColors({
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.mutedText,
    required this.grayText,
    required this.buttonText,
  });

  // Light theme text colors
  static const light = AppTextThemeColors(
    primaryText: AppColors.lightTextPrimary,
    secondaryText: AppColors.lightTextSecondary,
    tertiaryText: AppColors.lightTextTertiary,
    mutedText: AppColors.lightTextMuted,
    grayText: AppColors.lightTextGray,
    buttonText: AppColors.lightButtonPrimaryText,
  );

  // Dark theme text colors
  static const dark = AppTextThemeColors(
    primaryText: AppColors.darkTextPrimary,
    secondaryText: AppColors.darkTextSecondary,
    tertiaryText: AppColors.darkTextTertiary,
    mutedText: AppColors.darkTextMuted,
    grayText: AppColors.darkTextGray,
    buttonText: AppColors.darkButtonPrimaryText,
  );

  @override
  ThemeExtension<AppTextThemeColors> copyWith({
    Color? primaryText,
    Color? secondaryText,
    Color? tertiaryText,
    Color? mutedText,
    Color? grayText,
    Color? buttonText,
  }) {
    return AppTextThemeColors(
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      tertiaryText: tertiaryText ?? this.tertiaryText,
      mutedText: mutedText ?? this.mutedText,
      grayText: grayText ?? this.grayText,
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
      grayText: Color.lerp(grayText, other.grayText, t)!,
      buttonText: Color.lerp(buttonText, other.buttonText, t)!,
    );
  }
}

// Helper extension to get theme colors
extension AppTextThemeColorsExtension on BuildContext {
  AppTextThemeColors get textThemeColors =>
      Theme.of(this).extension<AppTextThemeColors>() ??
      AppTextThemeColors.light;
}
