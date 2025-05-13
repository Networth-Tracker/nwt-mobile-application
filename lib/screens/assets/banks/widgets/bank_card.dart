import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

/// A widget that displays bank account information in a card format.
/// 
/// This widget shows bank details including the bank name, account number,
/// current balance, and a delta indicator showing change in value.
class BankCard extends StatelessWidget {
  final IconData icon;
  final String bankName;
  final String accountNumber;
  final String balance;
  final String deltaValue;
  final bool isPositiveDelta;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconBackgroundColor;

  const BankCard({
    Key? key,
    required this.icon,
    required this.bankName,
    required this.accountNumber,
    required this.balance,
    required this.deltaValue,
    this.isPositiveDelta = true,
    this.backgroundColor,
    this.borderColor,
    this.iconBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format delta value to ensure it has a + sign if positive
    String formattedDeltaValue = deltaValue;
    if (isPositiveDelta && !deltaValue.startsWith('+')) {
      formattedDeltaValue = '+ $deltaValue';
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.darkCardBG,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor ?? AppColors.darkButtonBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBackgroundColor ?? AppColors.darkButtonBorder,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.darkTextMuted,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    bankName,
                    variant: AppTextVariant.bodyLarge,
                    weight: AppTextWeight.semiBold,
                    colorType: AppTextColorType.primary,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    accountNumber,
                    variant: AppTextVariant.bodyMedium,
                    weight: AppTextWeight.regular,
                    colorType: AppTextColorType.secondary,
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                balance,
                variant: AppTextVariant.headline4,
                weight: AppTextWeight.bold,
                colorType: AppTextColorType.primary,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isPositiveDelta 
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: AppText(
                  formattedDeltaValue,
                  variant: AppTextVariant.bodySmall,
                  weight: AppTextWeight.medium,
                  colorType: isPositiveDelta 
                      ? AppTextColorType.success
                      : AppTextColorType.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
