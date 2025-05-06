import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';

enum AppTextVariant {
  headline1,
  headline2,
  headline3,
  headline4,
  headline5,
  headline6,
  bodyLarge,
  bodyMedium,
  bodySmall,
  caption,
  button,
  labelLarge,
  labelMedium,
  labelSmall,
}

enum AppTextWeight {
  light,
  regular,
  medium,
  semiBold,
  bold,
}

enum AppTextColorType {
  primary,
  secondary,
  tertiary,
  button,
  custom,
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final AppTextWeight? weight;
  final Color? color;
  final AppTextColorType colorType;
  final TextAlign? textAlign;
  final double? lineHeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool selectable;
  final double? letterSpacing;
  final TextDecoration? decoration;
  final List<TextSpan>? children;

  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.weight,
    this.color,
    this.colorType = AppTextColorType.primary,
    this.textAlign,
    this.lineHeight,
    this.maxLines,
    this.overflow,
    this.selectable = false,
    this.letterSpacing,
    this.decoration,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle style = _getTextStyle(context);
    
    // Return selectable text if requested
    if (selectable) {
      return SelectableText(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }
    
    // Return regular text or rich text if children exist
    if (children != null && children!.isNotEmpty) {
      return Text.rich(
        TextSpan(
          text: text,
          style: style,
          children: children,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
    
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Get base style for the variant
    TextStyle baseStyle = _getBaseStyle(theme);
    
    // Apply weight
    FontWeight fontWeight = _resolveFontWeight();
    
    // Apply color based on theme and variant
    Color textColor = _resolveTextColor(theme, isDarkMode);
    
    // Create final style by combining all properties
    return baseStyle.copyWith(
      color: textColor,
      fontWeight: fontWeight,
      height: lineHeight,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  TextStyle _getBaseStyle(ThemeData theme) {
    switch (variant) {
      case AppTextVariant.headline1:
        return const TextStyle(fontSize: 32);
      case AppTextVariant.headline2:
        return const TextStyle(fontSize: 28);
      case AppTextVariant.headline3:
        return const TextStyle(fontSize: 24);
      case AppTextVariant.headline4:
        return const TextStyle(fontSize: 20);
      case AppTextVariant.headline5:
        return const TextStyle(fontSize: 18);
      case AppTextVariant.headline6:
        return const TextStyle(fontSize: 16);
      case AppTextVariant.bodyLarge:
        return theme.textTheme.bodyLarge ?? const TextStyle(fontSize: 16);
      case AppTextVariant.bodyMedium:
        return theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
      case AppTextVariant.bodySmall:
        return theme.textTheme.bodySmall ?? const TextStyle(fontSize: 12);
      case AppTextVariant.caption:
        return const TextStyle(fontSize: 12);
      case AppTextVariant.button:
        return const TextStyle(fontSize: 14);
      case AppTextVariant.labelLarge:
        return const TextStyle(fontSize: 14);
      case AppTextVariant.labelMedium:
        return const TextStyle(fontSize: 12);
      case AppTextVariant.labelSmall:
        return const TextStyle(fontSize: 10);
    }
  }

  FontWeight _resolveFontWeight() {
    // If weight is explicitly provided, use it
    if (weight != null) {
      switch (weight!) {
        case AppTextWeight.light:
          return FontWeight.w300;
        case AppTextWeight.regular:
          return FontWeight.w400;
        case AppTextWeight.medium:
          return FontWeight.w500;
        case AppTextWeight.semiBold:
          return FontWeight.w600;
        case AppTextWeight.bold:
          return FontWeight.w700;
      }
    }

    // Otherwise, use default weight based on variant
    switch (variant) {
      case AppTextVariant.headline1:
      case AppTextVariant.headline2:
      case AppTextVariant.headline3:
        return FontWeight.w700; // Bold
      case AppTextVariant.headline4:
      case AppTextVariant.headline5:
      case AppTextVariant.headline6:
        return FontWeight.w600; // SemiBold
      case AppTextVariant.button:
        return FontWeight.w600; // SemiBold
      case AppTextVariant.bodyLarge:
      case AppTextVariant.bodyMedium:
      case AppTextVariant.bodySmall:
      case AppTextVariant.caption:
      case AppTextVariant.labelLarge:
      case AppTextVariant.labelMedium:
      case AppTextVariant.labelSmall:
        return FontWeight.w400; // Regular
    }
  }

  Color _resolveTextColor(ThemeData theme, bool isDarkMode) {
    // If color is explicitly provided, use it
    if (color != null) {
      return color!;
    }

    final colorTheme = isDarkMode ? AppColors.darkTheme : AppColors.lightTheme;
    
    // Get color from AppColors based on colorType
    switch (colorType) {
      case AppTextColorType.primary:
        if (colorTheme['text'] != null && colorTheme['text']!['primary'] != null) {
          return colorTheme['text']!['primary'];
        }
        return isDarkMode ? Colors.white : Colors.black;
      
      case AppTextColorType.secondary:
        if (colorTheme['text'] != null && colorTheme['text']!['secondary'] != null) {
          return colorTheme['text']!['secondary'];
        }
        return isDarkMode ? Colors.white.withValues(alpha: 0.87) : const Color.fromRGBO(70, 71, 72, 1);
      
      case AppTextColorType.tertiary:
        if (colorTheme['text'] != null && colorTheme['text']!['tertiary'] != null) {
          return colorTheme['text']!['tertiary'];
        }
        return isDarkMode ? Colors.white.withValues(alpha: 0.6) : Colors.grey;
      
      case AppTextColorType.button:
        if (colorTheme['button'] != null && 
            colorTheme['button']!['primary'] != null && 
            colorTheme['button']!['primary']['text'] != null) {
          return colorTheme['button']!['primary']['text'];
        }
        return isDarkMode ? Colors.white : Colors.black;
      
      case AppTextColorType.custom:
        // Fall back to variant-based colors if custom is selected but no color provided
        return _getVariantBasedColor(theme, isDarkMode);
    }
  }

  Color _getVariantBasedColor(ThemeData theme, bool isDarkMode) {
    // Get color from theme based on variant and dark/light mode
    if (isDarkMode) {
      switch (variant) {
        case AppTextVariant.bodyLarge:
          return theme.textTheme.bodyLarge?.color ?? Colors.white;
        case AppTextVariant.bodyMedium:
          return theme.textTheme.bodyMedium?.color ?? Colors.white.withValues(alpha: 0.87);
        case AppTextVariant.bodySmall:
          return theme.textTheme.bodySmall?.color ?? Colors.white.withValues(alpha: 0.6);
        case AppTextVariant.headline1:
        case AppTextVariant.headline2:
        case AppTextVariant.headline3:
        case AppTextVariant.headline4:
        case AppTextVariant.headline5:
        case AppTextVariant.headline6:
          return Colors.white;
        case AppTextVariant.caption:
        case AppTextVariant.labelSmall:
        case AppTextVariant.labelMedium:
          return Colors.white.withValues(alpha: 0.6);
        case AppTextVariant.button:
        case AppTextVariant.labelLarge:
          return Colors.white;
      }
    } else {
      switch (variant) {
        case AppTextVariant.bodyLarge:
          return theme.textTheme.bodyLarge?.color ?? Colors.black;
        case AppTextVariant.bodyMedium:
          return theme.textTheme.bodyMedium?.color ?? const Color.fromRGBO(70, 71, 72, 1);
        case AppTextVariant.bodySmall:
          return theme.textTheme.bodySmall?.color ?? Colors.grey;
        case AppTextVariant.headline1:
        case AppTextVariant.headline2:
        case AppTextVariant.headline3:
        case AppTextVariant.headline4:
        case AppTextVariant.headline5:
        case AppTextVariant.headline6:
          return Colors.black;
        case AppTextVariant.caption:
        case AppTextVariant.labelSmall:
        case AppTextVariant.labelMedium:
          return Colors.grey;
        case AppTextVariant.button:
        case AppTextVariant.labelLarge:
          return Colors.black;
      }
    }
  }

  // Factory constructors for common text styles with appropriate default color types
  factory AppText.headline1(String text, {
    Key? key,
    Color? color,
    AppTextColorType colorType = AppTextColorType.primary, // Default to primary for headlines
    TextAlign? textAlign,
    AppTextWeight? weight,
    double? lineHeight,
    int? maxLines,
    TextOverflow? overflow,
  }) => AppText(
    text,
    key: key,
    variant: AppTextVariant.headline1,
    color: color,
    colorType: colorType,
    textAlign: textAlign,
    weight: weight,
    lineHeight: lineHeight,
    maxLines: maxLines,
    overflow: overflow,
  );
  
  factory AppText.headline2(String text, {
    Key? key,
    Color? color,
    AppTextColorType colorType = AppTextColorType.primary,
    TextAlign? textAlign,
    AppTextWeight? weight,
    double? lineHeight,
    int? maxLines,
    TextOverflow? overflow,
  }) => AppText(
    text,
    key: key,
    variant: AppTextVariant.headline2,
    color: color,
    colorType: colorType,
    textAlign: textAlign,
    weight: weight,
    lineHeight: lineHeight,
    maxLines: maxLines,
    overflow: overflow,
  );
  
  factory AppText.headline3(String text, {
    Key? key,
    Color? color,
    AppTextColorType colorType = AppTextColorType.primary,
    TextAlign? textAlign,
    AppTextWeight? weight,
    double? lineHeight,
    int? maxLines,
    TextOverflow? overflow,
  }) => AppText(
    text,
    key: key,
    variant: AppTextVariant.headline3,
    color: color,
    colorType: colorType,
    textAlign: textAlign,
    weight: weight,
    lineHeight: lineHeight,
    maxLines: maxLines,
    overflow: overflow,
  );
  
  factory AppText.headline4(String text, {
    Key? key,
    Color? color,
    AppTextColorType colorType = AppTextColorType.primary,
    TextAlign? textAlign,
    AppTextWeight? weight,
    double? lineHeight,
    int? maxLines,
    TextOverflow? overflow,
  }) => AppText(
    text,
    key: key,
    variant: AppTextVariant.headline4,
    color: color,
    colorType: colorType,
    textAlign: textAlign,
    weight: weight,
    lineHeight: lineHeight,
    maxLines: maxLines,
    overflow: overflow,
  );
  
  factory AppText.caption(String text, {
    Key? key,
    Color? color,
    AppTextColorType colorType = AppTextColorType.tertiary, // Default to tertiary for captions
    TextAlign? textAlign,
    AppTextWeight? weight,
    double? lineHeight,
    int? maxLines,
    TextOverflow? overflow,
  }) => AppText(
    text,
    key: key,
    variant: AppTextVariant.caption,
    color: color,
    colorType: colorType,
    textAlign: textAlign,
    weight: weight,
    lineHeight: lineHeight,
    maxLines: maxLines,
    overflow: overflow,
  );
  
  factory AppText.button(String text, {
    Key? key,
    Color? color,
    AppTextColorType colorType = AppTextColorType.button,
    TextAlign? textAlign,
    AppTextWeight? weight,
    double? lineHeight,
  }) => AppText(
    text,
    key: key,
    variant: AppTextVariant.button,
    color: color,
    colorType: colorType,
    textAlign: textAlign,
    weight: weight ?? AppTextWeight.semiBold,
    lineHeight: lineHeight,
  );
}