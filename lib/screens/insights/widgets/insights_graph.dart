import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/screens/insights/types/insights.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InsightsGraphWidget extends StatefulWidget {
  final String fundName;
  final String fundType;
  final double navValue;
  final double returnPercentage;
  // Regular return data
  final List<MFPerformanceDataPoint> oneMonthData;
  final List<MFPerformanceDataPoint> threeMonthData;
  final List<MFPerformanceDataPoint> sixMonthData;
  final List<MFPerformanceDataPoint> oneYearData;
  final List<MFPerformanceDataPoint> fiveYearData;
  final List<MFPerformanceDataPoint> tenYearData;
  // SIP return data
  final List<MFPerformanceDataPoint> sipOneMonthData;
  final List<MFPerformanceDataPoint> sipThreeMonthData;
  final List<MFPerformanceDataPoint> sipSixMonthData;
  final List<MFPerformanceDataPoint> sipOneYearData;
  final List<MFPerformanceDataPoint> sipFiveYearData;
  final List<MFPerformanceDataPoint> sipTenYearData;

  const InsightsGraphWidget({
    super.key,
    required this.fundName,
    required this.fundType,
    required this.navValue,
    required this.returnPercentage,
    required this.oneMonthData,
    required this.threeMonthData,
    required this.sixMonthData,
    required this.oneYearData,
    required this.fiveYearData,
    required this.tenYearData,
    required this.sipOneMonthData,
    required this.sipThreeMonthData,
    required this.sipSixMonthData,
    required this.sipOneYearData,
    required this.sipFiveYearData,
    required this.sipTenYearData,
  });

  @override
  State<InsightsGraphWidget> createState() => _InsightsGraphWidgetState();
}

class _InsightsGraphWidgetState extends State<InsightsGraphWidget> {
  List<FundReturnData>? _chartData;
  late TrackballBehavior _trackballBehavior;
  String get _fundName => widget.fundName;
  String get _fundType => widget.fundType;
  double get _navValue => widget.navValue;
  double get _returnPercentage => widget.returnPercentage;

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
    // Use real data from the service based on the selected period
    _chartData = _getDataForPeriod(period);

    // Update selected period
    _selectedPeriod = period;
  }

  List<FundReturnData> _getDataForPeriod(String period) {
    // Use real data from the service based on the selected period
    List<MFPerformanceDataPoint> regularDataPoints;
    List<MFPerformanceDataPoint> sipDataPoints;

    switch (period) {
      case '1W':
        // For 1W, we'll use a subset of 1M data
        regularDataPoints =
            widget.oneMonthData.isNotEmpty
                ? widget.oneMonthData.sublist(
                  0,
                  widget.oneMonthData.length > 7
                      ? 7
                      : widget.oneMonthData.length,
                )
                : [];
        sipDataPoints =
            widget.sipOneMonthData.isNotEmpty
                ? widget.sipOneMonthData.sublist(
                  0,
                  widget.sipOneMonthData.length > 7
                      ? 7
                      : widget.sipOneMonthData.length,
                )
                : [];
        break;
      case '1M':
        regularDataPoints = widget.oneMonthData;
        sipDataPoints = widget.sipOneMonthData;
        break;
      case '3M':
        regularDataPoints = widget.threeMonthData;
        sipDataPoints = widget.sipThreeMonthData;
        break;
      case '6M':
        regularDataPoints = widget.sixMonthData;
        sipDataPoints = widget.sipSixMonthData;
        break;
      case '1Y':
        regularDataPoints = widget.oneYearData;
        sipDataPoints = widget.sipOneYearData;
        break;
      case 'All':
        // For 'All', we'll use a combination of data
        regularDataPoints =
            widget.tenYearData.isNotEmpty
                ? widget.tenYearData
                : widget.fiveYearData.isNotEmpty
                ? widget.fiveYearData
                : widget.oneYearData;
        sipDataPoints =
            widget.sipTenYearData.isNotEmpty
                ? widget.sipTenYearData
                : widget.sipFiveYearData.isNotEmpty
                ? widget.sipFiveYearData
                : widget.sipOneYearData;
        break;
      default:
        regularDataPoints = widget.oneMonthData;
        sipDataPoints = widget.sipOneMonthData;
    }

    // If we have no data, generate some simulated data
    if (regularDataPoints.isEmpty) {
      return _generateSimulatedData(
        DateTime.now().subtract(const Duration(days: 30)),
        DateTime.now(),
        initialValue: 10.0,
        volatility: 0.25,
        trendStrength: 0.12,
        dataPoints: 30,
      );
    }

    // Create a map to quickly look up SIP data points by date
    final Map<String, double> sipValuesByDate = {};
    for (final point in sipDataPoints) {
      sipValuesByDate[point.date] = point.value;
    }

    // Convert MFPerformanceDataPoint to FundReturnData
    return regularDataPoints.map((point) {
      return FundReturnData(
        date: point.date,
        returnValue: point.value,
        sipReturnValue:
            sipValuesByDate[point.date] ?? 0.0, // Use SIP value if available
      );
    }).toList();
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
          date:
              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
          returnValue: double.parse(baseReturn.toStringAsFixed(2)),
          sipReturnValue: double.parse(baseSipReturn.toStringAsFixed(2)),
        ),
      );
    }

    // Ensure we include the end date with a realistic final value
    if (data.isEmpty ||
        data.last.date !=
            "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}") {
      data.add(
        FundReturnData(
          date:
              "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions based on available width
        final double availableWidth = constraints.maxWidth;
        // Adjust chart height based on available width for better aspect ratio
        final double chartHeight = availableWidth < 400 ? 250 : 300;

        return Container(
          padding: EdgeInsets.all(availableWidth < 350 ? 12 : 16),
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
                height: chartHeight,
                width: double.infinity,
                child: _buildCartesianChart(),
              ),
              const SizedBox(height: 16),
              _buildTimePeriodSelector(availableWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we're in a narrow layout
        final bool isNarrow = constraints.maxWidth < 350;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: AppText(
                _fundName,
                variant:
                    isNarrow
                        ? AppTextVariant.headline4
                        : AppTextVariant.headline3,
                colorType: AppTextColorType.primary,
                weight: AppTextWeight.semiBold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                lineHeight: 1.3,
              ),
            ),
            SizedBox(width: isNarrow ? 8 : 16),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'NAV ',
                          style: TextStyle(
                            color: AppColors.lightSecondary,
                            fontFamily: 'Montserrat',
                            fontSize: isNarrow ? 12 : 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: '₹${_navValue.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppColors.darkTextPrimary,
                            fontFamily: 'Montserrat',
                            fontSize: isNarrow ? 12 : 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isNarrow ? 6 : 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AppText(
                      '+ ${_returnPercentage.toStringAsFixed(1)}%',
                      variant:
                          isNarrow
                              ? AppTextVariant.bodySmall
                              : AppTextVariant.bodyMedium,
                      colorType: AppTextColorType.success,
                      weight: AppTextWeight.semiBold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we're in a narrow layout
        final bool isNarrow = constraints.maxWidth < 350;

        return Row(
          children: [
            _buildLegendItem('Returns', const Color(0xFFB176E2), isNarrow),
            SizedBox(width: isNarrow ? 10 : 16),
            _buildLegendItem('SIP Returns', const Color(0xFFFFDD55), isNarrow),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(String title, Color color, [bool isNarrow = false]) {
    return Row(
      children: [
        Container(
          width: isNarrow ? 10 : 12,
          height: isNarrow ? 10 : 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: isNarrow ? 6 : 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isNarrow ? 12 : 14,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildTimePeriodSelector([double availableWidth = double.infinity]) {
    // Adjust the layout based on available width
    final bool isNarrow = availableWidth < 350;

    return Wrap(
      spacing: isNarrow ? 6 : 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children:
          _timePeriods
              .map((period) => _buildPeriodButton(period, isNarrow))
              .toList(),
    );
  }

  Widget _buildPeriodButton(String period, [bool isNarrow = false]) {
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
        // Adjust padding based on available space
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? 8 : 12,
          vertical: 6,
        ),
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

    // Add more padding to the min/max values (15% of the range) to keep lines inside visible area
    final double range = (maxValue ?? 12) - (minValue ?? 0);
    final double padding = range * 0.15;
    final double yMin = (minValue ?? 0) - padding;
    final double yMax = (maxValue ?? 12) + padding;

    // Configure X-axis interval based on selected period
    int? interval;

    switch (_selectedPeriod) {
      case '1W':
        interval = 1; // Show daily labels
        break;
      case '1M':
        interval = 7; // Show weekly labels
        break;
      case '3M':
        interval = 14; // Show bi-weekly labels
        break;
      case '6M':
        interval = 30; // Show monthly labels
        break;
      case '1Y':
        interval = 60; // Show bi-monthly labels
        break;
      case 'All':
        interval = 90; // Show quarterly labels
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

      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: const TextStyle(color: Colors.white70),
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
        // Add proper padding to ensure lines stay within visible area
        rangePadding: ChartRangePadding.additional,
      ),
      // Add plot area border padding to contain the graph lines
      plotAreaBorderColor: Colors.transparent,
      plotAreaBackgroundColor: Colors.transparent,
      series: _buildSplineSeries(),
      legend: const Legend(isVisible: false),
    );
  }

  /// Returns the list of Cartesian Spline series.
  List<CartesianSeries> _buildSplineSeries() {
    return <CartesianSeries>[
      SplineSeries<FundReturnData, String>(
        dataSource: _chartData!,
        xValueMapper: (FundReturnData data, _) => data.date,
        yValueMapper: (FundReturnData data, _) => data.returnValue,
        name: 'Returns',
        color: const Color(0xFFB176E2),
        width: 3,
        splineType: SplineType.natural,
        markerSettings: const MarkerSettings(isVisible: false),
        animationDuration: 500, // Faster animation
        // Ensure lines stay within chart boundaries
        enableTooltip: true,
        isVisibleInLegend: false,
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
      ),
      SplineSeries<FundReturnData, String>(
        dataSource: _chartData!,
        xValueMapper: (FundReturnData data, _) => data.date,
        yValueMapper: (FundReturnData data, _) => data.sipReturnValue,
        name: 'SIP Returns',
        color: const Color(0xFFFFDD55),
        width: 3,
        splineType: SplineType.natural,
        markerSettings: const MarkerSettings(isVisible: false),
        animationDuration: 500, // Faster animation
        // Ensure lines stay within chart boundaries
        enableTooltip: true,
        isVisibleInLegend: false,
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
      ),
    ];
  }

  @override
  void dispose() {
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
  final String date;

  /// Regular return value
  final double returnValue;

  /// SIP return value
  final double sipReturnValue;
}
