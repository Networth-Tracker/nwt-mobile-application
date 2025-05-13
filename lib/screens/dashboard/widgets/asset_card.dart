import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:get/get.dart';

class AssetCard extends StatelessWidget {
  final String title;
  final String amount;
  final String delta;
  final DeltaType deltaType;
  final IconData? icon;
  final double? width;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget? destination;

  const AssetCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.delta,
    this.deltaType = DeltaType.positive,
    this.icon,
    this.width = 250,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    this.backgroundColor,
    this.borderColor,
    this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: destination != null ? () => Get.to(destination, transition: Transition.rightToLeft) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.darkCardBG,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor ?? AppColors.darkButtonBorder,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (icon != null)
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          icon,
                          size: 26,
                        ),
                      ),
                    if (icon != null) const SizedBox(width: 10),
                    AppText(
                      title,
                      variant: AppTextVariant.headline5,
                      weight: AppTextWeight.medium,
                      colorType: AppTextColorType.primary,
                    ),
                  ],
                ),
                _buildDeltaIndicator(),
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Row(
                children: [
                  AppText(
                    amount,
                    variant: AppTextVariant.headline2,
                    weight: AppTextWeight.bold,
                    colorType: AppTextColorType.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeltaIndicator() {
    Color backgroundColor;
    AppTextColorType textColorType;
    String displayDelta = delta;
    if (deltaType == DeltaType.positive && !delta.startsWith('+')) {
      displayDelta = '+$delta';
    }
    switch (deltaType) {
      case DeltaType.positive:
        backgroundColor = Colors.green.withOpacity(0.2);
        textColorType = AppTextColorType.success;
        break;
      case DeltaType.negative:
        backgroundColor = Colors.red.withOpacity(0.2);
        textColorType = AppTextColorType.error;
        break;
      case DeltaType.neutral:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColorType = AppTextColorType.gray;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: AppText(
        displayDelta,
        variant: AppTextVariant.bodySmall,
        weight: AppTextWeight.medium,
        colorType: textColorType,
      ),
    );
  }
}

enum DeltaType {
  positive,
  negative,
  neutral,
}
