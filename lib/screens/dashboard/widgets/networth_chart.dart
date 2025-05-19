import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class NetworthChart extends StatelessWidget {
  final bool showProjection;
  final double currentNetworth;
  final double projectedNetworth;

  const NetworthChart({
    super.key,
    this.showProjection = true,
    this.currentNetworth = 76171095,
    this.projectedNetworth = 80000000,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Column(
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  // Growth indicator
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_upward_rounded,
                            size: 14,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          AppText(
                            "₹50,935",
                            variant: AppTextVariant.bodySmall,
                            weight: AppTextWeight.semiBold,
                            colorType: AppTextColorType.success,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Chart
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                      left: 8,
                      top: 30,
                      bottom: 16,
                    ),
                    child: LineChart(mainData()),
                  ),

                  // Current point indicator
                  Positioned(
                    top: 76,
                    right: MediaQuery.of(context).size.width * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.darkPrimary,
                              width: 2.5,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.darkPrimary.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkCardBG.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: AppText(
                            "Today",
                            variant: AppTextVariant.tiny,
                            weight: AppTextWeight.semiBold,
                            colorType: AppTextColorType.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Date range
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    "Mar 2025",
                    variant: AppTextVariant.tiny,
                    weight: AppTextWeight.medium,
                    colorType: AppTextColorType.gray,
                  ),
                  AppText(
                    "Aug 2025",
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

  LineChartData mainData() {
    // Current value point
    final double currentValueX = 5.0;
    final double currentValueY = 76.17;

    // Actual data points with smoother curve
    final List<FlSpot> actualSpots = [
      FlSpot(0, 70.5),
      FlSpot(1, 72.8),
      FlSpot(2, 71.2),
      FlSpot(3, 74.6),
      FlSpot(4, 75.3),
      FlSpot(currentValueX, currentValueY),
    ];

    // Projection data points
    final List<FlSpot> projectionSpots = [
      FlSpot(currentValueX, currentValueY),
      FlSpot(6, 77.2),
      FlSpot(7, 78.5),
      FlSpot(8, 79.3),
      FlSpot(9, 80.7),
      FlSpot(10, 81.9),
    ];

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 10,
      minY: 68, // Adjusted to make the chart more dramatic
      maxY: 84,
      lineTouchData: LineTouchData(enabled: false),
      lineBarsData: [
        // Actual growth line
        LineChartBarData(
          spots: actualSpots,
          isCurved: true,
          curveSmoothness: 0.35, // Smoother curve
          color: AppColors.darkPrimary,
          barWidth: 3.5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.darkPrimary.withValues(alpha: 0.4),
                AppColors.darkPrimary.withValues(alpha: 0.05),
              ],
            ),
          ),
          shadow: Shadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ),

        // Projection line
        if (showProjection)
          LineChartBarData(
            spots: projectionSpots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: Colors.grey.withValues(alpha: 0.6),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            dashArray: const [5, 5], // Dashed line for projection
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.withValues(alpha: 0.25),
                  Colors.grey.withValues(alpha: 0.03),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
