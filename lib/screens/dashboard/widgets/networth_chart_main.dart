import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nwt_app/screens/dashboard/types/dashboard_networth.dart';
import 'package:nwt_app/utils/currency_formatter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NetworthChartMain extends StatefulWidget {
  final List<Currentprojection> currentProjection;
  final List<Futureprojection>? futureProjection;
  final bool isLoading;

  const NetworthChartMain({
    super.key,
    required this.currentProjection,
    this.futureProjection,
    this.isLoading = false,
  });

  @override
  State<NetworthChartMain> createState() => _NetworthChartMainState();
}

class _NetworthChartMainState extends State<NetworthChartMain> {
  List<NetworthData> chartData = [];
  List<NetworthData> futureChartData = [];
  TrackballBehavior? _trackballBehavior;

  @override
  void initState() {
    super.initState();
    _processData();
  }

  @override
  void didUpdateWidget(NetworthChartMain oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentProjection != widget.currentProjection ||
        oldWidget.futureProjection != widget.futureProjection) {
      _processData();
    }
  }

  void _processData() {
    setState(() {
      // Process current projection data
      if (widget.currentProjection.isNotEmpty) {
        chartData =
            widget.currentProjection.map((data) {
              // Check if this data point is today or closest to today
              final isToday = _isDateEqualOrClosestToToday(
                data.date,
                widget.currentProjection,
              );
              return NetworthData(data.date, data.value, isToday: isToday);
            }).toList();
      } else {
        chartData = [];
      }

      // Process future projection data
      if (widget.futureProjection != null &&
          widget.futureProjection!.isNotEmpty) {
        // Create future projection data
        List<NetworthData> futureProjData =
            widget.futureProjection!
                .map((data) => NetworthData(data.date, data.projectedValue))
                .toList();

        // Store future projection for separate series
        futureChartData = futureProjData;

        // We're not adding future data to chartData anymore
        // This way we can have separate styling for each series
      } else {
        futureChartData = [];
      }

      _initializeTrackballBehavior();
    });
  }

  // Helper method to get today's point for the scatter series
  List<NetworthData> _getTodayPoint() {
    // If there are no data points, return an empty list
    if (chartData.isEmpty) {
      return [];
    }

    // Find the point marked as today
    final todayPoint = chartData.firstWhere(
      (data) => data.isToday,
      orElse:
          () => chartData.last, // Use the last point if no today point is found
    );

    // Return a list with just the today point
    return [todayPoint];
  }

  // Helper method to check if a date is today or closest to today
  bool _isDateEqualOrClosestToToday(
    DateTime date,
    List<Currentprojection> projections,
  ) {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // If the date is today, return true
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return true;
    }

    // Find the closest date to today
    DateTime? closestDate;
    int minDifference = 999999;

    for (var projection in projections) {
      final difference = (projection.date.difference(today).inDays).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestDate = projection.date;
      }
    }

    // Check if this date is the closest to today
    return closestDate != null &&
        date.year == closestDate.year &&
        date.month == closestDate.month &&
        date.day == closestDate.day;
  }

  // Helper method to create connected future data that starts from the last point of current data
  List<NetworthData> _createConnectedFutureData(
    List<NetworthData> currentData,
    List<NetworthData> futureData,
  ) {
    if (currentData.isEmpty || futureData.isEmpty) {
      return futureData;
    }

    // Get the last point from current data as the starting point
    final lastCurrentPoint = currentData.last;

    // Create a new list with the last current point + all future points
    final result = <NetworthData>[lastCurrentPoint];

    // Add future points that come after the last current point
    result.addAll(
      futureData.where((data) => data.date.isAfter(lastCurrentPoint.date)),
    );

    // Sort by date
    result.sort((a, b) => a.date.compareTo(b.date));

    return result;
  }

  void _initializeTrackballBehavior() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
      activationMode: ActivationMode.singleTap,
      lineType: TrackballLineType.vertical,
      lineColor: Colors.white.withValues(alpha: 0.2),
      lineWidth: 1,
      // Hide the marker dot
      markerSettings: const TrackballMarkerSettings(
        markerVisibility: TrackballVisibilityMode.hidden,
        height: 0,
        width: 0,
        borderWidth: 0,
      ),
      tooltipSettings: const InteractiveTooltip(
        enable: true,
        color: Color(0xFF1C1C1E),
        borderWidth: 0,
        borderColor: Colors.transparent,
        borderRadius: 8,
      ),
      shouldAlwaysShow: false,
      builder: (BuildContext context, TrackballDetails trackballDetails) {
        if (trackballDetails.point == null) {
          return Container();
        }
        // Use the actual data from the chart point
        final CartesianChartPoint<dynamic> chartPoint = trackballDetails.point!;
        final DateTime pointDate = chartPoint.x as DateTime;
        final double pointAmount = chartPoint.y as double;

        // Determine if this is a future projection point
        final bool isFuturePoint = futureChartData.any(
          (data) =>
              data.date.year == pointDate.year &&
              data.date.month == pointDate.month &&
              data.date.day == pointDate.day,
        );

        // Find the previous data point for comparison
        double? previousAmount;
        bool isPositive = false;
        double changePercent = 0;
        double changeValue = 0;

        // Get appropriate data source based on whether it's a future point
        final dataSource =
            isFuturePoint
                ? _createConnectedFutureData(chartData, futureChartData)
                : chartData;

        // Find the index in the appropriate data source
        int dataIndex = dataSource.indexWhere(
          (data) =>
              data.date.year == pointDate.year &&
              data.date.month == pointDate.month &&
              data.date.day == pointDate.day,
        );

        if (dataIndex > 0 && dataIndex < dataSource.length) {
          previousAmount = dataSource[dataIndex - 1].amount;
          isPositive = pointAmount > previousAmount;
          changeValue = (pointAmount - previousAmount).abs();
          changePercent =
              previousAmount > 0
                  ? ((pointAmount - previousAmount) / previousAmount * 100)
                      .abs()
                  : 0;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount value
              Text(
                CurrencyFormatter.formatRupee(pointAmount),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              // Show delta if we have previous data
              if (dataIndex > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    // Show percentage change
                    Text(
                      '${changePercent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Show absolute change value
                    Text(
                      CurrencyFormatter.formatRupee(changeValue),
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 4),
              // Date
              Text(
                DateFormat('dd MMM yyyy').format(pointDate),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              // Show 'Projected' label for future points
              if (isFuturePoint) ...[
                const SizedBox(height: 2),
                const Text(
                  'Projected',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child:
          widget.isLoading || (chartData.isEmpty && futureChartData.isEmpty)
              ? const Center(child: CircularProgressIndicator())
              : SfCartesianChart(
                plotAreaBorderWidth: 0,
                margin: const EdgeInsets.all(0),
                primaryXAxis: DateTimeAxis(
                  majorGridLines: const MajorGridLines(
                    width: 0.5,
                    color: Colors.transparent,
                    dashArray: <double>[5, 5],
                  ),
                  intervalType: DateTimeIntervalType.months,
                  interval: 2,
                  dateFormat: DateFormat('MMM'),
                  axisLine: const AxisLine(width: 0.5, color: Colors.grey),
                  labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                  majorTickLines: const MajorTickLines(
                    size: 4,
                    color: Colors.grey,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 0.5,
                    color: Colors.transparent,
                    dashArray: <double>[5, 5],
                  ),
                  axisLine: const AxisLine(width: 0.0, color: Colors.grey),
                  labelStyle: const TextStyle(fontSize: 0, color: Colors.grey),
                  majorTickLines: const MajorTickLines(
                    size: 0,
                    color: Colors.grey,
                  ),
                  numberFormat: NumberFormat.compactCurrency(
                    locale: 'en_IN',
                    symbol: '₹',
                    decimalDigits: 0,
                  ),
                ),
                trackballBehavior: _trackballBehavior!,
                series: <CartesianSeries<NetworthData, DateTime>>[
                  // Current projection area series
                  AreaSeries<NetworthData, DateTime>(
                    name: 'Current Projection',
                    dataSource: chartData,
                    xValueMapper: (NetworthData data, _) => data.date,
                    yValueMapper: (NetworthData data, _) => data.amount,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                    borderColor: Colors.white,
                    borderWidth: 2,
                    markerSettings: const MarkerSettings(
                      isVisible: false,
                      height: 8,
                      width: 8,
                      shape: DataMarkerType.circle,
                      borderWidth: 2,
                      borderColor: Colors.white,
                      color: Colors.transparent,
                    ),
                  ),
                  // Future projection area series with dashed border
                  if (futureChartData.isNotEmpty && chartData.isNotEmpty)
                    AreaSeries<NetworthData, DateTime>(
                      name: 'Future Projection',
                      dataSource: _createConnectedFutureData(
                        chartData,
                        futureChartData,
                      ),
                      xValueMapper: (NetworthData data, _) => data.date,
                      yValueMapper: (NetworthData data, _) => data.amount,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                      borderColor: Colors.white,
                      borderWidth: 0, // No border for the area
                    ),
                  // Dashed line for future projection
                  if (futureChartData.isNotEmpty)
                    LineSeries<NetworthData, DateTime>(
                      name: 'Future Line',
                      dataSource: _createConnectedFutureData(
                        chartData,
                        futureChartData,
                      ),
                      xValueMapper: (NetworthData data, _) => data.date,
                      yValueMapper: (NetworthData data, _) => data.amount,
                      color: Colors.white,
                      width: 2,
                      dashArray: const <double>[5, 8],
                      markerSettings: const MarkerSettings(isVisible: false),
                    ),
                  // Today's point marker
                  ScatterSeries<NetworthData, DateTime>(
                    name: 'Today',
                    dataSource: _getTodayPoint(),
                    xValueMapper: (NetworthData data, _) => data.date,
                    yValueMapper: (NetworthData data, _) => data.amount,
                    color: Colors.white, // Explicitly set the point color
                    markerSettings: const MarkerSettings(
                      height: 12,
                      width: 12,
                      shape: DataMarkerType.circle,
                      borderWidth: 2,
                      borderColor: Colors.white,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
    );
  }
}

class NetworthData {
  final DateTime date;
  final double amount;
  final bool isToday;

  NetworthData(this.date, this.amount, {this.isToday = false});
}
