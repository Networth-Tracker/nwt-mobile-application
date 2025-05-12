import 'package:flutter/material.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/constants/colors.dart';

/// Text variants available in the application
enum AppTextVariant {
  display,    // New variant with font size 30
  headline1,
  headline2,
  headline3,
  headline4,
  headline5,
  headline6,
  bodyLarge,
  bodyMedium,
  bodySmall,
  tiny,      // New variant with font size 8
  caption,
  button,
  label
}

/// Text weight options
enum AppTextWeight {
  light,
  regular,
  medium,
  semiBold,
  bold
}

/// Text color options
enum AppTextColorType {
  primary,
  secondary,
  tertiary,
  muted,
  gray,
  error,
  success,
  warning,
  custom
}

/// Resolves [AppTextColorType] to an actual [Color] from the current theme extension
Color _resolveTextColor(BuildContext context, AppTextColorType colorType, Color? customColor) {
  if (colorType == AppTextColorType.custom && customColor != null) {
    return customColor;
  }
  
  final textThemeColors = context.textThemeColors;
  final theme = Theme.of(context);
  
  switch (colorType) {
    case AppTextColorType.primary:
      return textThemeColors.primaryText;
    case AppTextColorType.secondary:
      return textThemeColors.secondaryText;
    case AppTextColorType.tertiary:
      return textThemeColors.tertiaryText;
    case AppTextColorType.muted:
      return textThemeColors.mutedText;
    case AppTextColorType.gray:
      return textThemeColors.grayText;
    case AppTextColorType.error:
      return theme.colorScheme.error;
    case AppTextColorType.success:
      return Colors.green;
    case AppTextColorType.warning:
      return Colors.orange;
    case AppTextColorType.custom:
      // Fallback if customColor is null
      return textThemeColors.primaryText;
  }
}

/// Resolves [AppTextWeight] to an actual [FontWeight]
FontWeight _resolveFontWeight(AppTextWeight weight) {
  switch (weight) {
    case AppTextWeight.light:
      return FontWeight.w300;
    case AppTextWeight.regular:
      return FontWeight.normal;
    case AppTextWeight.medium:
      return FontWeight.w500;
    case AppTextWeight.semiBold:
      return FontWeight.w600;
    case AppTextWeight.bold:
      return FontWeight.bold;
  }
}

/// Gets the appropriate text style based on variant and theme
TextStyle _getTextStyle(BuildContext context, AppTextVariant variant, AppTextWeight weight, 
    AppTextColorType colorType, Color? customColor, double? lineHeight, TextDecoration? decoration) {
  
  // Resolve color and weight
  final color = _resolveTextColor(context, colorType, customColor);
  final fontWeight = _resolveFontWeight(weight);
  
  // Base style with variant-specific properties
  TextStyle style;
  switch (variant) {
    case AppTextVariant.display:
      style = TextStyle(fontSize: 36, fontWeight: fontWeight);
      break;
    case AppTextVariant.headline1:
      style = TextStyle(fontSize: 28, fontWeight: fontWeight);
      break;
    case AppTextVariant.headline2:
      style = TextStyle(fontSize: 24, fontWeight: fontWeight);
      break;
    case AppTextVariant.headline3:
      style = TextStyle(fontSize: 20, fontWeight: fontWeight);
      break;
    case AppTextVariant.headline4:
      style = TextStyle(fontSize: 18, fontWeight: fontWeight);
      break;
    case AppTextVariant.headline5:
      style = TextStyle(fontSize: 16, fontWeight: fontWeight);
      break;
    case AppTextVariant.headline6:
      style = TextStyle(fontSize: 14, fontWeight: fontWeight);
      break;
    case AppTextVariant.bodyLarge:
      style = TextStyle(fontSize: 16, fontWeight: fontWeight);
      break;
    case AppTextVariant.bodyMedium:
      style = TextStyle(fontSize: 14, fontWeight: fontWeight);
      break;
    case AppTextVariant.bodySmall:
      style = TextStyle(fontSize: 12, fontWeight: fontWeight);
      break;
    case AppTextVariant.tiny:
      style = TextStyle(fontSize: 10, fontWeight: fontWeight);
      break;
    case AppTextVariant.caption:
      style = TextStyle(fontSize: 12, fontWeight: fontWeight);
      break;
    case AppTextVariant.button:
      style = TextStyle(fontSize: 14, fontWeight: fontWeight);
      break;
    case AppTextVariant.label:
      style = TextStyle(fontSize: 12, fontWeight: fontWeight);
      break;
  }

  // Apply color, height, and decoration
  return style.copyWith(
    color: color,
    height: lineHeight,
    decoration: decoration,
  );
}

/// A custom text widget that adapts to theme changes
class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final AppTextWeight weight;
  final AppTextColorType colorType;
  final Color? customColor;
  final TextAlign? textAlign;
  final double? lineHeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final bool selectable;

  const AppText(
    this.text, {
    Key? key,
    this.variant = AppTextVariant.bodyMedium,
    this.weight = AppTextWeight.regular,
    this.colorType = AppTextColorType.primary,
    this.customColor,
    this.textAlign,
    this.lineHeight,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.selectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle style = _getTextStyle(
      context, 
      variant, 
      weight, 
      colorType, 
      customColor, 
      lineHeight, 
      decoration
    );
    
    if (selectable) {
      return SelectableText(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
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
}

/// An animated version of AppText that smoothly transitions between changes
class AnimatedAppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final AppTextWeight weight;
  final AppTextColorType colorType;
  final Color? customColor;
  final TextAlign? textAlign;
  final double? lineHeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final Duration duration;
  final Curve curve;
  final Offset? beginOffset;
  final Duration? delay;

  const AnimatedAppText(
    this.text, {
    Key? key,
    this.variant = AppTextVariant.bodyMedium,
    this.weight = AppTextWeight.regular,
    this.colorType = AppTextColorType.primary,
    this.customColor,
    this.textAlign,
    this.lineHeight,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.beginOffset,
    this.delay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = _getTextStyle(
      context, 
      variant, 
      weight, 
      colorType, 
      customColor, 
      lineHeight, 
      decoration
    );
    
    Widget textWidget = AnimatedDefaultTextStyle(
      duration: duration,
      curve: curve,
      style: style,
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
    
    // Apply animation if beginOffset is provided
    if (beginOffset != null) {
      textWidget = TweenAnimationBuilder<Offset>(
        tween: Tween<Offset>(begin: beginOffset, end: Offset.zero),
        duration: duration,
        curve: curve,
        builder: (context, value, child) {
          return Transform.translate(
            offset: value,
            child: child,
          );
        },
        child: textWidget,
      );
    }
    
    // Apply delay if provided
    if (delay != null) {
      return FutureBuilder(
        future: Future.delayed(delay!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return textWidget;
          } else {
            return Opacity(opacity: 0, child: textWidget);
          }
        },
      );
    }
    
    return textWidget;
  }
}

/// Semantic color options for BasicText (legacy support)
enum BasicTextColor {
  primary,
  secondary,
  error,
  success,
  warning,
}

/// Resolves [BasicTextColor] to an actual [Color] from the current theme extension
Color _resolveBasicTextColor(BuildContext context, BasicTextColor color) {
  final textThemeColors = context.textThemeColors;
  final theme = Theme.of(context);
  switch (color) {
    case BasicTextColor.primary:
      return textThemeColors.primaryText;
    case BasicTextColor.secondary:
      return textThemeColors.secondaryText;
    case BasicTextColor.error:
      return theme.colorScheme.error;
    case BasicTextColor.success:
      // You may want to add a 'successText' to your theme extension for true theme support
      return Colors.green;
    case BasicTextColor.warning:
      // You may want to add a 'warningText' to your theme extension for true theme support
      return Colors.orange;
  }
}

/// A minimal text widget for basic use cases
class BasicText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? lineHeight;
  final BasicTextColor color;

  const BasicText(
    this.text, {
    Key? key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.textAlign,
    this.overflow,
    this.lineHeight,
    this.color = BasicTextColor.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: _resolveBasicTextColor(context, color),
        height: lineHeight,
      ),
    );
  }
}
