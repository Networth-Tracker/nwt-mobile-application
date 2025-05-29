import 'package:flutter/material.dart';
import 'package:nwt_app/screens/dashboard/types/networth_chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncNetworthChart extends StatefulWidget {
  final List<NetworthChartData> chartData;
  final bool showProjection;

  const SyncNetworthChart({
    super.key,
    required this.chartData,
    this.showProjection = true,
  });

  @override
  State<SyncNetworthChart> createState() => _SyncNetworthChartState();
}

class _SyncNetworthChartState extends State<SyncNetworthChart> {
  late TooltipBehavior _tooltipBehavior;
  late CrosshairBehavior _crosshairBehavior;

  @override
  void initState() {
    super.initState();
    _initBehaviors();
  }

  void _initBehaviors() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: true,
      format: 'point.x : ₹point.y',
      color: Colors.black87,
      borderColor: Colors.white,
      borderWidth: 1,
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
    );

    _crosshairBehavior = CrosshairBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      lineType: CrosshairLineType.both,
      lineWidth: 1,
      lineColor: Colors.white.withOpacity(0.5),
      lineDashArray: const [5, 5],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chartData.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(height: 180, child: _buildChart());
  }

  SfCartesianChart _buildChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: EdgeInsets.zero,
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        tooltipSettings: InteractiveTooltip(
          enable: true,
          color: Colors.black87,
          borderWidth: 1,
          borderColor: Colors.white,
        ),
      ),
      crosshairBehavior: _crosshairBehavior,
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
        labelStyle: TextStyle(fontSize: 0), // Hide labels by making font size 0
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(width: 0), // Hide grid lines
      ),
      series: _buildSplineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<SplineAreaSeries<NetworthChartData, String>> _buildSplineSeries() {
    return <SplineAreaSeries<NetworthChartData, String>>[
      SplineAreaSeries<NetworthChartData, String>(
        dataSource: widget.chartData,
        xValueMapper:
            (NetworthChartData data, _) =>
                '${data.date.day}/${data.date.month}',
        yValueMapper: (NetworthChartData data, _) => data.value,
        markerSettings: const MarkerSettings(isVisible: false),
        name: 'Net Worth',
        color: Colors.white,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderColor: Colors.white,
        borderWidth: 2,
        borderDrawMode: BorderDrawMode.top,
        enableTooltip: true,
        animationDuration: 1000,
      ),
    ];
  }
}
