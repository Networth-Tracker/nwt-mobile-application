import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/assets/investments/widgets/holding_card.dart';
import 'package:nwt_app/widgets/common/app_input_field.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/graph_legend.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class AssetInvestmentScreen extends StatefulWidget {
  const AssetInvestmentScreen({super.key});

  @override
  State<AssetInvestmentScreen> createState() => _AssetInvestmentScreenState();
}

class _AssetInvestmentScreenState extends State<AssetInvestmentScreen> {
  final TextEditingController _searchController = TextEditingController();
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
              "Investments",
              variant: AppTextVariant.headline6,
              weight: AppTextWeight.semiBold,
            ),
            const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizing.scaffoldHorizontalPadding,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darkButtonBorder),
                  color: AppColors.darkCardBG,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "Total balance",
                              variant: AppTextVariant.headline4,
                              weight: AppTextWeight.bold,
                              colorType: AppTextColorType.primary,
                            ),
                            SizedBox(height: 3),
                            AppText(
                              "Last data fetched at 12:12pm",
                              variant: AppTextVariant.bodySmall,
                              weight: AppTextWeight.medium,
                              colorType: AppTextColorType.secondary,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.darkButtonBorder,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.refresh,
                            size: 22,
                            color: AppColors.darkTextMuted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          "₹62,00,320",
                          variant: AppTextVariant.display,
                          weight: AppTextWeight.bold,
                          colorType: AppTextColorType.primary,
                        ),
                        Icon(Icons.visibility_outlined),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        "+ 0.28 (0.20%)",
                        variant: AppTextVariant.bodySmall,
                        weight: AppTextWeight.medium,
                        colorType: AppTextColorType.success,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      spacing: 8,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [Color(0xFFC172FF), Color(0xFF993A3A)],
                            ),
                          ),
                          height: 8,
                          width: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF6393), Color(0xFFBD1448)],
                            ),
                          ),
                          height: 8,
                          width: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFCA63), Color(0xFFFF8F6E)],
                            ),
                          ),
                          height: 8,
                          width: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [Color(0xFFC1FFC8), Color(0xFF47DDC2)],
                            ),
                          ),
                          height: 8,
                          width: 60,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8, // Horizontal spacing between items
                      runSpacing: 8, // Vertical spacing between rows
                      alignment: WrapAlignment.start,
                      children: [
                        CategoryLegend(
                          category: "Stocks",
                          color: Color(0xFFC172FF),
                        ),
                        CategoryLegend(
                          category: "Mutual Funds",
                          color: Color(0xFFFF6393),
                        ),
                        CategoryLegend(
                          category: "Commodity",
                          color: Color(0xFFFFCA63),
                        ),
                        CategoryLegend(
                          category: "F&O",
                          color: Color(0xFFC1FFC8),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.darkCardBG,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Column(
                        spacing: 6,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                "Invested",
                                variant: AppTextVariant.bodyMedium,
                                weight: AppTextWeight.medium,
                                colorType: AppTextColorType.primary,
                              ),
                              SizedBox(height: 3),
                              AppText(
                                "₹62,00,320",
                                variant: AppTextVariant.bodyMedium,
                                weight: AppTextWeight.medium,
                                colorType: AppTextColorType.primary,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                "Gain",
                                variant: AppTextVariant.bodyMedium,
                                weight: AppTextWeight.medium,
                                colorType: AppTextColorType.primary,
                              ),
                              SizedBox(height: 3),
                              AppText(
                                "₹162,00,320",
                                variant: AppTextVariant.bodyMedium,
                                weight: AppTextWeight.medium,
                                colorType: AppTextColorType.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          "Speak to advisor for Investment advise",
                          variant: AppTextVariant.bodySmall,
                          colorType: AppTextColorType.link,
                          decoration: TextDecoration.underline,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizing.scaffoldHorizontalPadding,
              ),
              child: AppInputField(
                controller: _searchController,
                prefix: Icon(
                  CupertinoIcons.search,
                  color: AppColors.darkTextMuted,
                ),
                hintText: "Search...",
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.start,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizing.scaffoldHorizontalPadding,
              ),
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.darkPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      "All",
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.secondary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      "Stocks",
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.secondary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      "Mutual Funds",
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.secondary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      "Commodity",
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.secondary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      "F&O",
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.secondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizing.scaffoldHorizontalPadding,
                ),
                child: Column(
                  spacing: 16,
                  children: [
                    HoldingCard(
                      fundName: "Franklin India Opportunities Fund",
                      navValue: "68.25",
                      investedAmount: "1,20,000",
                      currentAmount: "1,20,000",
                      gainAmount: "1,20,000",
                    ),
                    HoldingCard(
                      fundName: "HDFC Top 100 Fund",
                      navValue: "92.50",
                      investedAmount: "75,000",
                      currentAmount: "82,500",
                      gainAmount: "7,500",
                      icon: Icons.bar_chart_rounded,
                    ),
                    HoldingCard(
                      fundName: "HDFC Top 50 Fund",
                      navValue: "92.50",
                      investedAmount: "75,000",
                      currentAmount: "82,500",
                      gainAmount: "7,500",
                      icon: Icons.bar_chart_rounded,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizing.scaffoldHorizontalPadding,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(text: "Add Investments", onPressed: () {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
