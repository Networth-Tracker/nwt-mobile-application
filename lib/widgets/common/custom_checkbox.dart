import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final double size;
  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.size = 20.0,
    this.activeColor,
    this.checkColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.borderRadius = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color effectiveActiveColor = activeColor ?? AppColors.darkPrimary;
    final Color effectiveCheckColor = checkColor ?? Colors.white;
    final Color effectiveBorderColor = borderColor ?? AppColors.darkButtonBorder;

    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? effectiveActiveColor : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: value ? effectiveActiveColor : effectiveBorderColor,
            width: borderWidth,
          ),
        ),
        child: value
            ? Center(
                child: Icon(
                  Icons.check,
                  size: size * 0.65,
                  color: effectiveCheckColor,
                ),
              )
            : null,
      ),
    );
  }
}
