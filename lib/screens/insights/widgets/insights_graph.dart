import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InsightsGraphWidget extends StatefulWidget {
  const InsightsGraphWidget({super.key});

  @override
  State<InsightsGraphWidget> createState() => _InsightsGraphWidgetState();
}

class _InsightsGraphWidgetState extends State<InsightsGraphWidget> {
  List<FundReturnData>? _chartData;
  late TrackballBehavior _trackballBehavior;
  final String _fundName = 'Franklin India Opportunities Fund Regular Growth';
  final String _fundType = 'Equity Fund';
  final String _navValue = '₹8.6';
  final double _returnPercentage = 0.7;

  // Tooltip behavior
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();

    // Generate sample data for the chart
    final DateTime startDate = DateTime(2025, 3, 16);
    final DateTime endDate = DateTime(2025, 5, 16);

    _chartData = _generateChartData(startDate, endDate);
  }

  List<FundReturnData> _generateChartData(
    DateTime startDate,
    DateTime endDate,
  ) {
    List<FundReturnData> data = [];

    // Generate data points between start and end dates
    DateTime currentDate = startDate;

    // Define control points for the spline curves
    final List<double> returnsPoints = [
      -2.0,
      -1.5,
      -0.5,
      1.0,
      2.5,
      4.0,
      3.0,
      4.5,
      6.0,
      8.0,
      10.0,
    ];

    final List<double> sipReturnsPoints = [
      -1.0,
      0.0,
      2.0,
      3.5,
      2.5,
      1.5,
      3.0,
      5.0,
      4.0,
      6.0,
      7.0,
    ];

    // Generate data points with 3-day intervals
    int i = 0;
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      double returnValue = returnsPoints[i % returnsPoints.length];
      double sipReturnValue = sipReturnsPoints[i % sipReturnsPoints.length];

      data.add(
        FundReturnData(
          date: currentDate,
          returnValue: returnValue,
          sipReturnValue: sipReturnValue,
        ),
      );

      currentDate = currentDate.add(const Duration(days: 3));
      i++;
    }

    return data;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initBehaviors();
  }

  void _initBehaviors() {
    // Configure trackball behavior
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
      lineType: TrackballLineType.vertical,
      lineWidth: 1,
      lineColor: Colors.grey.withValues(alpha: 0.5),
      lineDashArray: const [5, 5],
      shouldAlwaysShow: true,
    );

    // Configure default tooltip behavior
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      // Show tooltip on tap
      activationMode: ActivationMode.singleTap,
      // Format the tooltip text
      format: 'point.x : point.y%',
      // Style the tooltip
      color: Colors.black,
      borderColor: Colors.grey.shade800,
      borderWidth: 1,
      textStyle: const TextStyle(color: Colors.white),
      // Keep tooltip visible
      duration: 3000,
      canShowMarker: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          _buildFundType(),
          const SizedBox(height: 16),
          _buildLegend(),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: _buildCartesianChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: AppText(
            _fundName,
            variant: AppTextVariant.headline3,
            colorType: AppTextColorType.primary,
            weight: AppTextWeight.semiBold,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            lineHeight: 1.3,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(
              'NAV $_navValue',
              variant: AppTextVariant.bodyMedium,
              colorType: AppTextColorType.primary,
              weight: AppTextWeight.semiBold,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: AppText(
                '+ ${_returnPercentage.toStringAsFixed(1)}%',
                variant: AppTextVariant.bodyMedium,
                colorType: AppTextColorType.success,
                weight: AppTextWeight.semiBold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFundType() {
    return AppText(
      _fundType,
      variant: AppTextVariant.bodyMedium,
      colorType: AppTextColorType.link,
      weight: AppTextWeight.semiBold,
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _buildLegendItem('Returns', const Color(0xFFB176E2)),
        const SizedBox(width: 16),
        _buildLegendItem('SIP Returns', const Color(0xFFFFDD55)),
      ],
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(0),
      trackballBehavior: _trackballBehavior,
      tooltipBehavior: _tooltipBehavior,

      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        dateFormat: DateFormat('dd-MM-yyyy'),
        intervalType: DateTimeIntervalType.days,
        interval: 15,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      primaryYAxis: NumericAxis(
        minimum: -3,
        maximum: 12,
        isVisible: false,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      series: _buildSplineSeries(),
      legend: const Legend(isVisible: false),
    );
  }

  /// Returns the list of Cartesian Spline series.
  List<CartesianSeries> _buildSplineSeries() {
    return <CartesianSeries>[
      SplineSeries<FundReturnData, DateTime>(
        dataSource: _chartData!,
        xValueMapper: (FundReturnData data, _) => data.date,
        yValueMapper: (FundReturnData data, _) => data.returnValue,
        name: 'Returns',
        color: const Color(0xFFB176E2),
        width: 3,
        splineType: SplineType.natural,
        markerSettings: const MarkerSettings(isVisible: false),
        animationDuration: 1500,
      ),
      SplineSeries<FundReturnData, DateTime>(
        dataSource: _chartData!,
        xValueMapper: (FundReturnData data, _) => data.date,
        yValueMapper: (FundReturnData data, _) => data.sipReturnValue,
        name: 'SIP Returns',
        color: const Color(0xFFFFDD55),
        width: 3,
        splineType: SplineType.natural,
        markerSettings: const MarkerSettings(isVisible: false),
        animationDuration: 1500,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData?.clear();
    super.dispose();
  }
}

/// Data model for fund return data points
class FundReturnData {
  FundReturnData({
    required this.date,
    required this.returnValue,
    required this.sipReturnValue,
  });

  /// Date of the data point
  final DateTime date;

  /// Regular return value
  final double returnValue;

  /// SIP return value
  final double sipReturnValue;
}
