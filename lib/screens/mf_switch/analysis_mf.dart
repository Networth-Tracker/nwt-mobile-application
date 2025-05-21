import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'widgets/mutual_fund_analysis_card.dart';

class AnalysisMutualFund extends StatefulWidget {
  const AnalysisMutualFund({super.key});

  @override
  State<AnalysisMutualFund> createState() => _AnalysisMutualFundState();
}

class _AnalysisMutualFundState extends State<AnalysisMutualFund> {
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
              "Analysis",
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
              spacing: 16,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.darkInputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkButtonBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Mutual fund analysis",
                        variant: AppTextVariant.headline5,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.primary,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        "We saw that you have two regular mutual fund plans. Just so you know, regular plans come with distributor commissions, while direct fund plans don’t have any commissions.",
                        variant: AppTextVariant.headline6,
                        weight: AppTextWeight.regular,
                        colorType: AppTextColorType.primary,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.darkInputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.linkColor),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/svgs/mf_switch/mf_advice.svg"),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Mutual fund",
                                    style: TextStyle(
                                      color: AppColors.linkColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  TextSpan(
                                    text: " advice!",
                                    style: TextStyle(
                                      color: AppColors.darkPrimary,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "How about switching to direct mutual fund plans to ",
                                    style: TextStyle(
                                      color: AppColors.darkPrimary,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Save up to 1.45%",
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  TextSpan(
                                    text: ". It could be a smart move!",
                                    style: TextStyle(
                                      color: AppColors.darkPrimary,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.darkInputBorder,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkButtonBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: AppText(
                    "Mutual Fund Holdings",
                    variant: AppTextVariant.headline5,
                    weight: AppTextWeight.bold,
                    colorType: AppTextColorType.primary,
                  ),
                ),
                MutualFundAnalysisCard(
                  logoUrl: "https://s3-symbol-logo.tradingview.com/kotak-mahindra-bank--big.svg",
                  schemeName: "Kotak Emerging Equity Scheme",
                  fundType: "Regular Fund",
                  investedAmount: "₹45,000",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
