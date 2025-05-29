import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/controllers/assets/investments.dart';
import 'package:nwt_app/screens/assets/investments/types/holdings.dart';
import 'package:nwt_app/screens/assets/investments/types/portfolio.dart';
import 'package:nwt_app/screens/assets/investments/widgets/holding_card.dart';
import 'package:nwt_app/screens/mf_switch/mf_switch.dart';
import 'package:nwt_app/utils/currency_formatter.dart';
import 'package:nwt_app/widgets/common/animated_amount.dart';
import 'package:nwt_app/widgets/common/app_input_field.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/dot_indicator.dart';
import 'package:nwt_app/widgets/common/graph_legend.dart';
import 'package:nwt_app/widgets/common/shimmer_text.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:shimmer/shimmer.dart';

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
  // Removed animation controllers for progress bars
  bool showFullHeader = true;
  final InvestmentController investmentController = Get.put(
    InvestmentController(),
  );
  bool isPortfolioLoading = true;
  bool isHoldingLoading = true;
  late AnimationController _refreshController;
  String _selectedCategory = 'All';

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
      expandedHeight: showFullHeader ? 380 : 90,
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
                            // InkWell(
                            //   onTap: () {
                            //     onRefresh();
                            //   },
                            //   child: Container(
                            //     padding: const EdgeInsets.all(4),
                            //     decoration: BoxDecoration(
                            //       color: AppColors.darkButtonBorder,
                            //       borderRadius: BorderRadius.circular(15),
                            //     ),
                            //     child: RotationTransition(
                            //       turns: Tween(
                            //         begin: 0.0,
                            //         end: 1.0,
                            //       ).animate(_refreshController),
                            //       child: Icon(
                            //         Icons.refresh,
                            //         size: 22,
                            //         color: AppColors.darkTextMuted,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isPortfolioLoading
                                ? ShimmerTextPlaceholder(
                                  width: 220,
                                  height: 50,
                                  borderRadius: BorderRadius.circular(8),
                                )
                                : AnimatedAmount(
                                  isAmountVisible: _isAmountVisible,
                                  amount: CurrencyFormatter.formatRupee(
                                    portfolio?.value ?? 0,
                                  ),
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
                                transitionBuilder: (
                                  Widget child,
                                  Animation<double> animation,
                                ) {
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
                          child:
                              isPortfolioLoading
                                  ? Shimmer.fromColors(
                                    baseColor: AppColors.darkCardBG,
                                    highlightColor: AppColors.darkButtonBorder,
                                    child: Container(
                                      width: 100,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: AppColors.darkCardBG,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  )
                                  : AppText(
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
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Minimum flex value to ensure visibility of small percentages
                              final int minFlex = 1;

                              // Get individual coverage values
                              final int stocksFlex =
                                  (portfolio?.coverage.stocks ?? 0) > 0
                                      ? math.max(
                                        (portfolio?.coverage.stocks ?? 0)
                                            .round(),
                                        minFlex,
                                      )
                                      : 0;
                              final int mfFlex =
                                  (portfolio?.coverage.mutualfunds ?? 0) > 0
                                      ? math.max(
                                        (portfolio?.coverage.mutualfunds ?? 0)
                                            .round(),
                                        minFlex,
                                      )
                                      : 0;
                              final int commoditiesFlex =
                                  (portfolio?.coverage.commodities ?? 0) > 0
                                      ? math.max(
                                        (portfolio?.coverage.commodities ?? 0)
                                            .round(),
                                        minFlex,
                                      )
                                      : 0;
                              final int foFlex =
                                  (portfolio?.coverage.fo ?? 0) > 0
                                      ? math.max(
                                        (portfolio?.coverage.fo ?? 0).round(),
                                        minFlex,
                                      )
                                      : 0;

                              // Determine which segments are visible for border radius
                              final bool hasStocks = stocksFlex > 0;
                              final bool hasMF = mfFlex > 0;
                              final bool hasCommodities = commoditiesFlex > 0;
                              final bool hasFO = foFlex > 0;

                              return Row(
                                spacing: 8,
                                children: [
                                  // Stocks bar
                                  if (hasStocks)
                                    Expanded(
                                      flex: stocksFlex,
                                      child: Container(
                                        // Add small spacing between segments
                                        padding: EdgeInsets.only(
                                          right:
                                              hasMF || hasCommodities || hasFO
                                                  ? 1
                                                  : 0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFC172FF),
                                              Color(0xFF993A3A),
                                            ],
                                          ),
                                        ),
                                        height: 8,
                                      ),
                                    ),

                                  // Mutual Funds bar
                                  if (hasMF)
                                    Expanded(
                                      flex: mfFlex,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: hasStocks ? 1 : 0,
                                          right:
                                              hasCommodities || hasFO ? 1 : 0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFF6393),
                                              Color(0xFFBD1448),
                                            ],
                                          ),
                                        ),
                                        height: 8,
                                      ),
                                    ),

                                  // Commodities bar
                                  if (hasCommodities)
                                    Expanded(
                                      flex: commoditiesFlex,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: hasStocks || hasMF ? 1 : 0,
                                          right: hasFO ? 1 : 0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFFCA63),
                                              Color(0xFFFF8F6E),
                                            ],
                                          ),
                                        ),
                                        height: 8,
                                      ),
                                    ),

                                  // F&O bar
                                  if (hasFO)
                                    Expanded(
                                      flex: foFlex,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left:
                                              hasStocks ||
                                                      hasMF ||
                                                      hasCommodities
                                                  ? 1
                                                  : 0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          gradient: const LinearGradient(
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
                              );
                            },
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
                                    amount: CurrencyFormatter.formatRupee(
                                      portfolio?.invested ?? 0,
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
                              variant: AppTextVariant.bodyMedium,
                              colorType: AppTextColorType.link,
                              weight: AppTextWeight.medium,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.linkColor,
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
    // Removed progress bar animation initialization

    // Start the initial animation
    _animationController.forward();
    fetchPortfolio();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> fetchPortfolio() async {
    setState(() {
      isPortfolioLoading = true;
      isHoldingLoading = true;
    });

    try {
      _refreshController.reset();
      _refreshController.repeat();

      await investmentController.getPortfolio(
        onLoading: (isLoading) {
          setState(() {
            isPortfolioLoading = isLoading;
          });
        },
      );

      await investmentController.getHoldings(
        onLoading: (isLoading) {
          setState(() {
            isHoldingLoading = isLoading;
          });
        },
      );

      // No animation to start

      _refreshController.stop();
    } catch (e) {
      setState(() {
        isPortfolioLoading = false;
        isHoldingLoading = false;
      });

      _refreshController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: GetBuilder<InvestmentController>(
        builder: (investmentController) {
          // Show loading state when portfolio is null and we're loading
          // Use shimmer placeholders throughout the UI instead of a separate loading screen

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
                                return _buildCategoryChip(categories[index]);
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
                        // Show shimmer placeholders when loading
                        if (isPortfolioLoading &&
                            investmentController.portfolio == null) {
                          if (index < 5) {
                            return _buildShimmerInvestmentCard();
                          } else {
                            return null;
                          }
                        }

                        final investments = _filteredInvestments();

                        if (investments.isEmpty) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: _buildNoHoldingsMessage(),
                          );
                        }

                        final investment = investments[index];

                        if (index == 0 && _selectedCategory == 'Mutual Funds') {
                          return Column(
                            children: [
                              InkWell(
                                onTap:
                                    () => Get.to(
                                      () => MutualFundSwitchScreen(),
                                      transition: Transition.rightToLeft,
                                    ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.darkButtonBorder,
                                    ),
                                    color: AppColors.darkCardBG,
                                  ),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svgs/assets/investments/save.svg",
                                        width: 50,
                                        height: 50,
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            AppText(
                                              'Switch to save up to 1.4%',
                                              variant: AppTextVariant.bodyLarge,
                                              weight: AppTextWeight.semiBold,
                                              colorType:
                                                  AppTextColorType.success,
                                            ),
                                            const SizedBox(height: 8),
                                            AppText(
                                              "Say goodbye to high commissions. Easily switch plans in less than 5 minute for free.",
                                              variant: AppTextVariant.bodySmall,
                                              colorType:
                                                  AppTextColorType.primary,
                                            ),
                                            GestureDetector(
                                              onTap:
                                                  _showSwitchToDirectBottomSheet,
                                              child: AppText(
                                                'Know More',
                                                variant:
                                                    AppTextVariant.bodySmall,
                                                weight: AppTextWeight.bold,
                                                colorType:
                                                    AppTextColorType.link,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              HoldingCard(
                                fundName: investment.name,
                                navValue:
                                    investment.nav?.toStringAsFixed(2) ?? "N/A",
                                investedAmount:
                                    investment.closingbalance?.toStringAsFixed(
                                      2,
                                    ) ??
                                    "0.00",
                                currentAmount: investment.currentmktvalue
                                    ?.toStringAsFixed(2) ??
                                    "0.00",
                                gainAmount: investment.gainloss?.toStringAsFixed(
                                  2,
                                ) ?? "0.00",
                              ),
                            ],
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: HoldingCard(
                            fundName: investment.name,
                            navValue:
                                investment.nav?.toStringAsFixed(2) ?? "N/A",
                            investedAmount:
                                investment.closingbalance?.toStringAsFixed(2) ??
                                "0.00",
                            currentAmount: investment.currentmktvalue
                                ?.toStringAsFixed(2) ?? "0.00",
                            gainAmount: investment.gainloss?.toStringAsFixed(2) ?? "0.00",
                          ),
                        );
                      },
                      childCount:
                          _filteredInvestments().isEmpty
                              ? 1
                              : _filteredInvestments().length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizing.scaffoldHorizontalPadding,
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: SizedBox(
          width: double.infinity,
          child: AppButton(text: "Add Investments", onPressed: () {}),
        ),
      ),
    );
  }

  List<Investment> _filteredInvestments() {
    if (investmentController.holdings?.investments == null) return [];

    final investments = investmentController.holdings!.investments;

    if (_selectedCategory == 'All') return investments;

    return investments.where((investment) {
      switch (_selectedCategory) {
        case 'Stocks':
          return investment.type == AssetType.STOCKS;
        case 'Mutual Funds':
          return investment.type == AssetType.MF;
        case 'Commodity':
          return investment.assettype?.toLowerCase().contains('commodity') ??
              false;
        case 'F&O':
          return investment.assettype?.toLowerCase().contains('f&o') ?? false;
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildStepItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '$number.',
          variant: AppTextVariant.bodyMedium,
          weight: AppTextWeight.semiBold,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppText(
            text,
            variant: AppTextVariant.bodyMedium,
            colorType: AppTextColorType.secondary,
          ),
        ),
      ],
    );
  }

  void _showSwitchToDirectBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkInputBackground,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(color: AppColors.darkInputBackground),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizing.scaffoldHorizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Mutual Fund Switch',
                    variant: AppTextVariant.headline4,
                    weight: AppTextWeight.bold,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/app/switch.png", height: 200),
                    ],
                  ),
                  AppText(
                    "What is mutual fund switch ?",
                    variant: AppTextVariant.bodyLarge,
                    weight: AppTextWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  AppText(
                    "Switching from regular to direct mutual funds means moving your investments from regular plans with distributor commissions to those without commission(direct fund plans)",
                    variant: AppTextVariant.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    "Why you should switch to Direct plans?",
                    variant: AppTextVariant.bodyLarge,
                    weight: AppTextWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkInputBackground,
                      border: Border.all(color: AppColors.darkInputBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "Lower expense ratio",
                              variant: AppTextVariant.bodyMedium,
                              weight: AppTextWeight.semiBold,
                            ),
                            AppText(
                              "Direct plans expense ratios are usually 0.5% to 1.5% lower than regular plans.",
                              variant: AppTextVariant.bodySmall,
                              colorType: AppTextColorType.secondary,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "Higher Returns",
                              variant: AppTextVariant.bodyMedium,
                              weight: AppTextWeight.semiBold,
                            ),
                            AppText(
                              "Direct plans offer better returns over time due to lower costs over long investment periods.",
                              variant: AppTextVariant.bodySmall,
                              colorType: AppTextColorType.secondary,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "Same fund & manager",
                              variant: AppTextVariant.bodyMedium,
                              weight: AppTextWeight.semiBold,
                            ),
                            AppText(
                              "Direct plans offer the same fund, manager & strategy; only the cost structure varies.",
                              variant: AppTextVariant.bodySmall,
                              colorType: AppTextColorType.secondary,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "Full Transparency",
                              variant: AppTextVariant.bodyMedium,
                              weight: AppTextWeight.semiBold,
                            ),
                            AppText(
                              "No hidden commissions or fees in direct plans.",
                              variant: AppTextVariant.bodySmall,
                              colorType: AppTextColorType.secondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),
                  AppText(
                    "How mutual fund switch works?",
                    variant: AppTextVariant.bodyLarge,
                    weight: AppTextWeight.bold,
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkInputBackground,
                      border: Border.all(color: AppColors.darkInputBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "Switch plans in just 3 steps!",
                          variant: AppTextVariant.bodyMedium,
                          weight: AppTextWeight.bold,
                        ),
                        SizedBox(height: 8),
                        _buildStepItem(
                          '1',
                          'Review the direct plan summary showing all calculations and benefits',
                        ),
                        const SizedBox(height: 4),
                        DotIndicator(
                          dotCount: 4,
                          direction: DotDirection.vertical,
                          dotColor: AppColors.darkPrimary,
                          dotRadius: 2,
                          dotSize: 2,
                        ),
                        const SizedBox(height: 8),
                        _buildStepItem(
                          '2',
                          'List of your regular mutual fund plans eligible for switching to direct plans will be provided',
                        ),
                        const SizedBox(height: 4),
                        DotIndicator(
                          dotCount: 4,
                          direction: DotDirection.vertical,
                          dotColor: AppColors.darkPrimary,
                          dotRadius: 2,
                          dotSize: 2,
                        ),
                        const SizedBox(height: 8),
                        _buildStepItem(
                          '3',
                          'Click \'Continue\' to proceed with the switch',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
    );
  }

  // Build shimmer placeholders for investment cards
  Widget _buildShimmerInvestmentCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.darkCardBG,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo placeholder
          ShimmerTextPlaceholder(
            width: 50,
            height: 50,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 16),

          // Content placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                ShimmerTextPlaceholder(
                  width: 180,
                  height: 22,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Amount placeholder
                    ShimmerTextPlaceholder(
                      width: 100,
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),

                    // Percentage placeholder
                    ShimmerTextPlaceholder(
                      width: 60,
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoHoldingsMessage() {
    if (isHoldingLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          // Display multiple shimmer placeholders to indicate loading
          for (int i = 0; i < 5; i++) _buildShimmerInvestmentCard(),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: AppColors.darkTextMuted,
          ),
          const SizedBox(height: 16),
          AppText(
            'No holdings found',
            variant: AppTextVariant.headline6,
            weight: AppTextWeight.bold,
            colorType: AppTextColorType.primary,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: AppText(
              _selectedCategory == 'All'
                  ? 'You don\'t have any investments yet.'
                  : 'No ${_selectedCategory.toLowerCase()} holdings found.',
              variant: AppTextVariant.bodyMedium,
              colorType: AppTextColorType.secondary,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return ChoiceChip(
      selected: isSelected,
      showCheckmark: false,
      surfaceTintColor: AppColors.darkButtonBorder,
      backgroundColor: AppColors.darkButtonBorder,
      selectedColor: AppColors.darkPrimary,
      disabledColor: AppColors.darkButtonBorder,
      side: BorderSide(color: AppColors.darkButtonBorder, width: 1.0),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedCategory = label;
          });
        }
      },
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
