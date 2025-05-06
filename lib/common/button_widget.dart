import 'package:flutter/material.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outlined,
  text,
  destructive,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isFullWidth;
  final bool isDisabled;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? customBorderRadius;
  final EdgeInsets? customPadding;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isFullWidth = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.customBorderRadius,
    this.customPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Get button styles based on variant
    final buttonStyle = _getButtonStyle(context);
    
    // Get padding based on size
    final buttonPadding = customPadding ?? _getButtonPadding();
    
    // Get border radius
    final borderRadius = customBorderRadius ?? 8.0;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonStyle.backgroundColor,
          foregroundColor: buttonStyle.textColor,
          disabledBackgroundColor: isDarkMode 
              ? Colors.grey.shade800
              : Colors.grey.shade300,
          disabledForegroundColor: isDarkMode
              ? Colors.grey.shade500
              : Colors.grey.shade500,
          padding: buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: buttonStyle.borderColor,
              width: buttonStyle.variant == AppButtonVariant.outlined ? 2.0 : 1.0,
            ),
          ),
          elevation: buttonStyle.variant == AppButtonVariant.text ? 0 : 0,
        ),
        onPressed: isDisabled ? null : onPressed,
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: _getIconSize()),
              SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: isDisabled
                    ? (isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600)
                    : buttonStyle.textColor,
                fontWeight: FontWeight.w600,
                fontSize: _getTextSize(),
              ),
            ),
            if (trailingIcon != null) ...[
              SizedBox(width: 8),
              Icon(trailingIcon, size: _getIconSize()),
            ],
          ],
        ),
      ),
    );
  }

  // Get button padding based on size
  EdgeInsets _getButtonPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24.0, vertical: .0);
    }
  }

  // Get text size based on button size
  double _getTextSize() {
    switch (size) {
      case AppButtonSize.small:
        return 14.0;
      case AppButtonSize.medium:
        return 16.0;
      case AppButtonSize.large:
        return 16.0;
    }
  }

  // Get icon size based on button size
  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16.0;
      case AppButtonSize.medium:
        return 20.0;
      case AppButtonSize.large:
        return 24.0;
    }
  }

  // Get button style based on variant and theme
  _ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    if (isDarkMode) {
      // Dark theme styles
      final colors = _getDarkThemeColors(context);
      switch (variant) {
        case AppButtonVariant.primary:
          return _ButtonStyle(
            variant: variant,
            backgroundColor: colors.primary,
            textColor: Colors.white,
            borderColor: colors.primary,
          );
        case AppButtonVariant.secondary:
          return _ButtonStyle(
            variant: variant,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            borderColor: Colors.white.withAlpha(51),
          );
        case AppButtonVariant.outlined:
          return _ButtonStyle(
            variant: variant,
            backgroundColor: Colors.transparent,
            textColor: colors.primary,
            borderColor: colors.primary,
          );
        case AppButtonVariant.text:
          return _ButtonStyle(
            variant: variant,
            backgroundColor: Colors.transparent,
            textColor: colors.primary,
            borderColor: Colors.transparent,
          );
        case AppButtonVariant.destructive:
          return _ButtonStyle(
            variant: variant,
            backgroundColor: Colors.red.shade800,
            textColor: Colors.white,
            borderColor: Colors.red.shade800,
          );
      }
    } else {
      // Light theme styles
      final colors = _getLightThemeColors(context);
      switch (variant) {
        case AppButtonVariant.primary:
          return _ButtonStyle(
            variant: variant,
            backgroundColor: colors.primary,
            textColor: Colors.white,
            borderColor: colors.primary,
          );
        case AppButtonVariant.secondary:
          return _ButtonStyle(
            variant: variant,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            borderColor: colors.border,
          );
        case AppButtonVariant.outlined:
          return _ButtonStyle(
            variant: variant,
            backgroundColor: Colors.transparent,
            textColor: colors.primary,
            borderColor: colors.primary,
          );
        case AppButtonVariant.text:
          return _ButtonStyle(
            variant: variant,
            backgroundColor: Colors.transparent,
            textColor: colors.primary,
            borderColor: Colors.transparent,
          );
        case AppButtonVariant.destructive:
          return _ButtonStyle(
            variant: variant,
            backgroundColor: Colors.red.shade600,
            textColor: Colors.white,
            borderColor: Colors.red.shade600,
          );
      }
    }
  }

  // Light theme color helper
  _ThemeColors _getLightThemeColors(BuildContext context) {
    final theme = Theme.of(context);
    
    return _ThemeColors(
      primary: theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? Colors.black,
      text: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}) ?? Colors.white,
      border: theme.elevatedButtonTheme.style?.side?.resolve({})?.color ?? 
        const Color.fromRGBO(197, 201, 208, 1),
    );
  }

  // Dark theme color helper
  _ThemeColors _getDarkThemeColors(BuildContext context) {
    final theme = Theme.of(context);
    
    return _ThemeColors(
      primary: theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? 
        const Color.fromRGBO(45, 55, 119, 1),
      text: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}) ?? Colors.white,
      border: theme.elevatedButtonTheme.style?.side?.resolve({})?.color ?? Colors.white.withAlpha(51),
    );
  }
}

// Helper class for button styles
class _ButtonStyle {
  final AppButtonVariant variant;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  _ButtonStyle({
    required this.variant,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });
}

// Helper class for theme colors
class _ThemeColors {
  final Color primary;
  final Color text;
  final Color border;

  _ThemeColors({
    required this.primary,
    required this.text,
    required this.border,
  });
}