import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/insights/types/insights.dart';
import 'package:nwt_app/screens/insights/widgets/asset_allocation_widget.dart';
import 'package:nwt_app/screens/insights/widgets/dividend_history_widget.dart';
import 'package:nwt_app/screens/insights/widgets/fund_details_widget.dart';
import 'package:nwt_app/screens/insights/widgets/funds_distribution_widget.dart';
import 'package:nwt_app/screens/insights/widgets/insights_graph.dart';
import 'package:nwt_app/screens/insights/widgets/riskometer_widget.dart';
import 'package:nwt_app/screens/insights/widgets/sector_allocation_widget.dart';
import 'package:nwt_app/screens/insights/widgets/sip_details_widget.dart';
import 'package:nwt_app/screens/insights/widgets/top_holdings_widget.dart';
import 'package:nwt_app/services/insights/insights.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class InsightsScreen extends StatefulWidget {
  final String? fundId;
  
  const InsightsScreen({super.key, this.fundId});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final InsightsService _insightsService = InsightsService();
  bool _isLoading = true;
  InsightsSummary? _insightData;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _fetchInsightsData();
  }
  
  Future<void> _fetchInsightsData() async {
    if (widget.fundId == null) {
      // If no fund ID is provided, fetch general insights
      final response = await _insightsService.getMFInsights(
        onLoading: (isLoading) {
          setState(() {
            _isLoading = isLoading;
          });
        },
      );
      
      if (response != null && response.data != null) {
        setState(() {
          _insightData = response.data;
        });
      } else {
        setState(() {
          _error = 'Failed to load insights data';
        });
      }
    } else {
      // Fetch insights for specific fund ID
      final data = await _insightsService.getSpecificFundInsights(
        onLoading: (isLoading) {
          setState(() {
            _isLoading = isLoading;
          });
        },
        fundId: widget.fundId!,
      );
      
      if (data != null) {
        setState(() {
          _insightData = data;
        });
      } else {
        setState(() {
          _error = 'Failed to load insights for this fund';
        });
      }
    }
  }
  
  // Helper method to convert month number to month name
  String _getMonthName(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }
  
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
              "Insights",
              variant: AppTextVariant.headline6,
              weight: AppTextWeight.semiBold,
            ),
            const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
          ],
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          _error!,
                          variant: AppTextVariant.headline4,
                          weight: AppTextWeight.medium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchInsightsData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizing.scaffoldHorizontalPadding,
                    ),
                    child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: InsightsGraphWidget(
                  fundName: _insightData!.fundname,
                  fundType: _insightData!.fundtype,
                  navValue: _insightData!.nav,
                  returnPercentage: double.tryParse(_insightData!.navdelta) ?? 0.0,
                  // Regular return data
                  oneMonthData: _insightsService.getOneMonthPerformanceData(),
                  threeMonthData: _insightsService.getThreeMonthPerformanceData(),
                  sixMonthData: _insightsService.getSixMonthPerformanceData(),
                  oneYearData: _insightsService.getOneYearPerformanceData(),
                  fiveYearData: _insightsService.getFiveYearPerformanceData(),
                  tenYearData: _insightsService.getTenYearPerformanceData(),
                  // SIP return data
                  sipOneMonthData: _insightsService.getSipOneMonthPerformanceData(),
                  sipThreeMonthData: _insightsService.getSipThreeMonthPerformanceData(),
                  sipSixMonthData: _insightsService.getSipSixMonthPerformanceData(),
                  sipOneYearData: _insightsService.getSipOneYearPerformanceData(),
                  sipFiveYearData: _insightsService.getSipFiveYearPerformanceData(),
                  sipTenYearData: _insightsService.getSipTenYearPerformanceData(),
                ),
              ),
              FundDetailsWidget(
                expenseRatio: _insightData!.funddetail.expenseratio.toString() + '%',
                churnValue: _insightData!.funddetail.churn.toString() + '%',
                investmentStyle: _insightData!.funddetail.investmentstyle,
                fundManager: _insightData!.funddetail.fundmanager,
                aum: '₹' + _insightData!.funddetail.aum.toString(),
                exitLoad: _insightData!.funddetail.exitload,
              ),

              AssetAllocationWidget(
                assetItems: [
                  AssetItem(
                    name: 'Equity',
                    percentage: _insightData!.assetallocation.equity,
                    color: const Color(0xFF36D399),
                  ),
                  AssetItem(
                    name: 'Debt',
                    percentage: _insightData!.assetallocation.debt,
                    color: const Color(0xFF8B5CF6),
                  ),
                  AssetItem(
                    name: 'Hybrid',
                    percentage: _insightData!.assetallocation.hybrid,
                    color: const Color(0xFFFFC000),
                  ),
                ],
              ),

              SipDetailsWidget(
                minimumSip: '₹' + _insightData!.sipdetail.minimumsip.toString(),
                maximumSip: '₹' + _insightData!.sipdetail.maximumsip.toString(),
                frequency: _insightData!.sipdetail.frequency,
                lockInPeriod: _insightData!.sipdetail.lockinperiod,
              ),

              FundsDistributionWidget(
                equityDistribution: {
                  'midcap': _insightData!.funddistributionequity.midcap,
                  'largecap': _insightData!.funddistributionequity.largecap,
                  'smallcap': _insightData!.funddistributionequity.smallcap,
                },
                debtCashDistribution: {
                  'aaa': _insightData!.funddistributiondebtcash.aaa,
                },
              ),

              SectorAllocationWidget(
                sectorItems: [
                  SectorItem(
                    name: 'Financial Services',
                    percentage: _insightData!.sectorallocation.financialservices,
                    progressColor: const Color(0xFF36D399),
                  ),
                  SectorItem(
                    name: 'Tech',
                    percentage: _insightData!.sectorallocation.tech,
                    progressColor: const Color(0xFFF87272),
                  ),
                  SectorItem(
                    name: 'Industrial',
                    percentage: _insightData!.sectorallocation.industrial,
                    progressColor: const Color(0xFF8B5CF6),
                  ),
                  SectorItem(
                    name: 'Real Estate',
                    percentage: _insightData!.sectorallocation.realestate,
                    progressColor: const Color(0xFF3ABFF8),
                  ),
                  SectorItem(
                    name: 'Health',
                    percentage: _insightData!.sectorallocation.health,
                    progressColor: const Color(0xFFFBBD23),
                  ),
                  SectorItem(
                    name: 'Utilities',
                    percentage: _insightData!.sectorallocation.utilities,
                    progressColor: const Color(0xFFD926AA),
                  ),
                ],
              ),

              DividendHistoryWidget(
                dividendItems: _insightData!.dividendhistory
                    .map((dividend) => DividendItem(
                          recordDate: "${dividend.recorddate.day} ${_getMonthName(dividend.recorddate.month)} ${dividend.recorddate.year}",
                          dividend: dividend.dividend.toString(),
                        ))
                    .toList(),
              ),
              TopHoldingsWidget(
                holdingItems: _insightData!.top20Holding
                    .map((holding) => HoldingItem(
                          name: holding.name,
                          logoUrl: 'https://companieslogo.com/img/orig/KOTAKBANK.NS-36440c5e.png', // Default logo as API doesn't provide logos
                          percentage: holding.value,
                          logoBackground: AppColors.darkInputBorder,
                        ))
                    .toList(),
              ),

              RiskometerWidget(
                riskLevel: _insightData!.riskometer.name,
                riskValue: 30, // Default value as API doesn't provide risk value
              ),
            ],
          ),
        ),
      ),
    );
  }
}
