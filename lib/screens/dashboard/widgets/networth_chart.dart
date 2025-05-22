import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/utils/currency_formatter.dart';
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
                            CurrencyFormatter.formatRupee(projectedNetworth),
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
                    right: _getTodayPosition(context),
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
                                color: AppColors.darkPrimary.withValues(
                                  alpha: 0.4,
                                ),
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
                            color: AppColors.darkCardBG.withValues(alpha: 0.8),
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
                    "Mar 2024",
                    variant: AppTextVariant.tiny,
                    weight: AppTextWeight.medium,
                    colorType: AppTextColorType.gray,
                  ),
                  AppText(
                    "May 2026",
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

  // Calculate the position of the "Today" indicator based on the current date
  double _getTodayPosition(BuildContext context) {
    // Get current date
    final now = DateTime.now();

    // Define start and end dates (from Mar 2024 to May 2026)
    final startDate = DateTime(2024, 3, 1);
    final endDate = DateTime(2026, 5, 31);

    // Calculate total duration in days
    final totalDuration = endDate.difference(startDate).inDays;

    // Calculate days elapsed since start date
    final daysElapsed = now.difference(startDate).inDays;

    // Calculate position as a percentage of the total duration
    final percentage = daysElapsed / totalDuration;

    // Calculate the chart width (accounting for padding)
    final chartWidth =
        MediaQuery.of(context).size.width - 40; // Subtract horizontal padding

    // Calculate the position from right
    // The chart area is drawn from left to right, but we position from right
    // We need to convert the X position (0-10 scale) to screen coordinates
    final xPosition = percentage * 10; // Same calculation as in mainData()
    final rightPosition = chartWidth * (0.9 - (xPosition / 11));

    return rightPosition;
  }

  LineChartData mainData() {
    // Calculate current position on X-axis based on current date
    // Use the same date calculation as in _getTodayPosition for consistency
    final now = DateTime.now();
    final startDate = DateTime(2024, 3, 1);
    final endDate = DateTime(2026, 5, 31);
    final totalDuration = endDate.difference(startDate).inDays;
    final daysElapsed = now.difference(startDate).inDays;
    final percentage = daysElapsed / totalDuration;

    // Map percentage to X-axis position (0-10 scale)
    // This must match the calculation used for the Today marker position
    final currentValueX = percentage * 10;
    final currentValueY = 76.17;

    // Generate actual data points up to current date
    final List<FlSpot> actualSpots = [];

    // Add points up to current date with a smooth curve
    final pointCount =
        (currentValueX / 10 * 6).round() +
        1; // Number of points up to current date
    for (int i = 0; i < pointCount; i++) {
      final x = i * (currentValueX / (pointCount - 1));
      // Create a realistic curve with some fluctuations
      final baseValue = 70.5;
      final growth = (currentValueY - baseValue) * (x / currentValueX);
      // Add some minor fluctuations
      final fluctuation = (i % 2 == 0) ? 0.7 : -0.5;
      final y = baseValue + growth + fluctuation;
      actualSpots.add(FlSpot(x, y));
    }

    // Make sure the last point is exactly at current position
    if (actualSpots.isNotEmpty) {
      actualSpots.last = FlSpot(currentValueX, currentValueY);
    } else {
      actualSpots.add(FlSpot(currentValueX, currentValueY));
    }

    // Projection data points from current date to end
    final List<FlSpot> projectionSpots = [FlSpot(currentValueX, currentValueY)];

    // Add projection points after current date
    final remainingPoints = 5; // Number of projection points
    final remainingXRange = 10 - currentValueX;
    for (int i = 1; i <= remainingPoints; i++) {
      final x = currentValueX + (i * (remainingXRange / remainingPoints));
      final growth = i * ((81.9 - currentValueY) / remainingPoints);
      projectionSpots.add(FlSpot(x, currentValueY + growth));
    }

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 10,
      minY: 68, // Adjusted to make the chart more dramatic
      maxY: 84,
      clipData: FlClipData.all(), // Ensure chart is properly clipped
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
            cutOffY: 0, // Ensure the fill extends to the bottom
            applyCutOffY: true,
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
