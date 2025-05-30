import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/screens/dashboard/types/dashboard_networth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final DateTime date;
  final double value;
  final bool isProjection;

  ChartData({
    required this.date,
    required this.value,
    required this.isProjection,
  });
}

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
    if (currentprojection == null && futureprojection == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No data available')),
      );
    }

    final now = DateTime.now();
    
    // Pre-filter future projections
    final filteredFutureProjections = futureprojection
        ?.where((data) => data.date.isAfter(now))
        .toList();

    // Calculate date range
    final startDate = currentprojection?.firstOrNull?.date ?? 
        DateTime.now().subtract(const Duration(days: 365));
    final endDate = filteredFutureProjections?.lastOrNull?.date ?? 
        DateTime.now().add(const Duration(days: 365));

    return SizedBox(
      height: 200,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: const EdgeInsets.all(0),
        primaryXAxis: DateTimeAxis(
          isVisible: false,
          minimum: startDate,
          maximum: endDate,
          intervalType: DateTimeIntervalType.months,
          interval: 3,
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
          minimum: 0,
          interval: 10,
          axisLine: const AxisLine(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
        ),
        series: <CartesianSeries>[
          // Actual data series
          SplineAreaSeries<Currentprojection, DateTime>(
            dataSource: currentprojection ?? [],
            xValueMapper: (Currentprojection data, _) => data.date,
            yValueMapper: (Currentprojection data, _) => data.value,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.darkPrimary.withOpacity(0.5),
                AppColors.darkPrimary.withOpacity(0.1),
              ],
            ),
            borderColor: AppColors.darkPrimary,
            borderWidth: 2,
            enableTooltip: true,
            markerSettings: const MarkerSettings(
              isVisible: true,
              height: 6,
              width: 6,
              shape: DataMarkerType.circle,
              borderWidth: 2,
              borderColor: Colors.white,
            ),
          ),
          // Projection series
          if (showProjection)
            SplineSeries<Futureprojection, DateTime>(
              dataSource: filteredFutureProjections ?? [],
              xValueMapper: (Futureprojection data, _) => data.date,
              yValueMapper: (Futureprojection data, _) => data.projectedValue,
              color: Colors.grey.withOpacity(0.6),
              width: 2.5,
              dashArray: const <double>[5, 5],
              enableTooltip: true,
              markerSettings: const MarkerSettings(
                isVisible: true,
                height: 4,
                width: 4,
                shape: DataMarkerType.circle,
                borderWidth: 1,
                borderColor: Colors.grey,
              ),
            ),
        ],

        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: '',
          tooltipPosition: TooltipPosition.pointer,
          canShowMarker: true,
          shared: true,
          builder: (
            dynamic data,
            dynamic point,
            dynamic series,
            int pointIndex,
            int seriesIndex,
          ) {
            final ChartData chartData = data;
            final value = chartData.value;
            final date = DateFormat('dd MMM yyyy').format(chartData.date);
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs. ${value.toStringAsFixed(2)} M',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
