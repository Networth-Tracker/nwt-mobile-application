import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'
    show
        SfCartesianChart,
        CategoryAxis,
        NumericAxis,
        ChartTitle,
        Legend,
        TooltipBehavior,
        CrosshairBehavior,
        CrosshairLineType,
        TrackballBehavior,
        ActivationMode,
        TrackballDisplayMode,
        InteractiveTooltip,
        MajorGridLines,
        MajorTickLines,
        AxisLine,
        LabelPlacement,
        EdgeLabelPlacement,
        MarkerSettings,
        SplineAreaSeries,
        BorderDrawMode;

class InsightsGraphWidget extends StatefulWidget {
  const InsightsGraphWidget({super.key});

  @override
  State<InsightsGraphWidget> createState() => _InsightsGraphWidgetState();
}

class _InsightsGraphWidgetState extends State<InsightsGraphWidget> {
  List<ChartSampleData>? _chartData;
  late TooltipBehavior _tooltipBehavior;
  late CrosshairBehavior _crosshairBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Jan',
        y: 43,
        secondSeriesYValue: 37,
        thirdSeriesYValue: 41,
      ),
      ChartSampleData(
        x: 'Feb',
        y: 45,
        secondSeriesYValue: 37,
        thirdSeriesYValue: 45,
      ),
      ChartSampleData(
        x: 'Mar',
        y: 50,
        secondSeriesYValue: 39,
        thirdSeriesYValue: 48,
      ),
      ChartSampleData(
        x: 'Apr',
        y: 55,
        secondSeriesYValue: 43,
        thirdSeriesYValue: 52,
      ),
      ChartSampleData(
        x: 'May',
        y: 63,
        secondSeriesYValue: 48,
        thirdSeriesYValue: 57,
      ),
      ChartSampleData(
        x: 'Jun',
        y: 68,
        secondSeriesYValue: 54,
        thirdSeriesYValue: 61,
      ),
      ChartSampleData(
        x: 'Jul',
        y: 72,
        secondSeriesYValue: 57,
        thirdSeriesYValue: 66,
      ),
      ChartSampleData(
        x: 'Aug',
        y: 70,
        secondSeriesYValue: 57,
        thirdSeriesYValue: 66,
      ),
      ChartSampleData(
        x: 'Sep',
        y: 66,
        secondSeriesYValue: 54,
        thirdSeriesYValue: 63,
      ),
      ChartSampleData(
        x: 'Oct',
        y: 57,
        secondSeriesYValue: 48,
        thirdSeriesYValue: 55,
      ),
      ChartSampleData(
        x: 'Nov',
        y: 50,
        secondSeriesYValue: 43,
        thirdSeriesYValue: 50,
      ),
      ChartSampleData(
        x: 'Dec',
        y: 45,
        secondSeriesYValue: 37,
        thirdSeriesYValue: 45,
      ),
    ];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initBehaviors();
  }

  void _initBehaviors() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: true,
      activationMode: ActivationMode.singleTap,
      format: 'point.x : point.y',
      color: Theme.of(context).cardColor,
      borderColor: Theme.of(context).primaryColor,
      borderWidth: 2,
      textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );

    _crosshairBehavior = CrosshairBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      lineType: CrosshairLineType.both,
      lineWidth: 1,
      lineColor: Theme.of(context).primaryColor.withOpacity(0.5),
      lineDashArray: const [5, 5],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _buildCartesianChart());
  }

  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        tooltipSettings: InteractiveTooltip(
          enable: true,
          color: Theme.of(context).cardColor,
          borderWidth: 1,
          borderColor: Theme.of(context).dividerColor,
        ),
      ),
      crosshairBehavior: _crosshairBehavior,
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelPlacement: LabelPlacement.onTicks,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      primaryYAxis: const NumericAxis(
        minimum: 30,
        maximum: 80,
        isVisible: false,
        axisLine: AxisLine(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorTickLines: MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(width: 0),
      ),
      series: _buildSplineSeries(),
      legend: Legend(isVisible: true, isResponsive: true),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Spline series.
  List<SplineAreaSeries<ChartSampleData, String>> _buildSplineSeries() {
    return <SplineAreaSeries<ChartSampleData, String>>[
      SplineAreaSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        markerSettings: const MarkerSettings(isVisible: false),
        name: 'High',
        color: Colors.blue,
        gradient: LinearGradient(
          colors: [Colors.blue.withOpacity(0.8), Colors.transparent],
          stops: const [0.0, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderColor: Colors.blue,
        borderWidth: 2,
        borderDrawMode: BorderDrawMode.top,
        enableTooltip: true,
        animationDuration: 1000,
      ),
      SplineAreaSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper:
            (ChartSampleData sales, int index) => sales.secondSeriesYValue,
        markerSettings: const MarkerSettings(isVisible: false),
        name: 'Low',
        color: Colors.red.withOpacity(0.5),
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.3),
            Colors.red.withOpacity(0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderColor: Colors.red,
        borderWidth: 2,
        borderDrawMode: BorderDrawMode.top,
        enableTooltip: true,
        animationDuration: 1000,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData({
    this.x,
    this.y,
    this.xValue,
    this.yValue,
    this.secondSeriesYValue,
    this.thirdSeriesYValue,
    this.pointColor,
    this.size,
    this.text,
    this.open,
    this.close,
    this.low,
    this.high,
    this.volume,
  });

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}
