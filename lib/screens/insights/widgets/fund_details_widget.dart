import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/widgets/common/custom_accordion.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class FundDetailsWidget extends StatelessWidget {
  final String invested;
  final String current;
  final String gain;
  final String gainPercentage;
  final String expenseRatio;
  final String folioNo;
  final String turnover;
  final String investmentStyle;
  final String fundManager;
  final String aum;
  final String exitLoad;
  final String investedSince;

  const FundDetailsWidget({
    super.key,
    required this.invested,
    required this.current,
    required this.gain,
    required this.gainPercentage,
    required this.expenseRatio,
    required this.folioNo,
    required this.turnover,
    required this.investmentStyle,
    required this.fundManager,
    required this.aum,
    required this.exitLoad,
    required this.investedSince,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAccordion(
      title: 'Fund Details',
      initiallyExpanded: true,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 2.5,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Invested
          _buildGridItem(label: 'Expense Ratio', value: expenseRatio),
          _buildGridItem(label: 'Invested', value: invested),

          // Current
          _buildGridItem(label: 'Current', value: current),

          // Expense Ratio

          // Folio No
          _buildGridItem(label: 'Folio No', value: folioNo),

          // Turnover
          _buildGridItem(label: 'Turnover', value: turnover),

          // Investment Style
          _buildGridItem(label: 'Investment Style', value: investmentStyle),

          // Fund Manager
          _buildGridItem(
            label: 'Fund Manager',
            value: fundManager,
            suffix: const Icon(
              Icons.info_outline,
              size: 16,
              color: AppColors.darkTextSecondary,
            ),
          ),

          // AUM
          _buildGridItem(label: 'AUM', value: aum),

          // Exit Load
          _buildGridItem(
            label: 'Exit Load',
            value: exitLoad,
            suffix: const Icon(
              Icons.info_outline,
              size: 16,
              color: AppColors.darkTextSecondary,
            ),
          ),

          // Invested Since
          _buildGridItem(label: 'Invested Since', value: investedSince),
        ],
      ),
    );
  }

  Widget _buildGridItem({
    required String label,
    required String value,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          label,
          variant: AppTextVariant.bodyMedium,
          colorType: AppTextColorType.secondary,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            AppText(
              value,
              variant: AppTextVariant.bodyLarge,
              weight: AppTextWeight.semiBold,
              colorType: AppTextColorType.primary,
            ),
            if (suffix != null) ...[const SizedBox(width: 4), suffix],
          ],
        ),
      ],
    );
  }
}
