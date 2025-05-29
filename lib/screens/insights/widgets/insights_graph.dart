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

  List<FundReturnData> _generateHalfYearlyData(
    DateTime startDate,
    DateTime endDate,
  ) {
    // Half-yearly data with realistic market cycles and corrections
    final List<FundReturnData> data = [];
    final int days = endDate.difference(startDate).inDays;
    final int dataPoints = min(days, 60); // Cap at 60 points for half-year view
    final int interval = max(1, days ~/ dataPoints);

    // Starting values - realistic for a half-yearly view
    double baseReturn = 5.2; // 5.2% return
    double baseSipReturn = 6.4; // 6.4% SIP return

    // Half-yearly pattern typically includes:
    // 1. Initial trend continuation from previous period
    // 2. At least one significant correction (5-10%)
    // 3. Recovery phase
    // 4. New trend establishment

    // Define key market events for this period
    final List<Map<String, dynamic>> marketEvents = [
      {
        'position': 0.22, // 22% into the period
        'duration': 0.06, // Lasts for 6% of the period
        'type': 'correction',
        'magnitude': -0.8, // Significant correction
        'description': 'Market correction due to inflation concerns',
      },
      {
        'position': 0.45, // 45% into the period
        'duration': 0.08, // Lasts for 8% of the period
        'type': 'rally',
        'magnitude': 1.2, // Strong rally
        'description': 'Rally following positive economic data',
      },
      {
        'position': 0.68, // 68% into the period
        'duration': 0.05, // Lasts for 5% of the period
        'type': 'correction',
        'magnitude': -0.6, // Moderate correction
        'description': 'Profit-taking after extended rally',
      },
      {
        'position': 0.85, // 85% into the period
        'duration': 0.12, // Lasts for 12% of the period
        'type': 'rally',
        'magnitude': 0.9, // End-of-period rally
        'description': 'Year-end positioning',
      },
    ];

    // Create a realistic pattern with defined market events
    for (int i = 0; i <= days; i += interval) {
      final DateTime date = startDate.add(Duration(days: i));
      final double progress = i / days; // 0.0 to 1.0 through period

      // Base trend - slight upward bias with noise
      double baseChange = 0.08 + (Random().nextDouble() - 0.5) * 0.15;

      // Check if we're in a market event period
      for (final event in marketEvents) {
        final double eventStart = event['position'];
        final double eventEnd = eventStart + event['duration'];

        if (progress >= eventStart && progress <= eventEnd) {
          // We're in an event period
          final double eventProgress =
              (progress - eventStart) / event['duration'];
          double eventEffect;

          if (event['type'] == 'correction') {
            // Corrections typically start sharp and then moderate
            if (eventProgress < 0.3) {
              // Sharp initial drop
              eventEffect = event['magnitude'] * 0.6 * (1.0 - eventProgress);
            } else if (eventProgress < 0.7) {
              // Continued but moderating decline
              eventEffect = event['magnitude'] * 0.3 * (1.0 - eventProgress);
            } else {
              // Bottoming process
              eventEffect =
                  event['magnitude'] * 0.1 * (1.0 - eventProgress * 2);
            }
          } else {
            // Rally
            // Rallies typically build momentum and then plateau
            if (eventProgress < 0.4) {
              // Building momentum
              eventEffect = event['magnitude'] * 0.4 * eventProgress;
            } else if (eventProgress < 0.8) {
              // Strong momentum
              eventEffect = event['magnitude'] * 0.5;
            } else {
              // Fading momentum
              eventEffect =
                  event['magnitude'] * 0.3 * (1.0 - (eventProgress - 0.8) * 5);
            }
          }

          baseChange += eventEffect;
          break; // Only apply one event at a time
        }
      }

      // Apply market changes
      baseReturn += baseChange;
      // SIP returns typically perform differently during corrections and rallies
      if (baseChange < -0.2) {
        // During sharp corrections, SIP often outperforms
        baseSipReturn += baseChange * 0.7; // Less downside
      } else if (baseChange > 0.3) {
        // During strong rallies, SIP might slightly underperform
        baseSipReturn += baseChange * 0.9;
      } else {
        // During normal periods, SIP often outperforms slightly
        baseSipReturn += baseChange * 1.1;
      }

      data.add(
        FundReturnData(
          date: date,
          returnValue: double.parse(max(0, baseReturn).toStringAsFixed(2)),
          sipReturnValue: double.parse(
            max(1.0, baseSipReturn).toStringAsFixed(2),
          ),
        ),
      );
    }

    // Ensure we include the end date with a realistic final value
    if (data.isEmpty || data.last.date != endDate) {
      data.add(
        FundReturnData(
          date: endDate,
          returnValue: double.parse(
            max(0, baseReturn + 0.2).toStringAsFixed(2),
          ),
          sipReturnValue: double.parse(
            max(1.0, baseSipReturn + 0.3).toStringAsFixed(2),
          ),
        ),
      );
    }

    return data;
  }

  List<FundReturnData> _generateYearlyData(
    DateTime startDate,
    DateTime endDate,
  ) {
    // Yearly data with realistic market cycles and seasonal patterns
    final List<FundReturnData> data = [];
    final int days = endDate.difference(startDate).inDays;
    final int dataPoints = min(days, 90); // Cap at 90 points for year view
    final int interval = max(1, days ~/ dataPoints);

    // Starting values - realistic for a yearly view
    double baseReturn = 4.0; // 4.0% return
    double baseSipReturn = 5.2; // 5.2% SIP return

    // Yearly pattern typically includes:
    // 1. Seasonal patterns (January effect, summer lull, tax-loss selling, etc.)
    // 2. Multiple market cycles
    // 3. At least one major correction (10%+)
    // 4. Sector rotations throughout the year

    // Create a realistic yearly pattern with seasonal effects
    for (int i = 0; i <= days; i += interval) {
      final DateTime date = startDate.add(Duration(days: i));
      final int month =
          ((startDate.month - 1 + (i ~/ 30)) % 12) + 1; // Approximate month
      final double monthProgress =
          (i % 30) / 30.0; // Progress through the month (0.0-1.0)

      // Base change with some randomness
      double change = 0.0;

      // Apply seasonal patterns
      switch (month) {
        case 1: // January
          // January effect - typically positive
          change = 0.25 + (Random().nextDouble() * 0.2);
          break;

        case 2: // February
          // Often volatile
          change = -0.1 + (Random().nextDouble() * 0.5);
          break;

        case 3: // March
          // End of Q1 positioning
          if (monthProgress < 0.7) {
            change = 0.15 + (Random().nextDouble() * 0.2);
          } else {
            change =
                -0.1 + (Random().nextDouble() * 0.3); // Quarter-end volatility
          }
          break;

        case 4: // April
          // Historically positive month
          change = 0.2 + (Random().nextDouble() * 0.15);
          break;

        case 5: // May
          // "Sell in May" effect
          change = -0.2 + (Random().nextDouble() * 0.3);
          break;

        case 6: // June
          // Summer doldrums begin
          change = -0.05 + (Random().nextDouble() * 0.2);
          break;

        case 7: // July
          // Summer trading - often low volume
          change = 0.1 + (Random().nextDouble() * 0.15);
          break;

        case 8: // August
          // Often volatile summer month
          change = -0.15 + (Random().nextDouble() * 0.4);
          break;

        case 9: // September
          // Historically weakest month
          change = -0.3 + (Random().nextDouble() * 0.4);
          break;

        case 10: // October
          // Historically volatile but often marks bottoms
          if (monthProgress < 0.4) {
            change =
                -0.4 + (Random().nextDouble() * 0.3); // Early month weakness
          } else {
            change = 0.3 + (Random().nextDouble() * 0.3); // Late month recovery
          }
          break;

        case 11: // November
          // Start of seasonal strength
          change = 0.25 + (Random().nextDouble() * 0.2);
          break;

        case 12: // December
          // Santa Claus rally
          change = 0.3 + (Random().nextDouble() * 0.2);
          break;

        default:
          change = 0.0;
      }

      // Add a major market correction (happens once during the year)
      final double yearProgress = i / days;
      if (yearProgress > 0.4 && yearProgress < 0.5) {
        // Major correction around mid-year
        change -= 0.4 + (Random().nextDouble() * 0.3);
      }

      // Apply market changes
      baseReturn += change;

      // SIP returns typically show different characteristics in different market conditions
      // During corrections, SIP often performs better due to rupee cost averaging
      if (change < -0.2) {
        baseSipReturn += change * 0.6; // Less downside
      } else if (change > 0.2) {
        baseSipReturn += change * 0.9; // Slightly less upside
      } else {
        baseSipReturn += change * 1.05; // Slightly better in sideways markets
      }

      data.add(
        FundReturnData(
          date: date,
          returnValue: double.parse(max(0, baseReturn).toStringAsFixed(2)),
          sipReturnValue: double.parse(
            max(1.0, baseSipReturn).toStringAsFixed(2),
          ),
        ),
      );
    }

    // Ensure we include the end date with a realistic final value
    if (data.isEmpty || data.last.date != endDate) {
      data.add(
        FundReturnData(
          date: endDate,
          returnValue: double.parse(
            max(0, baseReturn + 0.3).toStringAsFixed(2),
          ),
          sipReturnValue: double.parse(
            max(1.0, baseSipReturn + 0.4).toStringAsFixed(2),
          ),
        ),
      );
    }

    return data;
  }

  List<FundReturnData> _generateAllTimeData(
    DateTime startDate,
    DateTime endDate,
  ) {
    // All-time (2 years) data with realistic long-term market cycles
    final List<FundReturnData> data = [];
    final int days = endDate.difference(startDate).inDays;
    final int dataPoints = min(
      days,
      120,
    ); // Cap at 120 points for all-time view
    final int interval = max(1, days ~/ dataPoints);

    // Starting values - realistic for a long-term view
    double baseReturn = 2.5; // 2.5% return
    double baseSipReturn = 3.8; // 3.8% SIP return

    // Long-term pattern typically includes:
    // 1. Multiple market cycles (bull and bear markets)
    // 2. Major economic events and policy changes
    // 3. Sector rotations and changing market leadership
    // 4. Long-term upward bias (for equity markets)

    // Define major market regimes/phases for the 2-year period
    final List<Map<String, dynamic>> marketRegimes = [
      {
        'start': 0.0,
        'end': 0.2,
        'type': 'bull', // Early bull market
        'trend': 0.3,
        'volatility': 0.15,
        'description': 'Early bull market phase with strong momentum',
      },
      {
        'start': 0.2,
        'end': 0.35,
        'type': 'correction', // Significant correction
        'trend': -0.2,
        'volatility': 0.25,
        'description': 'Market correction due to valuation concerns',
      },
      {
        'start': 0.35,
        'end': 0.55,
        'type': 'consolidation', // Sideways market
        'trend': 0.05,
        'volatility': 0.12,
        'description': 'Consolidation phase after correction',
      },
      {
        'start': 0.55,
        'end': 0.7,
        'type': 'bull', // Renewed bull market
        'trend': 0.25,
        'volatility': 0.18,
        'description': 'Renewed bull market on economic strength',
      },
      {
        'start': 0.7,
        'end': 0.85,
        'type': 'bear', // Bear market
        'trend': -0.3,
        'volatility': 0.3,
        'description': 'Bear market due to economic slowdown concerns',
      },
      {
        'start': 0.85,
        'end': 1.0,
        'type': 'recovery', // Recovery phase
        'trend': 0.4,
        'volatility': 0.2,
        'description': 'Recovery phase on policy support',
      },
    ];

    // Define specific major market events
    final List<Map<String, dynamic>> majorEvents = [
      {
        'position': 0.23, // 23% into the period
        'impact': -2.5,
        'duration': 0.03, // Lasts for 3% of the period
        'description': 'Major policy announcement',
      },
      {
        'position': 0.48, // 48% into the period
        'impact': 1.8,
        'duration': 0.02, // Lasts for 2% of the period
        'description': 'Positive economic surprise',
      },
      {
        'position': 0.72, // 72% into the period
        'impact': -3.0,
        'duration': 0.04, // Lasts for 4% of the period
        'description': 'Global market shock',
      },
      {
        'position': 0.88, // 88% into the period
        'impact': 2.5,
        'duration': 0.03, // Lasts for 3% of the period
        'description': 'Major stimulus announcement',
      },
    ];

    // Create a realistic long-term pattern
    for (int i = 0; i <= days; i += interval) {
      final DateTime date = startDate.add(Duration(days: i));
      final double progress = i / days; // 0.0 to 1.0 through the entire period

      // Determine which market regime we're in
      Map<String, dynamic>? currentRegime;
      for (final regime in marketRegimes) {
        if (progress >= regime['start'] && progress < regime['end']) {
          currentRegime = regime;
          break;
        }
      }

      // Base change based on the current market regime
      double change = 0.0;
      if (currentRegime != null) {
        final double regimeProgress =
            (progress - currentRegime['start']) /
            (currentRegime['end'] - currentRegime['start']);

        // Base trend for this regime
        double regimeTrend = currentRegime['trend'] / dataPoints * 5;

        // Add regime-specific patterns
        if (currentRegime['type'] == 'bull') {
          // Bull markets often have stronger early gains that moderate
          regimeTrend *= (1.0 - regimeProgress * 0.3);
        } else if (currentRegime['type'] == 'bear') {
          // Bear markets often have accelerating declines
          regimeTrend *= (1.0 + regimeProgress * 0.5);
        } else if (currentRegime['type'] == 'recovery') {
          // Recoveries often start strong and then normalize
          regimeTrend *= (1.0 - regimeProgress * 0.4);
        }

        // Add regime-specific volatility
        final double volatility = currentRegime['volatility'];
        final double noise = (Random().nextDouble() - 0.5) * volatility;

        change = regimeTrend + noise;
      }

      // Check for major market events
      for (final event in majorEvents) {
        final double eventStart = event['position'];
        final double eventEnd = eventStart + event['duration'];

        if (progress >= eventStart && progress < eventEnd) {
          // We're in a major event
          final double eventProgress =
              (progress - eventStart) / event['duration'];
          double eventImpact;

          if (event['impact'] < 0) {
            // Negative events often hit hard and fast
            if (eventProgress < 0.3) {
              eventImpact = event['impact'] * 0.7 * (1.0 - eventProgress);
            } else {
              eventImpact = event['impact'] * 0.3 * (1.0 - eventProgress);
            }
          } else {
            // Positive events often build more gradually
            if (eventProgress < 0.5) {
              eventImpact = event['impact'] * eventProgress;
            } else {
              eventImpact = event['impact'] * (1.0 - eventProgress);
            }
          }

          change += eventImpact / dataPoints * 10;
          break; // Only apply one major event at a time
        }
      }

      // Apply market changes
      baseReturn += change;

      // SIP returns show different characteristics in different market regimes
      if (currentRegime != null) {
        if (currentRegime['type'] == 'bear' ||
            currentRegime['type'] == 'correction') {
          // SIP performs better in down markets due to rupee cost averaging
          baseSipReturn += change * 0.7;
        } else if (currentRegime['type'] == 'bull') {
          // SIP might slightly underperform in strong bull markets
          baseSipReturn += change * 0.9;
        } else {
          // SIP often outperforms slightly in sideways/consolidation markets
          baseSipReturn += change * 1.1;
        }
      } else {
        baseSipReturn += change;
      }

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
          returnValue: double.parse((baseReturn + 0.5).toStringAsFixed(2)),
          sipReturnValue: double.parse(
            (baseSipReturn + 0.7).toStringAsFixed(2),
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
