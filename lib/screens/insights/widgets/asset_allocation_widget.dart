import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/custom_accordion.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AssetItem {
  final String name;
  final double percentage;
  final Color color;

  const AssetItem({required this.name, required this.percentage, required this.color});
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
        children: [
          // Donut chart
          SizedBox(
            height: 200,
            child: _buildDonutChart(),
          ),
          const SizedBox(height: 24),
          // Legend items
          ..._buildLegendItems(),
        ],
      ),
    );
  }

  Widget _buildDonutChart() {
    return SfCircularChart(
      margin: EdgeInsets.zero,
      series: <CircularSeries>[
        DoughnutSeries<AssetItem, String>(
          dataSource: assetItems,
          xValueMapper: (AssetItem data, _) => data.name,
          yValueMapper: (AssetItem data, _) => data.percentage,
          pointColorMapper: (AssetItem data, _) => data.color,
          innerRadius: '60%',
          radius: '80%',
          // No explode on tap
          explode: false,
          // No dataLabels
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        ),
      ],
      // No legend in the chart itself
      legend: const Legend(isVisible: false),
    );
  }

  List<Widget> _buildLegendItems() {
    return assetItems.map((item) => _buildLegendItem(item)).toList();
  }

  Widget _buildLegendItem(AssetItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.rectangle,
            ),
          ),
          const SizedBox(width: 12),
          // Asset name
          AppText(
            item.name,
            variant: AppTextVariant.bodyMedium,
            weight: AppTextWeight.medium,
            colorType: AppTextColorType.primary,
          ),
          const Spacer(),
          // Percentage
          AppText(
            '${item.percentage.toInt()}%',
            variant: AppTextVariant.bodyMedium,
            weight: AppTextWeight.semiBold,
            colorType: AppTextColorType.primary,
          ),
        ],
      ),
    );
  }
}
