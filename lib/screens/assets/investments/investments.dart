import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/assets/investments/widgets/holding_card.dart';
import 'package:nwt_app/widgets/common/app_input_field.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/graph_legend.dart';
import 'dart:math' as math;
import 'package:nwt_app/widgets/common/text_widget.dart';

class AssetInvestmentScreen extends StatefulWidget {
  const AssetInvestmentScreen({super.key});

  @override
  State<AssetInvestmentScreen> createState() => _AssetInvestmentScreenState();
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _AssetInvestmentScreenState extends State<AssetInvestmentScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showFullHeader = true;
  Widget _buildAppbar() {
    return SliverAppBar(
      surfaceTintColor: AppColors.darkBackground,
      backgroundColor: AppColors.darkBackground,
      automaticallyImplyLeading: false,
      pinned: true,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.lightPrimary,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: AppColors.lightPrimary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    AppText(
                      "Investments",
                      variant: AppTextVariant.bodyLarge,
                      weight: AppTextWeight.bold,
                      colorType: AppTextColorType.primary,
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      surfaceTintColor: AppColors.darkBackground,
      backgroundColor: AppColors.darkBackground,
      automaticallyImplyLeading: false,
      pinned: false,
      floating: false,
      expandedHeight: _showFullHeader ? 360 : 90,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.darkBackground,
          child: Column(
            children: [
              // Mini Header (always visible)
              if (_showFullHeader) ...[
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
                                  colors: [
                                    Color(0xFFC172FF),
                                    Color(0xFF993A3A),
                                  ],
                                ),
                              ),
                              height: 8,
                              width: 60,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFF6393),
                                    Color(0xFFBD1448),
                                  ],
                                ),
                              ),
                              height: 8,
                              width: 60,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFCA63),
                                    Color(0xFFFF8F6E),
                                  ],
                                ),
                              ),
                              height: 8,
                              width: 60,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFC1FFC8),
                                    Color(0xFF47DDC2),
                                  ],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
              ] else ...[
                // Mini header content when collapsed
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            "Total balance",
                            variant: AppTextVariant.bodySmall,
                            colorType: AppTextColorType.secondary,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            "₹62,00,320",
                            variant: AppTextVariant.headline6,
                            weight: AppTextWeight.bold,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.darkButtonBorder,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.refresh,
                          size: 18,
                          color: AppColors.darkTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: CustomScrollView(

          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppbar(),
            _buildHeader(),

            // Combined Search and Categories in a sticky header
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                minHeight: 130,
                maxHeight: 130,
                child: Container(
                  color: AppColors.darkBackground,
                  child: Column(
                    children: [
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizing.scaffoldHorizontalPadding,
                          vertical: 8,
                        ),
                        child: AppInputField(
                          controller: _searchController,
                          prefix: const Icon(
                            CupertinoIcons.search,
                            color: AppColors.darkTextMuted,
                          ),
                          hintText: "Search...",
                        ),
                      ),
                      
                      // Categories
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizing.scaffoldHorizontalPadding,
                          ),
                          children: [
                            _buildCategoryChip("All", true),
                            _buildCategoryChip("Stocks"),
                            _buildCategoryChip("Mutual Funds"),
                            _buildCategoryChip("Commodity"),
                            _buildCategoryChip("F&O"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Holdings list
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizing.scaffoldHorizontalPadding,
                vertical: 8,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: HoldingCard(
                        fundName: "Holding ${index + 1}",
                        navValue: "100.00",
                        investedAmount: "10,000",
                        currentAmount: "12,000",
                        gainAmount: "2,000",
                      ),
                    );
                  },
                  childCount: 10, // Replace with your actual item count
                ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AppButton(text: "Add Investments", onPressed: () {}),
      ),
    );
  }

  Widget _buildCategoryChip(String label, [bool isSelected = false]) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.darkPrimary : AppColors.darkButtonBorder,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        label,
        variant: AppTextVariant.bodySmall,
        weight: isSelected ? AppTextWeight.semiBold : AppTextWeight.regular,
      ),
    );
  }
}
