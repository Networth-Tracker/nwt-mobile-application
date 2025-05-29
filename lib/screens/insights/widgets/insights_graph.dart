import 'dart:math';

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

  // Selected time period
  String _selectedPeriod = '1M';

  // Available time periods
  final List<String> _timePeriods = ['1W', '1M', '3M', '6M', '1Y', 'All'];

  @override
  void initState() {
    super.initState();

    // Generate initial chart data for 1M period
    _updateChartDataForPeriod(_selectedPeriod);
  }

  void _updateChartDataForPeriod(String period) {
    // Current date as the end date
    final DateTime endDate = DateTime.now();
    DateTime startDate;

    // Calculate start date based on selected period
    switch (period) {
      case '1W':
        startDate = endDate.subtract(const Duration(days: 7));
        break;
      case '1M':
        startDate = DateTime(endDate.year, endDate.month - 1, endDate.day);
        break;
      case '3M':
        startDate = DateTime(endDate.year, endDate.month - 3, endDate.day);
        break;
      case '6M':
        startDate = DateTime(endDate.year, endDate.month - 6, endDate.day);
        break;
      case '1Y':
        startDate = DateTime(endDate.year - 1, endDate.month, endDate.day);
        break;
      case 'All':
        // For 'All', show 2 years of data
        startDate = DateTime(endDate.year - 2, endDate.month, endDate.day);
        break;
      default:
        startDate = DateTime(
          endDate.year,
          endDate.month - 1,
          endDate.day,
        ); // Default to 1M
    }

    // Generate chart data for the selected period with realistic stock patterns
    _chartData = _generateDataForPeriod(period, startDate, endDate);

    // Update selected period
    _selectedPeriod = period;
  }

  List<FundReturnData> _generateDataForPeriod(
    String period,
    DateTime startDate,
    DateTime endDate,
  ) {
    // Create different data patterns based on the period
    switch (period) {
      case '1W':
        return _generateSimulatedData(
          startDate,
          endDate,
          initialValue: 12.5,
          volatility: 0.15,
          trendStrength: 0.05,
          dataPoints: 7,
        );
      case '1M':
        return _generateSimulatedData(
          startDate,
          endDate,
          initialValue: 11.8,
          volatility: 0.25,
          trendStrength: 0.12,
          dataPoints: 30,
        );
      case '3M':
        return _generateSimulatedData(
          startDate,
          endDate,
          initialValue: 10.5,
          volatility: 0.35,
          trendStrength: 0.18,
          dataPoints: 45,
        );
      case '6M':
        return _generateSimulatedData(
          startDate,
          endDate,
          initialValue: 8.2,
          volatility: 0.45,
          trendStrength: 0.25,
          dataPoints: 60,
        );
      case '1Y':
        return _generateSimulatedData(
          startDate,
          endDate,
          initialValue: 5.0,
          volatility: 0.55,
          trendStrength: 0.35,
          dataPoints: 90,
        );
      case 'All':
        return _generateSimulatedData(
          startDate,
          endDate,
          initialValue: 0.0,
          volatility: 0.65,
          trendStrength: 0.45,
          dataPoints: 120,
        );
      default:
        return _generateSimulatedData(
          startDate,
          endDate,
          initialValue: 11.8,
          volatility: 0.25,
          trendStrength: 0.12,
          dataPoints: 30,
        );
    }
  }

  /// Generates realistic stock-like data using a modified random walk model
  /// with mean reversion and momentum components
  List<FundReturnData> _generateSimulatedData(
    DateTime startDate,
    DateTime endDate, {
    required double initialValue,
    required double volatility,
    required double trendStrength,
    required int dataPoints,
  }) {
    final List<FundReturnData> data = [];
    final int days = endDate.difference(startDate).inDays;
    final int interval = max(1, days ~/ dataPoints);

    // Generate smoother upward trend similar to the second image
    // Base values - start low for a clear upward trend
    double baseReturn = initialValue;
    double baseSipReturn = initialValue * 0.9; // SIP starts slightly lower

    // Create a realistic stock chart pattern
    for (int i = 0; i <= days; i += interval) {
      final DateTime date = startDate.add(Duration(days: i));
      final double progress = i / days; // 0.0 to 1.0 through period

      // Long-term growth component (creates upward trend)
      final double growth = progress * trendStrength * 15.0;

      // Market cycles (creates medium-term waves)
      final double mediumCycle = sin(progress * 4 * pi) * volatility * 0.8;
      final double shortCycle = sin(progress * 12 * pi) * volatility * 0.3;

      // Small random fluctuations (creates natural look)
      final double noise = (Random().nextDouble() - 0.5) * volatility * 0.5;

      // Calculate position on the curve (not daily change)
      // This creates a smoother line like in the second image
      final double position =
          initialValue + growth + mediumCycle + shortCycle + noise;

      // Set the values directly instead of accumulating changes
      // This prevents extreme volatility and creates smoother curves
      baseReturn = position;

      // SIP returns follow a similar pattern but with slight differences
      // to create visual distinction between the lines
      final double sipOffset = sin(progress * 6 * pi) * 0.8 + 0.5;
      baseSipReturn = position + sipOffset;

      // Ensure values stay in reasonable range
      baseReturn = max(0, min(baseReturn, 25.0));
      baseSipReturn = max(0, min(baseSipReturn, 25.0));

      data.add(
        FundReturnData(
          date: date,
          returnValue: double.parse(baseReturn.toStringAsFixed(2)),
          sipReturnValue: double.parse(baseSipReturn.toStringAsFixed(2)),
        ),
      );
    }

    // Ensure we include the end date with a realistic final value
    if (data.isEmpty || data.last.date != endDate) {
      data.add(
        FundReturnData(
          date: endDate,
          returnValue: double.parse((baseReturn + 0.3).toStringAsFixed(2)),
          sipReturnValue: double.parse(
            (baseSipReturn + 0.2).toStringAsFixed(2),
          ),
        ),
      );
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
          const SizedBox(height: 16),
          _buildTimePeriodSelector(),
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

  Widget _buildTimePeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          _timePeriods.map((period) => _buildPeriodButton(period)).toList(),
    );
  }

  Widget _buildPeriodButton(String period) {
    final bool isSelected = period == _selectedPeriod;

    return GestureDetector(
      onTap: () {
        if (period != _selectedPeriod) {
          setState(() {
            _updateChartDataForPeriod(period);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Colors.blue.withValues(alpha: 0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? Colors.blue : Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: AppText(
          period,
          variant: AppTextVariant.bodySmall,
          colorType:
              isSelected ? AppTextColorType.link : AppTextColorType.muted,
          weight: isSelected ? AppTextWeight.semiBold : AppTextWeight.regular,
        ),
      ),
    );
  }

  SfCartesianChart _buildCartesianChart() {
    // Get min and max values from chart data to set appropriate Y-axis range
    double? minValue;
    double? maxValue;

    if (_chartData != null && _chartData!.isNotEmpty) {
      for (final data in _chartData!) {
        // Check regular return value
        if (minValue == null || data.returnValue < minValue) {
          minValue = data.returnValue;
        }
        if (maxValue == null || data.returnValue > maxValue) {
          maxValue = data.returnValue;
        }

        // Check SIP return value
        if (data.sipReturnValue < minValue) {
          minValue = data.sipReturnValue;
        }
        if (data.sipReturnValue > maxValue) {
          maxValue = data.sipReturnValue;
        }
      }
    }

    // Add padding to the min/max values (10% of the range)
    final double range = (maxValue ?? 12) - (minValue ?? 0);
    final double padding = range * 0.1;
    final double yMin = (minValue ?? 0) - padding;
    final double yMax = (maxValue ?? 12) + padding;

    // Configure X-axis interval based on selected period
    int? interval;
    DateFormat? dateFormat;

    switch (_selectedPeriod) {
      case '1W':
        interval = 1; // Show daily labels
        dateFormat = DateFormat.E(); // Day of week (Mon, Tue, etc.)
        break;
      case '1M':
        interval = 7; // Show weekly labels
        dateFormat = DateFormat('d MMM'); // 15 Jan
        break;
      case '3M':
        interval = 14; // Show bi-weekly labels
        dateFormat = DateFormat('d MMM'); // 15 Jan
        break;
      case '6M':
        interval = 30; // Show monthly labels
        dateFormat = DateFormat('MMM'); // Jan, Feb, etc.
        break;
      case '1Y':
        interval = 60; // Show bi-monthly labels
        dateFormat = DateFormat('MMM'); // Jan, Feb, etc.
        break;
      case 'All':
        interval = 90; // Show quarterly labels
        dateFormat = DateFormat('MMM yy'); // Jan 23, Apr 23, etc.
        break;
    }

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(0),
      trackballBehavior: _trackballBehavior,
      tooltipBehavior: _tooltipBehavior,
      enableAxisAnimation: true,
      key: ValueKey<String>(_selectedPeriod), // Force rebuild on period change

      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: const TextStyle(color: Colors.white70),
        dateFormat: dateFormat,
        labelIntersectAction: AxisLabelIntersectAction.hide,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        rangePadding: ChartRangePadding.none,
        interval: interval?.toDouble(),
        autoScrollingDelta: _chartData?.length,
        autoScrollingMode: AutoScrollingMode.end,
      ),
      primaryYAxis: NumericAxis(
        minimum: yMin,
        maximum: yMax,
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
        animationDuration: 500, // Faster animation
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
        animationDuration: 500, // Faster animation
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
