import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/widgets/common/custom_accordion.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class AssetItem {
  final String name;
  final double percentage;
  final Color? color;

  const AssetItem({required this.name, required this.percentage, this.color});
}

class AssetAllocationWidget extends StatelessWidget {
  final List<AssetItem> assetItems;

  const AssetAllocationWidget({super.key, required this.assetItems});

  @override
  Widget build(BuildContext context) {
    return CustomAccordion(
      title: 'Asset Allocation',
      initiallyExpanded: true,
      child: Column(
        children: assetItems.map((item) => _buildAssetRow(item)).toList(),
      ),
    );
  }

  Widget _buildAssetRow(AssetItem item) {
    // Default color is a golden yellow if not specified
    final Color barColor = item.color ?? const Color(0xFF9375A1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Asset name
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AppText(
              item.name,
              variant: AppTextVariant.bodyLarge,
              weight: AppTextWeight.semiBold,
              customColor: AppColors.darkTextPrimary,
            ),
          ),

          // Progress bar with percentage
          Stack(
            children: [
              // Background bar (full width)
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(55, 51, 61, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              // Foreground bar (percentage width)
              FractionallySizedBox(
                widthFactor: item.percentage / 100,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Percentage text
              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: AppText(
                      '${item.percentage.toInt()}%',
                      variant: AppTextVariant.bodyMedium,
                      weight: AppTextWeight.semiBold,
                      customColor: AppColors.darkTextSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
