import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/custom_accordion.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class SectorItem {
  final String name;
  final double percentage;
  final Color progressColor;

  const SectorItem({
    required this.name,
    required this.percentage,
    required this.progressColor,
  });
}

class SectorAllocationWidget extends StatelessWidget {
  final List<SectorItem> sectorItems;

  const SectorAllocationWidget({super.key, required this.sectorItems});

  @override
  Widget build(BuildContext context) {
    return CustomAccordion(
      title: 'Today\'s Sector Allocation',
      initiallyExpanded: true,
      child: Column(
        children: sectorItems.map((item) => _buildSectorRow(item)).toList(),
      ),
    );
  }

  Widget _buildSectorRow(SectorItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sector name
          AppText(
            item.name,
            variant: AppTextVariant.bodyMedium,
            weight: AppTextWeight.semiBold,
            colorType: AppTextColorType.primary,
          ),

          // Progress bar row
          Row(
            children: [
              // Progress bar
              Expanded(
                child: Stack(
                  children: [
                    // Background bar
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF37333D),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    // Foreground bar
                    FractionallySizedBox(
                      widthFactor: item.percentage / 100,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: item.progressColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Percentage text
              const SizedBox(width: 16),
              AppText(
                '${item.percentage.toInt()}%',
                variant: AppTextVariant.bodyLarge,
                weight: AppTextWeight.semiBold,
                colorType: AppTextColorType.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
