import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/mf_switch/types/mutual_fund_switch_advise.dart';
import 'package:nwt_app/services/mutual_fund_switch/mf_switch_advice.dart';
import 'package:nwt_app/utils/currency_formatter.dart';
import 'package:nwt_app/widgets/common/custom_checkbox.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class MutualFundSwitchScreen extends StatefulWidget {
  const MutualFundSwitchScreen({super.key});

  @override
  State<MutualFundSwitchScreen> createState() => _MutualFundSwitchScreenState();
}

class MFSwitchChartData {
  final double returns;
  final int years;
  final double regularPlanValue;
  final double directPlanValue;
  final double potentialSavings;

  MFSwitchChartData({
    this.returns = 10.0,
    this.years = 8,
    this.regularPlanValue = 2338180,
    this.directPlanValue = 2544034,
    this.potentialSavings = 205854,
  });

  // Format values for display
  String get formattedRegularPlanValue =>
      CurrencyFormatter.formatRupee(regularPlanValue);
  String get formattedDirectPlanValue =>
      CurrencyFormatter.formatRupee(directPlanValue);
  String get formattedPotentialSavings =>
      CurrencyFormatter.formatRupee(potentialSavings);
  String get formattedGain =>
      "₹${(potentialSavings / 100000).toStringAsFixed(2)}L";
}

class _MutualFundSwitchScreenState extends State<MutualFundSwitchScreen> {
  // Chart data model
  late MFSwitchChartData chartData;

  // Investment parameters
  double returnPercentage = 10.0; // Base return percentage (without commission)
  int investmentYears = 8; // Investment period in years
  final double distributorCommission = 4.0; // Distributor commission percentage

  // Initial investment amount (for calculation purposes)
  final double initialInvestment = 100000.0; // ₹1 Lakh

  // Current marker position (0-10 range for x-axis)
  final double currentMarkerPosition = 5.0;
  MutualFundSwitchAdvise? mfSwitchData;
  @override
  void initState() {
    super.initState();
    initSwitchPlanData();
    _updateChartValues();
  }

  final MutualFundSwitchAdviceService _mutualFundSwitchAdviceService =
      MutualFundSwitchAdviceService();
  bool isSwitchPlanLoading = false;
  void initSwitchPlanData() async {
    final response = await _mutualFundSwitchAdviceService
        .getMutualFundSwitchAdvice(
          onLoading: (isLoading) {
            if (mounted) {
              setState(() {
                isSwitchPlanLoading = isLoading;
              });
            }
          },
        );
    if (response != null) {
      setState(() {
        mfSwitchData = response.data;
      });
    }
  }

  // Update chart values based on current parameters
  void _updateChartValues() {
    // Use actual investment amount if available from API, otherwise use default
    final investment = mfSwitchData?.investment ?? initialInvestment;

    // Calculate direct plan value (with full returns)
    final directPlanValue =
        investment * pow(1 + (returnPercentage / 100), investmentYears);

    // Calculate regular plan value (with reduced returns due to commission)
    final regularPlanValue =
        investment *
        pow(
          1 + ((returnPercentage - distributorCommission) / 100),
          investmentYears,
        );

    // Calculate potential savings
    final potentialSavings = directPlanValue - regularPlanValue;

    // Update chart data model
    chartData = MFSwitchChartData(
      returns: returnPercentage,
      years: investmentYears,
      regularPlanValue: regularPlanValue,
      directPlanValue: directPlanValue,
      potentialSavings: potentialSavings,
    );
  }

  // Returns chart data for FL Chart
  LineChartData getChartData() {
    // Calculate compounded returns for both plans
    // Direct plan gets full return (no distributor commission)
    final double directPlanBaseReturn = returnPercentage;
    // Regular plan has reduced return due to distributor commission
    final double regularPlanBaseReturn =
        returnPercentage - distributorCommission;

    // Calculate the year factor based on investment years
    // This scales the x-axis to show the full investment period
    final double yearFactor = investmentYears / 10.0;

    // Generate data points for direct plan (higher returns)
    final List<FlSpot> directPlanSpots = [];
    for (int i = 0; i <= 10; i++) {
      // Compounded growth formula: P(1+r)^t
      // Starting with a value of 1.0 at x=0
      final double years = i * yearFactor;
      final double value = 1.0 * pow(1 + (directPlanBaseReturn / 100), years);
      directPlanSpots.add(FlSpot(i.toDouble(), value));
    }

    // Generate data points for regular plan (lower returns due to commission)
    final List<FlSpot> regularPlanSpots = [];
    for (int i = 0; i <= 10; i++) {
      // Compounded growth formula: P(1+r)^t
      // Starting with a value of 1.0 at x=0
      final double years = i * yearFactor;
      final double value = 1.0 * pow(1 + (regularPlanBaseReturn / 100), years);
      regularPlanSpots.add(FlSpot(i.toDouble(), value));
    }

    // Find the maximum Y value to set appropriate chart range
    double maxY = 0;
    for (var spot in directPlanSpots) {
      if (spot.y > maxY) maxY = spot.y;
    }
    // Add 10% padding to the top
    maxY = maxY * 1.1;

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 10,
      minY: 1.0, // Start from 1.0 (initial investment)
      maxY: maxY,
      lineTouchData: LineTouchData(enabled: false),
      lineBarsData: [
        // Regular plan line (gray)
        LineChartBarData(
          spots: regularPlanSpots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: Colors.grey.withValues(alpha: 0.7),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.withOpacity(0.5),
                Colors.grey.withOpacity(0.05),
              ],
            ),
          ),
          shadow: const Shadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ),

        // Direct plan line (white, dotted)
        LineChartBarData(
          spots: directPlanSpots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: Colors.white,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          dashArray: const [5, 5], // Make the line dotted
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.4),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          shadow: const Shadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ),
      ],
      // Add a vertical line at the current position
      extraLinesData: ExtraLinesData(
        verticalLines: [
          VerticalLine(
            x: currentMarkerPosition,
            color: Colors.white.withOpacity(0.7),
            strokeWidth: 1.5,
            dashArray: [5, 5],
            label: VerticalLineLabel(show: false),
          ),
        ],
      ),
    );
  }

  final bool _selectAllFunds = false;
  bool _selectedFund = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.chevron_left),
            ),
            AppText(
              "Switch Plan",
              variant: AppTextVariant.headline6,
              weight: AppTextWeight.semiBold,
            ),
            const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSizing.scaffoldHorizontalPadding,
              right: AppSizing.scaffoldHorizontalPadding,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.darkCardBG,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkButtonBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Past Performance",
                        variant: AppTextVariant.bodyLarge,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.primary,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkInputBorder,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.darkButtonBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Invested",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                                AppText(
                                  CurrencyFormatter.formatRupee(
                                    mfSwitchData?.investment ?? 0,
                                  ),
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.bold,
                                  colorType: AppTextColorType.primary,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Held For",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                                AppText(
                                  "${mfSwitchData?.held ?? 0} Years",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.bold,
                                  colorType: AppTextColorType.primary,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Regular Plan value",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                                AppText(
                                  CurrencyFormatter.formatRupee(
                                    mfSwitchData?.regularplanvalue ?? 0,
                                  ),
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.bold,
                                  colorType: AppTextColorType.primary,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Direct Plan value",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                                AppText(
                                  CurrencyFormatter.formatRupee(
                                    mfSwitchData?.directplanvalue ?? 0,
                                  ),
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.bold,
                                  colorType: AppTextColorType.primary,
                                ),
                              ],
                            ),
                            const Divider(
                              color: AppColors.darkTextSecondary,
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Commission Paid",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.error,
                                ),
                                AppText(
                                  CurrencyFormatter.formatRupee(
                                    mfSwitchData?.commissionpaid ?? 0,
                                  ),
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.bold,
                                  colorType: AppTextColorType.error,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.darkCardBG,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkButtonBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Future Opportunity Loss",
                        variant: AppTextVariant.bodyLarge,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.primary,
                      ),
                      const SizedBox(height: 2),
                      AppText(
                        "From now untill you're 60",
                        variant: AppTextVariant.bodySmall,
                        weight: AppTextWeight.semiBold,
                        colorType: AppTextColorType.gray,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // color: AppColors.darkButtonBorder,
                          borderRadius: BorderRadius.circular(12),
                          // border: Border.all(color: AppColors.darkButtonBorder),
                        ),
                        padding: const EdgeInsets.symmetric(
                          // horizontal: 14,
                          // vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Chart legend
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    AppText(
                                      "Direct Plan",
                                      variant: AppTextVariant.bodySmall,
                                      weight: AppTextWeight.medium,
                                      colorType: AppTextColorType.secondary,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 24),
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withValues(
                                          alpha: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    AppText(
                                      "Regular Plan",
                                      variant: AppTextVariant.bodySmall,
                                      weight: AppTextWeight.medium,
                                      colorType: AppTextColorType.secondary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Gain indicator
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText(
                                      "Gain: ",
                                      variant: AppTextVariant.bodySmall,
                                      weight: AppTextWeight.medium,
                                      colorType: AppTextColorType.secondary,
                                    ),
                                    AppText(
                                      chartData.formattedGain,
                                      variant: AppTextVariant.bodySmall,
                                      weight: AppTextWeight.semiBold,
                                      colorType: AppTextColorType.success,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Chart
                            Container(
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.transparent,
                              ),
                              child: Stack(
                                children: [
                                  // FL Chart
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 16,
                                      left: 8,
                                      top: 16,
                                      bottom: 16,
                                    ),
                                    child: LineChart(getChartData()),
                                  ),

                                  // Current point indicator
                                  Positioned(
                                    top: 40,
                                    right: 120,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: AppColors.darkPrimary,
                                          width: 2.5,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.darkPrimary
                                                .withValues(alpha: 0.4),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Returns slider
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Returns",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkButtonBorder,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: AppText(
                                    "${returnPercentage.toStringAsFixed(1)}%",
                                    variant: AppTextVariant.bodySmall,
                                    weight: AppTextWeight.semiBold,
                                    colorType: AppTextColorType.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 6,
                                activeTrackColor: AppColors.darkPrimary,
                                inactiveTrackColor: AppColors.darkButtonBorder,
                                thumbColor: Colors.white,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 10,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 16,
                                ),
                              ),
                              child: Slider(
                                value: returnPercentage,
                                min: 6,
                                max: 20,
                                onChanged: (value) {
                                  setState(() {
                                    returnPercentage = value;
                                    // Update chart values based on new return percentage
                                    _updateChartValues();
                                  });
                                },
                              ),
                            ),

                            // Years slider
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Years",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkButtonBorder,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: AppText(
                                    "$investmentYears Years",
                                    variant: AppTextVariant.bodySmall,
                                    weight: AppTextWeight.semiBold,
                                    colorType: AppTextColorType.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 6,
                                activeTrackColor: AppColors.darkPrimary,
                                inactiveTrackColor: AppColors.darkButtonBorder,
                                thumbColor: Colors.white,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 10,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 16,
                                ),
                              ),
                              child: Slider(
                                value: investmentYears.toDouble(),
                                min: 1,
                                max: 15,
                                onChanged: (value) {
                                  setState(() {
                                    investmentYears = value.toInt();
                                    // Update chart values based on new investment years
                                    _updateChartValues();
                                  });
                                },
                              ),
                            ),

                            // Plan values
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Regular Plan value",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.medium,
                                  colorType: AppTextColorType.secondary,
                                ),
                                AppText(
                                  chartData.formattedRegularPlanValue,
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Direct Plan value",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.medium,
                                  colorType: AppTextColorType.secondary,
                                ),
                                AppText(
                                  chartData.formattedDirectPlanValue,
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                              ],
                            ),
                            const Divider(
                              color: AppColors.darkButtonBorder,
                              height: 24,
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Potential Savings",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.success,
                                ),
                                AppText(
                                  chartData.formattedPotentialSavings,
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.success,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.darkCardBG,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkButtonBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  "Switch Regular to Direct Plans",
                                  variant: AppTextVariant.headline6,
                                  weight: AppTextWeight.bold,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "Long term funds held over 12 months are selected.",
                                        style: TextStyle(
                                          color: AppColors.darkTextSecondary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      TextSpan(
                                        text: " Why?",
                                        style: TextStyle(
                                          color: AppColors.linkColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomCheckbox(
                            value: _selectedFund,
                            onChanged: (value) {
                              setState(() {
                                _selectedFund = value ?? false;
                              });
                            },
                            size: 14,
                            activeColor: AppColors.darkPrimary,
                            checkColor: AppColors.darkBackground,
                            borderWidth: 1,
                            borderColor: AppColors.darkInputText,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Column(
                        spacing: 12,
                        children: [
                          if (mfSwitchData != null &&
                              mfSwitchData!.regtodirplans.isNotEmpty)
                            ...mfSwitchData!.regtodirplans.map((plan) {
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.darkInputBorder,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.darkButtonBorder,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 14,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(
                                            color: AppColors.darkButtonBorder,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.info,
                                            color: AppColors.darkTextSecondary,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          plan.regfundname ??
                                                          "Regular Fund",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .darkPrimary,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " (${plan.regexpratio ?? 0}% expense ratio) ",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .darkTextSecondary,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              AppText(
                                                "Regular Fund",
                                                variant:
                                                    AppTextVariant.bodyMedium,
                                                weight: AppTextWeight.medium,
                                                colorType:
                                                    AppTextColorType.link,
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/svgs/assets/mutual_funds/down_arrow.svg",
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    spacing: 4,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .success
                                                              .withValues(
                                                                alpha: 0.15,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4,
                                                              ),
                                                        ),
                                                        child: AppText(
                                                          "Gain ${CurrencyFormatter.formatRupee(plan.gain)}",
                                                          variant:
                                                              AppTextVariant
                                                                  .bodySmall,
                                                          weight:
                                                              AppTextWeight
                                                                  .bold,
                                                          colorType:
                                                              AppTextColorType
                                                                  .success,
                                                        ),
                                                      ),
                                                      AppText(
                                                        "LTCG Tax Payable ${CurrencyFormatter.formatRupee(plan.ltcgtax)}",
                                                        variant:
                                                            AppTextVariant
                                                                .bodySmall,
                                                        weight:
                                                            AppTextWeight
                                                                .medium,
                                                        colorType:
                                                            AppTextColorType
                                                                .primary,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        CustomCheckbox(
                                          value: false,
                                          onChanged: (value) {
                                            setState(() {
                                              // pfalse;
                                            });
                                          },
                                          size: 14,
                                          activeColor: AppColors.darkPrimary,
                                          checkColor: AppColors.darkBackground,
                                          borderWidth: 1,
                                          borderColor: AppColors.darkInputText,
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(
                                            color: AppColors.darkButtonBorder,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.info,
                                            color: AppColors.darkTextSecondary,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          plan.dirfundname ??
                                                          "Direct Fund",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .darkPrimary,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " (${plan.direxpratio ?? 0}% expense ratio) ",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .darkTextSecondary,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              AppText(
                                                "Direct Fund",
                                                variant:
                                                    AppTextVariant.bodyMedium,
                                                weight: AppTextWeight.medium,
                                                colorType:
                                                    AppTextColorType.link,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          if (mfSwitchData == null ||
                              mfSwitchData!.regtodirplans.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.center,
                              child: const Column(
                                spacing: 16,
                                children: [
                                  CircularProgressIndicator(),
                                  AppText(
                                    "Loading fund data...",
                                    variant: AppTextVariant.bodyMedium,
                                    weight: AppTextWeight.medium,
                                    colorType: AppTextColorType.secondary,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
