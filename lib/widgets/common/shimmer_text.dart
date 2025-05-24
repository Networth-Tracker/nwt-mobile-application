import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

/// A text widget with a shimmer effect that respects the app's theme
class ShimmerText extends StatefulWidget {
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

  /// Duration for one complete shimmer animation cycle
  final Duration shimmerDuration;

  /// Gradient colors for the shimmer effect
  /// If null, colors will be derived from the theme
  final List<Color>? shimmerColors;

  /// Whether the shimmer effect is enabled
  final bool isShimmering;

  const ShimmerText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.weight = AppTextWeight.regular,
    this.colorType = AppTextColorType.primary,
    this.customColor,
    this.textAlign,
    this.lineHeight,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.shimmerColors,
    this.isShimmering = true,
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.shimmerDuration,
    );

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    if (widget.isShimmering) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isShimmering != oldWidget.isShimmering) {
      if (widget.isShimmering) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }

    if (widget.shimmerDuration != oldWidget.shimmerDuration) {
      _controller.duration = widget.shimmerDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the base text style from the app's theme system
    final TextStyle style = _getTextStyle(
      context,
      widget.variant,
      widget.weight,
      widget.colorType,
      widget.customColor,
      widget.lineHeight,
      widget.decoration,
    );

    // If shimmer is disabled, return regular text
    if (!widget.isShimmering) {
      return Text(
        widget.text,
        style: style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
    }

    // Determine shimmer colors based on theme
    final List<Color> colors =
        widget.shimmerColors ?? _getShimmerColors(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: colors,
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(_animation.value - 1, 0.0),
              end: Alignment(_animation.value, 0.0),
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: style,
            textAlign: widget.textAlign,
            maxLines: widget.maxLines,
            overflow: widget.overflow,
          ),
        );
      },
    );
  }

  /// Helper method to get text color
  Color _getTextColor(
    BuildContext context,
    AppTextColorType colorType,
    Color? customColor,
  ) {
    // If custom color is provided, use it
    if (customColor != null) return customColor;

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
      case AppTextColorType.link:
        return AppColors.linkColor;
    }
  }

  /// Helper method to get text style based on variant, weight, and color
  TextStyle _getTextStyle(
    BuildContext context,
    AppTextVariant variant,
    AppTextWeight weight,
    AppTextColorType colorType,
    Color? customColor,
    double? lineHeight,
    TextDecoration? decoration,
  ) {
    final theme = Theme.of(context);
    final color = _getTextColor(context, colorType, customColor);

    // Get base style from theme based on variant
    TextStyle baseStyle;
    switch (variant) {
      case AppTextVariant.display:
        baseStyle = theme.textTheme.displayLarge!.copyWith(fontSize: 36.sp);
        break;
      case AppTextVariant.headline1:
        baseStyle = theme.textTheme.displayLarge!;
        break;
      case AppTextVariant.headline2:
        baseStyle = theme.textTheme.displayMedium!;
        break;
      case AppTextVariant.headline3:
        baseStyle = theme.textTheme.displaySmall!;
        break;
      case AppTextVariant.headline4:
        baseStyle = theme.textTheme.headlineMedium!;
        break;
      case AppTextVariant.headline5:
        baseStyle = theme.textTheme.headlineSmall!;
        break;
      case AppTextVariant.headline6:
        baseStyle = theme.textTheme.titleLarge!;
        break;
      case AppTextVariant.bodyLarge:
        baseStyle = theme.textTheme.bodyLarge!;
        break;
      case AppTextVariant.bodyMedium:
        baseStyle = theme.textTheme.bodyMedium!;
        break;
      case AppTextVariant.bodySmall:
        baseStyle = theme.textTheme.bodySmall!;
        break;
      case AppTextVariant.caption:
        baseStyle = theme.textTheme.labelSmall!;
        break;
      case AppTextVariant.tiny:
        baseStyle = theme.textTheme.bodySmall!.copyWith(fontSize: 8.sp);
        break;
      case AppTextVariant.button:
        baseStyle = theme.textTheme.labelLarge!;
        break;
      case AppTextVariant.label:
        baseStyle = theme.textTheme.labelMedium!;
        break;
    }

    // Apply font weight
    FontWeight fontWeight;
    switch (weight) {
      case AppTextWeight.light:
        fontWeight = FontWeight.w300;
        break;
      case AppTextWeight.regular:
        fontWeight = FontWeight.w400;
        break;
      case AppTextWeight.medium:
        fontWeight = FontWeight.w500;
        break;
      case AppTextWeight.semiBold:
        fontWeight = FontWeight.w600;
        break;
      case AppTextWeight.bold:
        fontWeight = FontWeight.w700;
        break;
    }

    // Apply color, weight, line height, and decoration
    return baseStyle.copyWith(
      color: color,
      fontWeight: fontWeight,
      height: lineHeight,
      decoration: decoration,
    );
  }

  /// Get shimmer gradient colors based on theme
  List<Color> _getShimmerColors(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = _getTextColor(
      context,
      widget.colorType,
      widget.customColor,
    );

    if (isDarkMode) {
      // Dark theme shimmer colors
      return [
        baseColor.withOpacity(0.5),
        baseColor,
        baseColor.withOpacity(0.5),
      ];
    } else {
      // Light theme shimmer colors
      return [
        baseColor.withOpacity(0.5),
        baseColor,
        baseColor.withOpacity(0.5),
      ];
    }
  }
}

/// A convenient extension of ShimmerText that uses the AppText parameters
class AppShimmerText extends StatelessWidget {
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
  final Duration shimmerDuration;
  final List<Color>? shimmerColors;
  final bool isShimmering;

  const AppShimmerText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.weight = AppTextWeight.regular,
    this.colorType = AppTextColorType.primary,
    this.customColor,
    this.textAlign,
    this.lineHeight,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.shimmerColors,
    this.isShimmering = true,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerText(
      text,
      variant: variant,
      weight: weight,
      colorType: colorType,
      customColor: customColor,
      textAlign: textAlign,
      lineHeight: lineHeight,
      maxLines: maxLines,
      overflow: overflow,
      decoration: decoration,
      shimmerDuration: shimmerDuration,
      shimmerColors: shimmerColors,
      isShimmering: isShimmering,
    );
  }
}

/// A shimmer placeholder for text with a rounded rectangle background
class ShimmerTextPlaceholder extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Duration shimmerDuration;
  final List<Color>? shimmerColors;

  const ShimmerTextPlaceholder({
    super.key,
    required this.width,
    this.height = 16,
    this.borderRadius,
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.shimmerColors,
  });

  @override
  State<ShimmerTextPlaceholder> createState() => _ShimmerTextPlaceholderState();
}

class _ShimmerTextPlaceholderState extends State<ShimmerTextPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.shimmerDuration,
    );

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    final List<Color> colors =
        widget.shimmerColors ??
        [
          baseColor.withOpacity(0.15),
          baseColor.withOpacity(0.3),
          baseColor.withOpacity(0.15),
        ];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width.w,
          height: widget.height.h,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4.r),
            gradient: LinearGradient(
              colors: colors,
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(_animation.value - 1, 0.0),
              end: Alignment(_animation.value, 0.0),
            ),
          ),
        );
      },
    );
  }
}
