import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class CustomAccordion extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? borderRadius;

  const CustomAccordion({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.padding,
    this.contentPadding,
    this.backgroundColor,
    this.titleColor,
    this.borderRadius,
  });

  @override
  State<CustomAccordion> createState() => _CustomAccordionState();
}

class _CustomAccordionState extends State<CustomAccordion>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  static final Animatable<double> _easeInTween = CurveTween(
    curve: Curves.easeIn,
  );
  static final Animatable<double> _halfTween = Tween<double>(
    begin: 0.0,
    end: 0.5,
  );

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor =
        widget.backgroundColor ??
        (isDarkMode ? AppColors.darkCardBG : AppColors.lightBackground);
    final Color textColor =
        widget.titleColor ??
        (isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);
    final double radius = widget.borderRadius ?? 16.0;

    return Container(
      margin: widget.padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.circular(radius),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    widget.title,
                    variant: AppTextVariant.headline6,
                    weight: AppTextWeight.semiBold,
                    customColor: textColor,
                  ),
                  RotationTransition(
                    turns: _iconTurns,
                    child: Icon(Icons.keyboard_arrow_up, color: textColor),
                  ),
                ],
              ),
            ),
          ),
          // Content
          ClipRect(
            child: AnimatedBuilder(
              animation: _controller.view,
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: _heightFactor,
                  child: SizeTransition(sizeFactor: _heightFactor, child: child),
                );
              },
              child: Padding(
                padding:
                    widget.contentPadding ??
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
