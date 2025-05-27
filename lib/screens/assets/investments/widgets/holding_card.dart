import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/utils/currency_formatter.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class HoldingCard extends StatelessWidget {
  final String fundName;
  final String navValue;
  final String investedAmount;
  final String currentAmount;
  final String gainAmount;
  final IconData? icon;

  const HoldingCard({
    super.key,
    required this.fundName,
    required this.navValue,
    required this.investedAmount,
    required this.currentAmount,
    required this.gainAmount,
    this.icon = Icons.account_balance_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCardBG,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkButtonBorder),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.darkButtonBorder,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, size: 20, color: AppColors.darkTextMuted),
              ),
              SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      fundName,
                      variant: AppTextVariant.bodyLarge,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.primary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppText(
                      "NAV ₹$navValue",
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.secondary,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.darkCardBG,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: AppColors.darkButtonBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      "Invested: ${CurrencyFormatter.formatRupee(num.parse(investedAmount))}",
                      variant: AppTextVariant.bodyMedium,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.primary,
                    ),
                    AppText(
                      "Current: ${CurrencyFormatter.formatRupee(num.parse(currentAmount))}",
                      variant: AppTextVariant.bodyMedium,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.primary,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      "Gain: ${CurrencyFormatter.formatRupee(num.parse(gainAmount))}",
                      variant: AppTextVariant.bodyMedium,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
