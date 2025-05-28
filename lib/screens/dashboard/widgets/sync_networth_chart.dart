import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/screens/dashboard/types/dashboard_networth.dart';
import 'package:nwt_app/utils/currency_formatter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncNetworthChart extends StatelessWidget {
  final bool showProjection;
  final double currentNetworth;
  final double projectedNetworth;
  final List<Currentprojection>? currentprojection;
  final List<Futureprojection>? futureprojection;

  const SyncNetworthChart({
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
              height: 120, // Reduced from 160
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
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_upward_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            CurrencyFormatter.formatRupee(
                              projectedNetworth / 1000,
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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
                      top: 20, // Reduced from 30
                      bottom: 8, // Reduced from 16
                    ),
                    child: _buildChart(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChart() {
    final List<Map<String, dynamic>> chartData = [];
    final now = DateTime.now();
    final theme = Theme.of(Get.context!);

    // Prepare chart data
    final currentData = chartData.where((p) => p['type'] == 'current').toList();
    final futureData = chartData.where((p) => p['type'] == 'future').toList();
    


    // Add current projections
    if (currentprojection != null) {
      for (var point in currentprojection!) {
        chartData.add({
          'date': point.date,
          'value': point.value,
          'type': 'current',
          'isPast': point.date.isBefore(now),
          'formattedDate': DateFormat('MMM d, yyyy').format(point.date),
          'formattedValue':
              '₹${NumberFormat('#,##,##,##0').format(point.value)}',
        });
      }
    }

    // Add future projections
    if (futureprojection != null) {
      for (var point in futureprojection!) {
        chartData.add({
          'date': point.date,
          'value': point.projectedValue,
          'type': 'future',
          'isPast': point.date.isBefore(now),
        });
      }
    }

    // Sort by date
    chartData.sort(
      (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime),
    );

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: EdgeInsets.zero,
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        color: Colors.white,
        borderColor: Colors.black12,
        borderWidth: 1,
        textStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
          final date = DateFormat('MMM d, yyyy').format(DateTime.parse(point.x.toString()));
          final amount = NumberFormat('#,##,##,##0').format(point.y);
          return Text('$date\n₹$amount');
        },
      ),
      crosshairBehavior: CrosshairBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        lineType: CrosshairLineType.both,
        lineWidth: 1,
        lineColor: Theme.of(Get.context!).primaryColor.withOpacity(0.5),
        lineDashArray: const [5, 5],
      ),

      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        tooltipSettings: InteractiveTooltip(
          enable: true,
          color: theme.cardColor,
          borderWidth: 1,
          borderColor: theme.dividerColor,
        ),
        lineColor: theme.primaryColor.withOpacity(0.5),
        lineWidth: 1,
        lineDashArray: const [5, 5],
      ),
      primaryXAxis: DateTimeAxis(
        isVisible: false,
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
      ),
      series: <CartesianSeries>[
        // Current line (solid)
        SplineAreaSeries<Map<String, dynamic>, DateTime>(
          dataSource: currentData,
          xValueMapper: (data, _) => data['date'] as DateTime,
          yValueMapper: (data, _) => data['value'] as double,
          color: Colors.transparent,
          borderColor: Colors.white,
          borderWidth: 1.5,
          markerSettings: const MarkerSettings(isVisible: false),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // Projection line (dashed)
        if (showProjection)
          SplineAreaSeries<Map<String, dynamic>, DateTime>(
            dataSource: futureData,
            xValueMapper: (data, _) => data['date'] as DateTime,
            yValueMapper: (data, _) => data['value'] as double,
            color: Colors.transparent,
            borderColor: Colors.white.withOpacity(0.6),
            borderWidth: 1.5,
            dashArray: const [5, 5],
            markerSettings: const MarkerSettings(isVisible: false),
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.15), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
      ],
    );
  }
}
