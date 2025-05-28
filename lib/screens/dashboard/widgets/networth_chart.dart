import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/screens/dashboard/types/dashboard_networth.dart';
import 'package:nwt_app/utils/currency_formatter.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class NetworthChart extends StatelessWidget {
  final bool showProjection;
  final double currentNetworth;
  final double projectedNetworth;
  final List<Currentprojection>? currentprojection;
  final List<Futureprojection>? futureprojection;

  const NetworthChart({
    super.key,
    this.showProjection = true,
    this.currentNetworth = 76171095,
    this.projectedNetworth = 80000000,
    this.currentprojection,
    this.futureprojection,
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
                            CurrencyFormatter.formatRupee(
                              projectedNetworth / 1000,
                            ),
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

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       AppText(
            //         "Mar 2024",
            //         variant: AppTextVariant.tiny,
            //         weight: AppTextWeight.medium,
            //         colorType: AppTextColorType.gray,
            //       ),
            //       AppText(
            //         "May 2026",
            //         variant: AppTextVariant.tiny,
            //         weight: AppTextWeight.medium,
            //         colorType: AppTextColorType.gray,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        );
      },
    );
  }

  double _getTodayPosition(BuildContext context) {
    final now = DateTime.now();

    final startDate = DateTime(2024, 3, 1);
    final endDate = DateTime(2026, 5, 31);

    final totalDuration = endDate.difference(startDate).inDays;
    final daysElapsed = now.difference(startDate).inDays;

    final percentage = daysElapsed / totalDuration;

    final chartWidth = MediaQuery.of(context).size.width - 40;
    final xPosition = percentage * 10;
    final rightPosition = chartWidth * (0.9 - (xPosition / 11));

    return rightPosition;
  }

  LineChartData mainData() {
    final now = DateTime.now();

    DateTime startDate;
    DateTime endDate;

    if (currentprojection != null &&
        currentprojection!.isNotEmpty &&
        futureprojection != null &&
        futureprojection!.isNotEmpty) {
      final sortedCurrentProjection = List<Currentprojection>.from(
        currentprojection!,
      );
      sortedCurrentProjection.sort((a, b) => a.date.compareTo(b.date));
      final sortedFutureProjection = List<Futureprojection>.from(
        futureprojection!,
      );
      sortedFutureProjection.sort((a, b) => a.date.compareTo(b.date));

      startDate = sortedCurrentProjection.first.date;
      endDate = sortedFutureProjection.last.date;
    } else {
      startDate = DateTime.now().subtract(const Duration(days: 365));
      endDate = DateTime.now().add(const Duration(days: 365 * 2));
    }

    final totalDuration = endDate.difference(startDate).inDays;

    final daysElapsed = now.difference(startDate).inDays;
    final todayPercentage = daysElapsed / totalDuration;
    var currentValueX = todayPercentage * 10;

    double currentValueY = currentNetworth / 1000000;

    const double minY = 68;
    const double maxY = 84;

    double maxDataValue = currentNetworth / 1000000;

    if (currentprojection != null && currentprojection!.isNotEmpty) {
      for (var point in currentprojection!) {
        if (point.value > maxDataValue) maxDataValue = point.value;
      }
    }

    if (futureprojection != null && futureprojection!.isNotEmpty) {
      for (var point in futureprojection!) {
        if (point.projectedValue > maxDataValue) {
          maxDataValue = point.projectedValue;
        }
      }
    }

    maxDataValue = maxDataValue * 1.1;

    final List<FlSpot> actualSpots = [];
    final List<FlSpot> projectionSpots = [];
    FlSpot? todaySpot;

    List<Map<String, dynamic>> allProjections = [];

    if (currentprojection != null && currentprojection!.isNotEmpty) {
      for (var point in currentprojection!) {
        allProjections.add({
          'date': point.date,
          'value': point.value,
          'type': 'current',
        });
      }
    }

    if (futureprojection != null && futureprojection!.isNotEmpty) {
      for (var point in futureprojection!) {
        allProjections.add({
          'date': point.date,
          'value': point.projectedValue,
          'type': 'future',
        });
      }
    }

    allProjections.sort(
      (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime),
    );

    Map<String, dynamic>? closestToToday;
    int closestDayDifference = 999999;

    for (var point in allProjections) {
      final date = point['date'] as DateTime;
      final value = point['value'] as double;
      final type = point['type'] as String;

      final daysSinceStart = date.difference(startDate).inDays;
      final xPosition = (daysSinceStart / totalDuration) * 10;
      final yValue = minY + ((value / maxDataValue) * (maxY - minY));

      if (date.isBefore(now)) {
        if (type == 'current') {
          actualSpots.add(FlSpot(xPosition, yValue));

          final dayDifference = now.difference(date).inDays.abs();
          if (dayDifference < closestDayDifference) {
            closestDayDifference = dayDifference;
            closestToToday = point;
            currentValueY = yValue;
            currentValueX = xPosition;
          }
        }
      } else {
        if (type == 'future') {
          projectionSpots.add(FlSpot(xPosition, yValue));
        }
      }
    }

    if (closestToToday != null) {
      final date = closestToToday['date'] as DateTime;
      final value = closestToToday['value'] as double;

      final daysSinceStart = date.difference(startDate).inDays;
      final xPosition = (daysSinceStart / totalDuration) * 10;
      final yValue = minY + ((value / maxDataValue) * (maxY - minY));
      todaySpot = FlSpot(xPosition, yValue);
    } else {
      final pointCount = (currentValueX / 10 * 6).round() + 1;
      for (int i = 0; i < pointCount; i++) {
        final x = i * (currentValueX / (pointCount - 1));
        final baseValue = 70.5;
        final growth = (currentValueY - baseValue) * (x / currentValueX);
        final fluctuation = (i % 2 == 0) ? 0.7 : -0.5;
        final y = baseValue + growth + fluctuation;
        actualSpots.add(FlSpot(x, y));
      }

      if (actualSpots.isNotEmpty) {
        todaySpot = actualSpots.last;
      } else {
        todaySpot = FlSpot(currentValueX, currentValueY);
        actualSpots.add(todaySpot);
      }
    }

    projectionSpots.add(todaySpot);

    if (projectionSpots.length <= 1) {
      final remainingPoints = 5;
      final remainingXRange = 10 - currentValueX;
      for (int i = 1; i <= remainingPoints; i++) {
        final x = currentValueX + (i * (remainingXRange / remainingPoints));
        final growth = i * ((81.9 - currentValueY) / remainingPoints);
        projectionSpots.add(FlSpot(x, currentValueY + growth));
      }
    }

    String formatDateForAxis(DateTime date) {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.year}';
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        verticalInterval: 2,
        horizontalInterval: 4,
        getDrawingVerticalLine:
            (value) => FlLine(
              color: Colors.grey.withValues(alpha: 0.15),
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
        getDrawingHorizontalLine:
            (value) => FlLine(
              color: Colors.grey.withValues(alpha: 0.15),
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 2,
            getTitlesWidget: (value, meta) {
              if (value == 0 || value == 5 || value == 10) {
                final percentage = value / 10;
                final days = (percentage * totalDuration).round();
                final date = startDate.add(Duration(days: days));
                final dateLabel = formatDateForAxis(date);

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    dateLabel,
                    style: TextStyle(
                      color:
                          Get.find<ThemeController>().isDarkMode
                              ? Colors.white70
                              : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 10,
      minY: minY,
      maxY: maxY,
      clipData: FlClipData.all(),
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              final percentage = touchedSpot.x / 10;
              final days = (percentage * totalDuration).round();
              final date = startDate.add(Duration(days: days));
              final formattedDate = formatDateForAxis(date);
              final formattedValue = CurrencyFormatter.formatRupee(
                touchedSpot.y * 1000000,
              );

              return LineTooltipItem(
                '$formattedDate\n$formattedValue',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: actualSpots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppColors.darkPrimary,
          barWidth: 3.5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            cutOffY: 0,
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

        if (showProjection)
          LineChartBarData(
            spots: projectionSpots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: Colors.grey.withValues(alpha: 0.6),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            dashArray: const [5, 5],
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
