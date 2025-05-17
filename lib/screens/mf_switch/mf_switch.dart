import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class MutualFundSwitchScreen extends StatefulWidget {
  const MutualFundSwitchScreen({super.key});

  @override
  State<MutualFundSwitchScreen> createState() => _MutualFundSwitchScreenState();
}

class _MutualFundSwitchScreenState extends State<MutualFundSwitchScreen> {
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizing.scaffoldHorizontalPadding,
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
                SizedBox(height: 12),
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
                    spacing: 8,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            "Total Savings",
                            variant: AppTextVariant.headline6,
                            weight: AppTextWeight.medium,
                            colorType: AppTextColorType.primary,
                          ),
                          AppText(
                            "₹1,00,000",
                            variant: AppTextVariant.headline6,
                            weight: AppTextWeight.medium,
                            colorType: AppTextColorType.primary,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            "Avg Invested Period",
                            variant: AppTextVariant.headline6,
                            weight: AppTextWeight.medium,
                            colorType: AppTextColorType.primary,
                          ),
                          AppText(
                            "3 Years",
                            variant: AppTextVariant.headline6,
                            weight: AppTextWeight.medium,
                            colorType: AppTextColorType.primary,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            "Current Value",
                            variant: AppTextVariant.headline6,
                            weight: AppTextWeight.medium,
                            colorType: AppTextColorType.primary,
                          ),
                          AppText(
                            "₹10,05,000",
                            variant: AppTextVariant.headline6,
                            weight: AppTextWeight.medium,
                            colorType: AppTextColorType.primary,
                          ),
                        ],
                      ),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            "Additional Earnings",
                            variant: AppTextVariant.headline6,
                            weight: AppTextWeight.medium,
                            colorType: AppTextColorType.success,
                          ),
                          AppText(
                            "₹2,05,000",
                            variant: AppTextVariant.headline6,
                            weight: AppTextWeight.medium,
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
        ),
      ),
    );
  }
}
