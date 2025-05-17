import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/widgets/common/animated_amount.dart';
import 'dart:async';
import 'package:nwt_app/controllers/assets/investments.dart';
import 'package:nwt_app/screens/assets/investments/types/portfolio.dart';
import 'package:nwt_app/screens/assets/investments/widgets/holding_card.dart';
import 'package:nwt_app/utils/currency_formatter.dart';
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
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

const categories = ["All", "Stocks", "Mutual Funds", "Commodity", "F&O"];

class _AssetInvestmentScreenState extends State<AssetInvestmentScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isAmountVisible = true;
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  bool showFullHeader = true;
  final InvestmentController investmentController = Get.put(
    InvestmentController(),
  );
  bool isPortfolioLoading = true;
  late AnimationController _refreshController;

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

  Widget _buildHeader(InvestmentPortfolio? portfolio, Function onRefresh) {
    return SliverAppBar(
      surfaceTintColor: AppColors.darkBackground,
      backgroundColor: AppColors.darkBackground,
      automaticallyImplyLeading: false,
      pinned: false,
      floating: false,
      expandedHeight: showFullHeader ? 360 : 90,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.darkBackground,
          child: Column(
            children: [
              // Mini Header (always visible)
              if (showFullHeader) ...[
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
                                  "Last data fetched at ${portfolio?.lastdatafetchtime}",
                                  variant: AppTextVariant.bodySmall,
                                  weight: AppTextWeight.medium,
                                  colorType: AppTextColorType.secondary,
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                onRefresh();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.darkButtonBorder,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: RotationTransition(
                                  turns: Tween(
                                    begin: 0.0,
                                    end: 1.0,
                                  ).animate(_refreshController),
                                  child: Icon(
                                    Icons.refresh,
                                    size: 22,
                                    color: AppColors.darkTextMuted,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedAmount(
                              isAmountVisible: _isAmountVisible,
                              amount: CurrencyFormatter.formatRupee(portfolio?.value ?? 0),
                              hiddenText: '₹••••••',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isAmountVisible = !_isAmountVisible;
                                });
                                // Reset and restart the animation
                                _animationController.reset();
                                _animationController.forward();
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  _isAmountVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  key: ValueKey<bool>(_isAmountVisible),
                                  color: AppColors.darkTextMuted,
                                ),
                              ),
                            ),
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
                            _isAmountVisible
                                ? "+ ${CurrencyFormatter.formatRupee(portfolio?.deltavalue ?? 0)} (${portfolio?.deltapercentage}%)"
                                : '•••••',
                            variant: AppTextVariant.bodySmall,
                            weight: AppTextWeight.medium,
                            colorType: AppTextColorType.success,
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 8,
                          child: Row(
                            spacing: 5,
                            children: [
                              if ((portfolio?.coverage.stocks ?? 0) > 0)
                                Expanded(
                                  flex:
                                      (portfolio?.coverage.stocks ?? 0).round(),
                                  child: Container(
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
                                  ),
                                ),
                              if ((portfolio?.coverage.mutualfunds ?? 0) > 0)
                                Expanded(
                                  flex:
                                      (portfolio?.coverage.mutualfunds ?? 0)
                                          .round(),
                                  child: Container(
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
                                  ),
                                ),
                              if ((portfolio?.coverage.commodities ?? 0) > 0)
                                Expanded(
                                  flex:
                                      (portfolio?.coverage.commodities ?? 0)
                                          .round(),
                                  child: Container(
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
                                  ),
                                ),
                              if ((portfolio?.coverage.fo ?? 0) > 0)
                                Expanded(
                                  flex: (portfolio?.coverage.fo ?? 0).round(),
                                  child: Container(
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
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
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
                                  AnimatedAmount(
                                    amount:  CurrencyFormatter.formatRupee(portfolio?.invested ?? 0),
                                    isAmountVisible: _isAmountVisible,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.darkPrimary,
                                    ),
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
                                  AnimatedAmount(
                                    amount: CurrencyFormatter.formatRupee(
                                          portfolio?.gain ?? 0,
                                        ),
                                    isAmountVisible: _isAmountVisible,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.darkPrimary,
                                    ),
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
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // Start the initial animation
    _animationController.forward();
    fetchPortfolio();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchPortfolio() async {
    investmentController.getPortfolio(
      onLoading: (isLoading) {
        if (mounted) {
          setState(() {
            isPortfolioLoading = isLoading;
          });
          if (isLoading) {
            _refreshController.repeat();
          } else {
            _refreshController.stop();
            _refreshController.reset();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: GetBuilder<InvestmentController>(
        builder: (investmentController) {
          return SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppbar(),
                _buildHeader(investmentController.portfolio, () {
                  fetchPortfolio();
                }),

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
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizing.scaffoldHorizontalPadding,
                              ),
                              itemBuilder: (context, index) {
                                return _buildCategoryChip(
                                  categories[index],
                                  index == 0,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 8);
                              },
                              itemCount: categories.length,
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
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          right: AppSizing.scaffoldHorizontalPadding,
          left: AppSizing.scaffoldHorizontalPadding,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: SizedBox(
          width: double.infinity,
          child: AppButton(text: "Add Investments", onPressed: () {}),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, [bool isSelected = false]) {
    return ChoiceChip(
      selected: isSelected,
      showCheckmark: false,
      surfaceTintColor: AppColors.darkButtonBorder,
      backgroundColor: AppColors.darkButtonBorder,
      selectedColor: AppColors.darkPrimary,
      disabledColor: AppColors.darkButtonBorder,
      side: BorderSide(color: AppColors.darkButtonBorder, width: 1.0),
      onSelected: (selected) {},
      label: AppText(
        label,
        variant: AppTextVariant.bodySmall,
        weight: AppTextWeight.semiBold,
        colorType:
            isSelected ? AppTextColorType.secondary : AppTextColorType.primary,
      ),
    );
  }
}
