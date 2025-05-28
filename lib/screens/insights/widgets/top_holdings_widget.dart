import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/custom_accordion.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class HoldingItem {
  final String name;
  final String logoUrl;
  final double percentage;
  final Color? logoBackground;

  const HoldingItem({
    required this.name,
    required this.logoUrl,
    required this.percentage,
    this.logoBackground,
  });
}

class TopHoldingsWidget extends StatefulWidget {
  final List<HoldingItem> holdingItems;
  final int initialVisibleCount;

  const TopHoldingsWidget({
    super.key,
    required this.holdingItems,
    this.initialVisibleCount = 5,
  });

  @override
  State<TopHoldingsWidget> createState() => _TopHoldingsWidgetState();
}

class _TopHoldingsWidgetState extends State<TopHoldingsWidget> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final displayItems =
        _showAll
            ? widget.holdingItems
            : widget.holdingItems.take(widget.initialVisibleCount).toList();

    return CustomAccordion(
      title: 'Top 20 Holdings',
      initiallyExpanded: true,
      child: Column(
        children: [
          // Holdings list
          ...displayItems.map((item) => _buildHoldingRow(item)),

          // Divider
          const Divider(color: Color(0xFF37333D), thickness: 1, height: 32),

          // See All button
          if (widget.holdingItems.length > widget.initialVisibleCount)
            InkWell(
              onTap: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AppText(
                    _showAll ? 'Show Less' : 'See All',
                    variant: AppTextVariant.bodyMedium,
                    weight: AppTextWeight.medium,
                    colorType: AppTextColorType.link,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHoldingRow(HoldingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Logo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item.logoBackground ?? Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.network(
                item.logoUrl,
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.business,
                    size: 24,
                    color: Colors.black54,
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Company name
          Expanded(
            child: AppText(
              item.name,
              variant: AppTextVariant.bodyMedium,
              weight: AppTextWeight.semiBold,
              colorType: AppTextColorType.primary,
            ),
          ),

          // Percentage
          AppText(
            '${item.percentage.toStringAsFixed(2)}%',
            variant: AppTextVariant.bodyMedium,
            weight: AppTextWeight.semiBold,
            colorType: AppTextColorType.primary,
          ),
        ],
      ),
    );
  }
}
