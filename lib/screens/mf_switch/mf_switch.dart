import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/screens/mf_switch/widgets/mf_accordion.dart';
import 'package:nwt_app/screens/mf_switch/widgets/plan_summary_card.dart';
import 'package:nwt_app/screens/mf_switch/widgets/switch_fund_card.dart';

class MutualFundSwitchScreen extends StatefulWidget {
  const MutualFundSwitchScreen({super.key});

  @override
  State<MutualFundSwitchScreen> createState() => _MutualFundSwitchScreenState();
}

class _MutualFundSwitchScreenState extends State<MutualFundSwitchScreen> {
  bool _isLoading = false;
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
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSizing.scaffoldHorizontalPadding,
              right: AppSizing.scaffoldHorizontalPadding,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.darkCardBG,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkButtonBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Potential Lifetime Savings",
                        variant: AppTextVariant.headline4,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.primary,
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            "₹1,00,000",
                            variant: AppTextVariant.display,
                            weight: AppTextWeight.bold,
                            colorType: AppTextColorType.primary,
                          ),
                          Icon(
                            Icons.visibility_outlined,
                            color: AppColors.darkButtonPrimaryBackground,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardBG,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.darkButtonBorder),
                        ),
                        child: Column(
                          children: [
                            AppText(
                              "Regular Fund Expense Ratio",
                              variant: AppTextVariant.headline6,
                              weight: AppTextWeight.medium,
                              colorType: AppTextColorType.primary,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            AppText(
                              "2.10%",
                              variant: AppTextVariant.headline4,
                              weight: AppTextWeight.medium,
                              colorType: AppTextColorType.error,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardBG,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.darkButtonBorder),
                        ),
                        child: Column(
                          children: [
                            AppText(
                              "Direct Fund Expense Ratio",
                              variant: AppTextVariant.headline6,
                              weight: AppTextWeight.medium,
                              colorType: AppTextColorType.primary,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            AppText(
                              "0.65%",
                              variant: AppTextVariant.headline4,
                              weight: AppTextWeight.medium,
                              colorType: AppTextColorType.success,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                MFAccordion(
                  title: "Direct Plan Summary",
                  initiallyExpanded: true,
                  child: PlanSummaryCard(
                    totalInvested: 24.05,
                    avgInvestedPeriod: "3 Years",
                    currentValue: 10.05,
                    additionalEarnings: 2.05,
                  ),
                ),
                const SizedBox(height: 16),
                MFAccordion(
                  title: "Switch Regular to Direct Plans",
                  initiallyExpanded: true,
                  child: Column(
                    children: [
                     SwitchFundCard(
                        fundName: "Kotak Emerging Equity Scheme",
                        fundType: "Regular Fund",
                        commission: "0.45% commission",
                        gainAmount: 102000,
                        targetFundName: "Kotak Emerging Fund Direct Growth",
                        targetFundType: "Direct Fund",
                        targetCommission: "No commission",
                        fundIconUrl: "https://s3-symbol-logo.tradingview.com/kotak-mahindra-bank--big.svg",
                      ),
                      const SizedBox(height: 12),
                      SwitchFundCard(
                        fundName: "Kotak Emerging Equity Scheme",
                        fundType: "Regular Fund",
                        commission: "0.45% commission",
                        gainAmount: 102000,
                        targetFundName: "Kotak Emerging Fund Direct Growth",
                        targetFundType: "Direct Fund",
                        targetCommission: "No commission",
                        fundIconUrl: "https://s3-symbol-logo.tradingview.com/kotak-mahindra-bank--big.svg",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Continue',
                        variant: AppButtonVariant.primary,
                        size: AppButtonSize.large,
                        isLoading: _isLoading,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
