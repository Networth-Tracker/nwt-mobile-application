import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:get/get.dart';
import 'package:nwt_app/controllers/theme_controller.dart';

class NetworthChart extends StatelessWidget {
  final bool showProjection;
  final double currentNetworth;
  final double projectedNetworth;
  
  const NetworthChart({
    Key? key,
    this.showProjection = true,
    this.currentNetworth = 76171095,
    this.projectedNetworth = 80000000,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  // Growth amount indicator
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        "₹ 50,935",
                        variant: AppTextVariant.bodySmall,
                        weight: AppTextWeight.semiBold,
                        colorType: AppTextColorType.success,
                      ),
                    ),
                  ),
                  
                  // Chart
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      left: 12,
                      top: 24,
                      bottom: 20,
                    ),
                    child: LineChart(
                      mainData(),
                    ),
                  ),
                  
                  // Today indicator - positioned exactly at the border between actual and projected data
                  Positioned(
                    // Calculate position based on chart dimensions and data point
                    top: 80, // Moved higher to be exactly on the border line
                    right: MediaQuery.of(context).size.width * 0.35, // Position at the border between actual and projected data
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.darkPrimary, width: 2),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          "Today",
                          variant: AppTextVariant.tiny,
                          weight: AppTextWeight.medium,
                          colorType: AppTextColorType.gray,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Date labels outside the graph
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    "1 March 2025",
                    variant: AppTextVariant.tiny,
                    weight: AppTextWeight.medium,
                    colorType: AppTextColorType.gray,
                  ),
                  AppText(
                    "1 August 2025",
                    variant: AppTextVariant.tiny,
                    weight: AppTextWeight.medium,
                    colorType: AppTextColorType.gray,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Define the current value point for positioning the dot
  final double currentValueX = 5.0;
  final double currentValueY = 76.17;
  
  LineChartData mainData() {
    // Static data points for the chart
    final List<FlSpot> actualSpots = [
      FlSpot(0, 70),
      FlSpot(1, 72),
      FlSpot(2, 71),
      FlSpot(3, 74),
      FlSpot(4, 75),
      FlSpot(currentValueX, currentValueY), // Current value
    ];
    
    final List<FlSpot> projectionSpots = [
      FlSpot(currentValueX, currentValueY), // Current value
      FlSpot(6, 77),
      FlSpot(7, 78),
      FlSpot(8, 79),
      FlSpot(9, 80),
      FlSpot(10, 81),
    ];

    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 10,
      minY: 65,
      maxY: 85,
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      lineBarsData: [
        // Actual growth line
        LineChartBarData(
          spots: actualSpots,
          isCurved: true,
          color: AppColors.darkPrimary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.darkPrimary.withValues(alpha: 0.3),
          ),
        ),
        
        // Projection line
        if (showProjection)
          LineChartBarData(
            spots: projectionSpots,
            isCurved: true,
            color: Colors.grey.withValues(alpha: 0.5),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.grey.withValues(alpha: 0.2),
            ),
          ),
      ],
    );
  }
}
