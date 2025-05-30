import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nwt_app/screens/dashboard/types/dashboard_networth.dart';
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
            widget.currentProjection
                .map((data) => NetworthData(data.date, data.value))
                .toList();
      } else {
        chartData = [];
      }

      // Process future projection data
      if (widget.futureProjection != null &&
          widget.futureProjection!.isNotEmpty) {
        futureChartData =
            widget.futureProjection!
                .map((data) => NetworthData(data.date, data.projectedValue))
                .toList();
      } else {
        futureChartData = [];
      }

      _initializeTrackballBehavior();
    });
  }

  void _initializeTrackballBehavior() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
      activationMode: ActivationMode.singleTap,
      lineType: TrackballLineType.vertical,
      lineColor: Colors.white.withValues(alpha: 0.2),
      lineWidth: 1,
      markerSettings: const TrackballMarkerSettings(
        markerVisibility: TrackballVisibilityMode.visible,
        height: 10,
        width: 10,
        borderWidth: 1,
      ),
      tooltipSettings: const InteractiveTooltip(
        enable: true,
        color: Color(0xFF1C1C1E),
      ),
      shouldAlwaysShow: false,
      builder: (BuildContext context, TrackballDetails trackballDetails) {
        if (trackballDetails.point == null) {
          return Container();
        }

        final int index = trackballDetails.pointIndex ?? 0;
        // Use the actual data from the chart point
        final CartesianChartPoint<dynamic> chartPoint = trackballDetails.point!;
        final DateTime pointDate = chartPoint.x as DateTime;
        final double pointAmount = chartPoint.y as double;
        final NetworthData data = NetworthData(pointDate, pointAmount);
        // Find the previous data point for comparison
        double? previousAmount;
        bool isPositive = false;
        double changePercent = 0;

        if (index > 0 && index < chartData.length) {
          previousAmount = chartData[index - 1].amount;
          isPositive = data.amount > previousAmount;
          changePercent =
              previousAmount > 0
                  ? ((data.amount - previousAmount) / previousAmount * 100)
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
              Text(
                NumberFormat.currency(
                  locale: 'en_IN',
                  symbol: '₹',
                  decimalDigits: 0,
                ).format(data.amount),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              if (index > 0) ...[
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
                    Text(
                      '${changePercent.toStringAsFixed(1)}%',
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
              Text(
                DateFormat('dd MMM yyyy').format(data.date),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child:
          widget.isLoading || (chartData.isEmpty && futureChartData.isEmpty)
              ? const Center(child: CircularProgressIndicator())
              : SfCartesianChart(
                plotAreaBorderWidth: 0,
                margin: const EdgeInsets.all(0),
                primaryXAxis: DateTimeAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                  labelStyle: const TextStyle(fontSize: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                  labelStyle: const TextStyle(fontSize: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                trackballBehavior: _trackballBehavior!,
                series: <CartesianSeries<NetworthData, DateTime>>[
                  // Current projection series
                  if (chartData.isNotEmpty)
                    AreaSeries<NetworthData, DateTime>(
                      name: 'Current Projection',
                      dataSource: chartData,
                      xValueMapper: (NetworthData data, _) => data.date,
                      yValueMapper: (NetworthData data, _) => data.amount,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      borderColor: Colors.white,
                      borderWidth: 2,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        height: 8,
                        width: 8,
                        shape: DataMarkerType.circle,
                        borderWidth: 2,
                        borderColor: Colors.white,
                        color: Colors.transparent,
                      ),
                    ),
                  // Future projection series
                  if (futureChartData.isNotEmpty)
                    AreaSeries<NetworthData, DateTime>(
                      name: 'Future Projection',
                      dataSource: futureChartData,
                      xValueMapper: (NetworthData data, _) => data.date,
                      yValueMapper: (NetworthData data, _) => data.amount,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      borderColor: Colors.white,
                      borderWidth: 2,
                      dashArray: const <double>[5, 3],
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        height: 8,
                        width: 8,
                        shape: DataMarkerType.circle,
                        borderWidth: 2,
                        borderColor: Colors.white,
                        color: Colors.transparent,
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

  NetworthData(this.date, this.amount);
}
