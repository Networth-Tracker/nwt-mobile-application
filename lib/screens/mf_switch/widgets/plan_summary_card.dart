import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/utils/currency_formatter.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class PlanSummaryCard extends StatelessWidget {
  final double totalInvested;
  final String avgInvestedPeriod;
  final double currentValue;
  final double additionalEarnings;

  const PlanSummaryCard({
    Key? key,
    required this.totalInvested,
    required this.avgInvestedPeriod,
    required this.currentValue,
    required this.additionalEarnings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkCardBG,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkButtonBorder),
      ),
      child: Column(
        children: [
          _buildRow("Total Invested", CurrencyFormatter.formatRupee(totalInvested)),
          const SizedBox(height: 8),
          _buildRow("Avg Invested Period", avgInvestedPeriod),
          const SizedBox(height: 8),
          _buildRow("Current Value", CurrencyFormatter.formatRupee(currentValue)),
          const SizedBox(height: 8),
          Divider(
            color: AppColors.darkPrimary,
            thickness: 1,
          ),
          const SizedBox(height: 8),
          _buildRow(
            "Additional Earnings",
            CurrencyFormatter.formatRupee(additionalEarnings),
            isSuccess: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isSuccess = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          variant: AppTextVariant.headline6,
          weight: AppTextWeight.medium,
          colorType: isSuccess ? AppTextColorType.success : AppTextColorType.primary,
        ),
        AppText(
          value,
          variant: AppTextVariant.headline6,
          weight: AppTextWeight.medium,
          colorType: isSuccess ? AppTextColorType.success : AppTextColorType.primary,
        ),
      ],
    );
  }
}
