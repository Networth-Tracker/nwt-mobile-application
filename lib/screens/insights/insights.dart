import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/insights/widgets/dividend_history_widget.dart';
import 'package:nwt_app/screens/insights/widgets/fund_details_widget.dart';
import 'package:nwt_app/screens/insights/widgets/sector_allocation_widget.dart';
import 'package:nwt_app/screens/insights/widgets/sip_details_widget.dart';
import 'package:nwt_app/screens/insights/widgets/top_holdings_widget.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.scaffoldHorizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              FundDetailsWidget(
                invested: '₹1,50,000',
                current: '₹1,65,000',
                gain: '₹15,000',
                gainPercentage: '+10%',
                expenseRatio: '1.10%',
                folioNo: '123456789',
                turnover: '0.45%',
                investmentStyle: 'Large Growth',
                fundManager: 'R. Janakiraman',
                aum: '₹1,70,50,000',
                exitLoad: '1% (90 days)',
                investedSince: '12 Jan, 2022',
              ),
              const SipDetailsWidget(
                sipAmount: '₹1,000',
                sipDates: '1st',
                frequency: 'Monthly, Quarterly',
                lockInPeriod: 'None',
              ),
              SectorAllocationWidget(
                sectorItems: [
                  SectorItem(
                    name: 'Financial Services',
                    percentage: 30,
                    progressColor: const Color(0xFF36D399),
                  ),
                  SectorItem(
                    name: 'Tech',
                    percentage: 25,
                    progressColor: const Color(0xFFF87272),
                  ),
                  SectorItem(
                    name: 'Industrial',
                    percentage: 25,
                    progressColor: const Color(0xFF8B5CF6),
                  ),
                  SectorItem(
                    name: 'Real Estate',
                    percentage: 10,
                    progressColor: const Color(0xFF3ABFF8),
                  ),
                  SectorItem(
                    name: 'Health',
                    percentage: 5,
                    progressColor: const Color(0xFFFBBD23),
                  ),
                  SectorItem(
                    name: 'Utilities',
                    percentage: 40,
                    progressColor: const Color(0xFFD926AA),
                  ),
                ],
              ),
              DividendHistoryWidget(
                dividendItems: [
                  DividendItem(
                    plan: 'IDCW',
                    recordDate: '25, May 2025',
                    dividend: '13.480',
                  ),
                ],
              ),
              TopHoldingsWidget(
                holdingItems: [
                  HoldingItem(
                    name: 'Kotak Mahindra Bank Ltd',
                    logoUrl:
                        'https://companieslogo.com/img/orig/KOTAKBANK.NS-36440c5e.png',
                    percentage: 4.31,
                    logoBackground: AppColors.darkInputBorder,
                  ),
                  HoldingItem(
                    name: 'Bajaj Finserv Ltd',
                    logoUrl:
                        'https://companieslogo.com/img/orig/BAJAJFINSV.NS-8a52a659.png',
                    percentage: 4.20,
                    logoBackground: AppColors.darkInputBorder,
                  ),
                  HoldingItem(
                    name: 'Piramal Pharma Ltd',
                    logoUrl:
                        'https://companieslogo.com/img/orig/PPLPHARMA.NS-e6a7c7df.png',
                    percentage: 3.55,
                    logoBackground: AppColors.darkInputBorder,
                  ),
                  HoldingItem(
                    name: 'Ashok Leyland Ltd',
                    logoUrl:
                        'https://companieslogo.com/img/orig/ASHOKLEY.NS-d6aec723.png',
                    percentage: 3.15,
                    logoBackground: AppColors.darkInputBorder,
                  ),
                  HoldingItem(
                    name: 'Vedanta Ltd',
                    logoUrl:
                        'https://companieslogo.com/img/orig/VEDL.NS-6d8bce2a.png',
                    percentage: 3.50,
                    logoBackground: AppColors.darkInputBorder,
                  ),
                  HoldingItem(
                    name: 'HDFC Bank Ltd',
                    logoUrl:
                        'https://companieslogo.com/img/orig/HDB-bb6241fe.png',
                    percentage: 3.05,
                    logoBackground: AppColors.darkInputBorder,
                  ),
                  HoldingItem(
                    name: 'Reliance Industries Ltd',
                    logoUrl:
                        'https://companieslogo.com/img/orig/RELIANCE.NS-6d1e1fe2.png',
                    percentage: 2.95,
                    logoBackground: AppColors.darkInputBorder,
                  ),
                ],
              ),

              //   AssetAllocationWidget(
              //     assetItems: const [
              //       AssetItem(
              //         name: 'Equity',
              //         percentage: 65,
              //       ),
              //       AssetItem(
              //         name: 'Debt',
              //         percentage: 15,
              //       ),
              //       AssetItem(
              //         name: 'Hybrid',
              //         percentage: 20,
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
