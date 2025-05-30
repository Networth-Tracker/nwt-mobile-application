import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/controllers/dashboard/dashboard_asset.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/controllers/user_controller.dart';
import 'package:nwt_app/screens/Advisory/advisory.dart';
import 'package:nwt_app/screens/assets/banks/banks.dart';
import 'package:nwt_app/screens/assets/investments/investments.dart';
import 'package:nwt_app/screens/connections/connections.dart';
import 'package:nwt_app/screens/dashboard/widgets/asset_card.dart';
import 'package:nwt_app/screens/dashboard/widgets/mutual_fund_bottom_sheet.dart';
import 'package:nwt_app/screens/dashboard/widgets/networth_chart.dart';
import 'package:nwt_app/screens/dashboard/zerodha_webview.dart';
import 'package:nwt_app/screens/explore/explore.dart';
import 'package:nwt_app/screens/mf_switch/mf_switch.dart';
import 'package:nwt_app/screens/notifications/notification_list.dart';
import 'package:nwt_app/screens/products/products.dart';
import 'package:nwt_app/services/auth/auth_flow.dart';
import 'package:nwt_app/services/dashboard/total_networth.dart';
import 'package:nwt_app/services/zerodha/zerodha.dart';
import 'package:nwt_app/utils/currency_formatter.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/widgets/avatar.dart';
import 'package:nwt_app/widgets/common/animated_amount.dart';
import 'package:nwt_app/widgets/common/shimmer_text.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

import '../assets/banks/banks.dart';
import '../assets/investments/investments.dart';
import '../mf_switch/mf_switch.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final dashboardAssetController = Get.put(DashboardAssetController());
  final _zerodhaService = ZerodhaService();
  final _totalNetworthService = TotalNetworthService();
  late AnimationController _refreshController;
  bool isNetworthLoading = true;
  bool isAssetsLoading = false;
  bool isZerodhaLoading = false;

  // Networth data
  double _networthAmount = 0.0;
  String _lastFetchedTime = "";

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    fetchDashboardAssets();
    fetchTotalNetworth();
    Future.delayed(const Duration(milliseconds: 1900), () {
      _showBottomSheet();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> fetchDashboardAssets() async {
    dashboardAssetController.getDashboardAssets(
      onLoading: (isLoading) {
        if (mounted) {
          setState(() {
            isAssetsLoading = isLoading;
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

  /// Fetches the total networth data from the API
  Future<void> fetchTotalNetworth() async {
    _totalNetworthService
        .getTotalNetworth(
          onLoading: (isLoading) {
            if (mounted) {
              setState(() {
                isNetworthLoading = isLoading;
              });
              if (isLoading) {
                _refreshController.repeat();
              } else {
                _refreshController.stop();
                _refreshController.reset();
              }
            }
          },
        )
        .then((response) {
          if (response != null && response.data != null) {
            if (mounted) {
              setState(() {
                // Format the networth amount with rupee symbol
                _networthAmount = response.data!.totalNetWorth;
                // Format the timestamp
                _lastFetchedTime = response.data!.currentdatetime;
              });
            }
          }
        });
  }

  Future<void> connectToZerodha() async {
    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    setState(() {
      isZerodhaLoading = true;
    });

    // Get Zerodha login URL directly from service
    final response = await _zerodhaService.getZerodhaLoginUrl(
      onLoading: (loading) {
        setState(() {
          isZerodhaLoading = loading;
        });
      },
    );

    // Close loading dialog
    Get.back();

    if (response == null) {
      Get.snackbar(
        'Error',
        'Failed to get Zerodha login URL. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    if (response.success && response.data?.loginurl != null) {
      // Open WebView with Zerodha login URL without any modifications
      String decodeUrl(String encodedUrl) {
        return Uri.decodeFull(encodedUrl);
      }

      Get.to(
        () => ZerodhaWebView(
          url: decodeUrl(response.data!.loginurl),
          title: 'Zerodha Login',
        ),
        transition: Transition.rightToLeft,
      );
    } else {
      Get.snackbar(
        'Error',
        'Invalid Zerodha login URL received. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good morning!";
    } else if (hour < 17) {
      return "Good afternoon!";
    } else if (hour < 21) {
      return "Good evening!";
    } else {
      return "Good evening!";
    }
  }

  bool _isAmountVisible = true;

  PageController pageViewController = PageController();
  int currentPage = 0;

  // Function to show the bottom sheet
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MutualFundBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<UserController>(
          builder: (userController) {
            return Scaffold(
              backgroundColor: AppColors.darkCardBG,
              body: SafeArea(
                bottom: false,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await fetchTotalNetworth();
                    await fetchDashboardAssets();
                  },
                  color:
                      themeController.isDarkMode
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                  backgroundColor:
                      themeController.isDarkMode
                          ? AppColors.darkCardBG
                          : AppColors.lightBackground,
                  displacement: 20.0,
                  strokeWidth: 3.0,
                  child: CustomScrollView(
                    // Use ClampingScrollPhysics for snappier scrolling
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizing.scaffoldHorizontalPadding,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const AppText(
                                                  "Logout",
                                                  variant:
                                                      AppTextVariant.headline4,
                                                  weight:
                                                      AppTextWeight.semiBold,
                                                ),
                                                content: const AppText(
                                                  "Are you sure you want to logout?",
                                                  variant:
                                                      AppTextVariant.bodyMedium,
                                                  colorType:
                                                      AppTextColorType.tertiary,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: const AppText(
                                                      "Cancel",
                                                      variant:
                                                          AppTextVariant
                                                              .bodyMedium,
                                                      colorType:
                                                          AppTextColorType
                                                              .secondary,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      // Create AuthFlow instance and logout
                                                      try {
                                                        final authFlow =
                                                            AuthFlow();
                                                        AppLogger.info(
                                                          'Logging out user',
                                                          tag: 'Dashboard',
                                                        );
                                                        authFlow.logout();
                                                      } catch (e) {
                                                        AppLogger.error(
                                                          'Error during logout',
                                                          error: e,
                                                          tag: 'Dashboard',
                                                        );
                                                      }
                                                    },
                                                    child: const AppText(
                                                      "Logout",
                                                      variant:
                                                          AppTextVariant
                                                              .bodyMedium,
                                                      colorType:
                                                          AppTextColorType
                                                              .error,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Avatar(
                                          path:
                                              userController.userData?.gender
                                                          ?.toLowerCase() ==
                                                      'female'
                                                  ? 'assets/svgs/dashboard/female.png'
                                                  : 'assets/svgs/dashboard/male.png',
                                          width: 40,
                                          height: 40,
                                          isNetworkImage: false,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppText(
                                            "Hi, ${userController.userData?.firstname != null ? userController.userData!.firstname : 'User'}",
                                            variant: AppTextVariant.headline4,
                                            weight: AppTextWeight.bold,
                                            colorType: AppTextColorType.primary,
                                          ),
                                          AppText(
                                            _getGreetingMessage(),
                                            variant: AppTextVariant.bodySmall,
                                            weight: AppTextWeight.medium,
                                            colorType:
                                                AppTextColorType.secondary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed:
                                    () => Get.to(
                                      () => NotificationListScreen(),
                                      transition: Transition.rightToLeft,
                                    ),
                                icon: const Icon(Icons.notifications_outlined),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // SliverAppBar(
                      //   floating: false,
                      //   backgroundColor: AppColors.darkCardBG,
                      //   flexibleSpace: FlexibleSpaceBar(
                      //     background:  ),
                      // ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizing.scaffoldHorizontalPadding,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    "Your Networth",
                                    variant: AppTextVariant.bodyMedium,
                                    weight: AppTextWeight.bold,
                                    colorType: AppTextColorType.secondary,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      isNetworthLoading
                                          ? ShimmerTextPlaceholder(
                                            width: 220,
                                            height: 55,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          )
                                          : AnimatedAmount(
                                            amount:
                                                CurrencyFormatter.formatRupee(
                                                  _networthAmount,
                                                ),
                                            isAmountVisible: _isAmountVisible,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isAmountVisible =
                                                    !_isAmountVisible;
                                              });
                                            },
                                            child: Icon(
                                              _isAmountVisible
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color:
                                                  AppColors
                                                      .darkButtonPrimaryBackground,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                      ),
                                    ],
                                  ),
                                  AppText(
                                    _lastFetchedTime.isNotEmpty
                                        ? _lastFetchedTime
                                        : "Last data fetched at 11:00pm",
                                    variant: AppTextVariant.tiny,
                                    weight: AppTextWeight.semiBold,
                                    colorType: AppTextColorType.secondary,
                                  ),
                                  NetworthChart(
                                    currentNetworth: _networthAmount,
                                    projectedNetworth: _networthAmount,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // SliverAppBar(
                      //   backgroundColor: AppColors.darkCardBG,
                      //   expandedHeight: 302,
                      //   toolbarHeight: 82,
                      //   pinned: false,
                      //   centerTitle: false,
                      //   floating: false,
                      //   // Faster animations
                      //   stretch: true,
                      //   stretchTriggerOffset: 50,
                      //   flexibleSpace: LayoutBuilder(
                      //     builder: (
                      //       BuildContext context,
                      //       BoxConstraints constraints,
                      //     ) {
                      //       final FlexibleSpaceBarSettings settings =
                      //           context
                      //               .dependOnInheritedWidgetOfExactType<
                      //                 FlexibleSpaceBarSettings
                      //               >()!;
                      //       final double deltaExtent =
                      //           settings.maxExtent - settings.minExtent;
                      //       final double t = (1.0 -
                      //               (settings.currentExtent -
                      //                       settings.minExtent) /
                      //                   deltaExtent)
                      //           .clamp(0.0, 1.0);

                      //       return Stack(
                      //         children: [
                      //           Opacity(
                      //             opacity: 1.0 - t,
                      //             child:
                      //           ),
                      //           // Positioned(
                      //           //   top: 8,
                      //           //   left: 0,
                      //           //   right: 0,
                      //           //   bottom: 8,
                      //           //   child: Container(
                      //           //     decoration: BoxDecoration(
                      //           //       border: Border(
                      //           //         bottom: BorderSide(
                      //           //           color: AppColors.darkButtonBorder,
                      //           //           width: 1.0,
                      //           //         ),
                      //           //       ),
                      //           //     ),
                      //           //     child: Opacity(
                      //           //       opacity: t,
                      //           //       child: Padding(
                      //           //         padding: const EdgeInsets.symmetric(
                      //           //           horizontal:
                      //           //               AppSizing
                      //           //                   .scaffoldHorizontalPadding,
                      //           //         ),
                      //           //         child: Column(
                      //           //           mainAxisSize: MainAxisSize.min,
                      //           //           crossAxisAlignment:
                      //           //               CrossAxisAlignment.start,
                      //           //           children: [
                      //           //             Row(
                      //           //               mainAxisAlignment:
                      //           //                   MainAxisAlignment
                      //           //                       .spaceBetween,
                      //           //               children: [
                      //           //                 AppText(
                      //           //                   "Your Networth",
                      //           //                   variant:
                      //           //                       AppTextVariant.bodySmall,
                      //           //                   weight: AppTextWeight.bold,
                      //           //                   colorType:
                      //           //                       AppTextColorType
                      //           //                           .secondary,
                      //           //                 ),
                      //           //                 Row(
                      //           //                   children: [
                      //           //                     GestureDetector(
                      //           //                       onTap:
                      //           //                           fetchDashboardAssets,
                      //           //                       child: RotationTransition(
                      //           //                         turns:
                      //           //                             _refreshController,
                      //           //                         child: Icon(
                      //           //                           Icons.refresh_rounded,
                      //           //                           size: 20,
                      //           //                           color:
                      //           //                               AppColors
                      //           //                                   .darkButtonPrimaryBackground,
                      //           //                         ),
                      //           //                       ),
                      //           //                     ),
                      //           //                     const SizedBox(width: 12),
                      //           //                   ],
                      //           //                 ),
                      //           //               ],
                      //           //             ),
                      //           //             const SizedBox(height: 4),
                      //           //             Row(
                      //           //               mainAxisAlignment:
                      //           //                   MainAxisAlignment
                      //           //                       .spaceBetween,
                      //           //               children: [
                      //           //                 AnimatedAmount(
                      //           //                   amount: CurrencyFormatter.formatRupeeWithCommas(_networthAmount),
                      //           //                   isAmountVisible:
                      //           //                       _isAmountVisible,
                      //           //                   style: const TextStyle(
                      //           //                     color: Colors.white,
                      //           //                     fontSize: 28,
                      //           //                     fontWeight: FontWeight.bold,
                      //           //                   ),
                      //           //                 ),
                      //           //                 Row(
                      //           //                   children: [
                      //           //                     GestureDetector(
                      //           //                       onTap: () {
                      //           //                         setState(() {
                      //           //                           _isAmountVisible =
                      //           //                               !_isAmountVisible;
                      //           //                         });
                      //           //                       },
                      //           //                       child: Icon(
                      //           //                         _isAmountVisible
                      //           //                             ? Icons
                      //           //                                 .visibility_outlined
                      //           //                             : Icons
                      //           //                                 .visibility_off_outlined,
                      //           //                         size: 20,
                      //           //                         color:
                      //           //                             AppColors
                      //           //                                 .darkButtonPrimaryBackground,
                      //           //                       ),
                      //           //                     ),
                      //           //                     const SizedBox(width: 12),
                      //           //                   ],
                      //           //                 ),
                      //           //               ],
                      //           //             ),
                      //           //           ],
                      //           //         ),
                      //           //       ),
                      //           //     ),
                      //           //   ),
                      //           // ),
                      //         ],
                      //       );
                      //     },
                      //   ),
                      // ),
                      SliverToBoxAdapter(
                        child: Container(
                          color: AppColors.darkBackground,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: AppSizing.scaffoldHorizontalPadding,
                                    right: AppSizing.scaffoldHorizontalPadding,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        "Assets",
                                        variant: AppTextVariant.headline5,
                                        weight: AppTextWeight.bold,
                                        colorType: AppTextColorType.primary,
                                      ),
                                      AppText(
                                        "See All",
                                        variant: AppTextVariant.bodySmall,
                                        weight: AppTextWeight.medium,
                                        colorType: AppTextColorType.link,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                    left: AppSizing.scaffoldHorizontalPadding,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    spacing: 12,
                                    children: [
                                      InkWell(
                                        onTap:
                                            () => Get.to(
                                              const ConnectionsScreen(),
                                              transition:
                                                  Transition.rightToLeft,
                                            ),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight:
                                                105, // Set a minimum height to match AssetCard
                                          ),
                                          child: Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: AppColors.darkCardBG,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color:
                                                    AppColors.darkButtonBorder,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add_rounded,
                                                size: 26,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GetBuilder<DashboardAssetController>(
                                        builder: (controller) {
                                          if (controller
                                                  .dashboardAssets
                                                  ?.data !=
                                              null) {
                                            return Row(
                                              spacing: 12,
                                              children:
                                                  controller
                                                      .dashboardAssets!
                                                      .data!
                                                      .assetdata
                                                      .map(
                                                        (asset) => InkWell(
                                                          onTap:
                                                              () => Get.to(
                                                                asset.name ==
                                                                        "Banks"
                                                                    ? const AssetBankScreen()
                                                                    : const AssetInvestmentScreen(),
                                                                transition:
                                                                    Transition
                                                                        .rightToLeft,
                                                              ),
                                                          child: AssetCard(
                                                            title: asset.name,
                                                            amount:
                                                                CurrencyFormatter.formatRupee(
                                                                  asset.value,
                                                                ),
                                                            delta:
                                                                "${asset.deltapercentage}%",
                                                            deltaType:
                                                                asset.deltavalue >=
                                                                        0
                                                                    ? DeltaType
                                                                        .positive
                                                                    : DeltaType
                                                                        .negative,
                                                            icon:
                                                                Icons
                                                                    .account_balance_outlined,
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // SliverToBoxAdapter(
                      //   child: Material(
                      //     color: AppColors.darkBackground,
                      //     child: Column(
                      //       children: [
                      //         SizedBox(height: 24),
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(
                      //             horizontal:
                      //                 AppSizing.scaffoldHorizontalPadding,
                      //           ),
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(20),
                      //               boxShadow: [
                      //                 BoxShadow(
                      //                   color: Colors.black.withValues(
                      //                     alpha: 0.25,
                      //                   ),
                      //                   blurRadius: 15,
                      //                   offset: const Offset(0, 6),
                      //                 ),
                      //               ],
                      //               gradient: LinearGradient(
                      //                 begin: Alignment.topLeft,
                      //                 end: Alignment.bottomRight,
                      //                 stops: const [0.1, 0.9],
                      //                 colors: [
                      //                   Color.fromRGBO(180, 120, 255, 0.95),
                      //                   Color.fromRGBO(41, 9, 81, 1),
                      //                 ],
                      //               ),
                      //             ),
                      //             child: Stack(
                      //               children: [
                      //                 // Background decorative elements
                      //                 Positioned(
                      //                   right: -30,
                      //                   top: -30,
                      //                   child: Container(
                      //                     height: 120,
                      //                     width: 120,
                      //                     decoration: BoxDecoration(
                      //                       shape: BoxShape.circle,
                      //                       color: Colors.white.withValues(
                      //                         alpha: 0.08,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Positioned(
                      //                   left: 20,
                      //                   bottom: -40,
                      //                   child: Container(
                      //                     height: 100,
                      //                     width: 100,
                      //                     decoration: BoxDecoration(
                      //                       shape: BoxShape.circle,
                      //                       color: Colors.white.withValues(
                      //                         alpha: 0.08,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Positioned(
                      //                   right: 60,
                      //                   top: 40,
                      //                   child: Container(
                      //                     height: 8,
                      //                     width: 8,
                      //                     decoration: BoxDecoration(
                      //                       shape: BoxShape.circle,
                      //                       color: Colors.white.withValues(
                      //                         alpha: 0.3,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Positioned(
                      //                   left: 80,
                      //                   bottom: 30,
                      //                   child: Container(
                      //                     height: 6,
                      //                     width: 6,
                      //                     decoration: BoxDecoration(
                      //                       shape: BoxShape.circle,
                      //                       color: Colors.white.withValues(
                      //                         alpha: 0.3,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                     horizontal: 15,
                      //                     vertical: 15,
                      //                   ),
                      //                   child: Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceBetween,
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.center,
                      //                     children: [
                      //                       Expanded(
                      //                         flex: 3,
                      //                         child: Column(
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.start,
                      //                           children: [
                      //                             Row(
                      //                               children: [
                      //                                 AppText(
                      //                                   "Connect with Zerodha",
                      //                                   variant:
                      //                                       AppTextVariant
                      //                                           .bodyLarge,
                      //                                   weight:
                      //                                       AppTextWeight.bold,
                      //                                   colorType:
                      //                                       AppTextColorType
                      //                                           .primary,
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                             const SizedBox(height: 5),
                      //                             AppText(
                      //                               "Log in to Kite to link all your investments and keep track of your portfolio in one place!",
                      //                               variant:
                      //                                   AppTextVariant
                      //                                       .bodySmall,
                      //                               weight:
                      //                                   AppTextWeight.medium,
                      //                               colorType:
                      //                                   AppTextColorType
                      //                                       .primary,
                      //                               maxLines: 3,
                      //                               lineHeight: 1.4,
                      //                             ),
                      //                             const SizedBox(height: 8),
                      //                             InkWell(
                      //                               onTap: _showBottomSheet,
                      //                               borderRadius:
                      //                                   BorderRadius.circular(
                      //                                     8,
                      //                                   ),
                      //                               child: Container(
                      //                                 padding:
                      //                                     const EdgeInsets.symmetric(
                      //                                       horizontal: 8,
                      //                                       vertical: 8,
                      //                                     ),
                      //                                 decoration: BoxDecoration(
                      //                                   color:
                      //                                       AppColors
                      //                                           .darkButtonPrimaryBackground,
                      //                                   borderRadius:
                      //                                       BorderRadius.circular(
                      //                                         8,
                      //                                       ),
                      //                                   boxShadow: [
                      //                                     BoxShadow(
                      //                                       color: Colors.black
                      //                                           .withValues(
                      //                                             alpha: 0.25,
                      //                                           ),
                      //                                       blurRadius: 8,
                      //                                       offset:
                      //                                           const Offset(
                      //                                             0,
                      //                                             4,
                      //                                           ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                                 child: Row(
                      //                                   mainAxisSize:
                      //                                       MainAxisSize.min,
                      //                                   children: [
                      //                                     InkWell(
                      //                                       onTap:
                      //                                           connectToZerodha,
                      //                                       child: AppText(
                      //                                         "Connect Now",
                      //                                         variant:
                      //                                             AppTextVariant
                      //                                                 .tiny,
                      //                                         weight:
                      //                                             AppTextWeight
                      //                                                 .semiBold,
                      //                                         colorType:
                      //                                             AppTextColorType
                      //                                                 .tertiary,
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                             ),

                      //                             // const SizedBox(height: 24),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                       // const SizedBox(width: 20),
                      //                       // Expanded(
                      //                       //   flex: 2,
                      //                       //   child: SvgPicture.asset(
                      //                       //     "assets/svgs/dashboard/zerodha_banner.svg",
                      //                       //     fit: BoxFit.contain,
                      //                       //   ),
                      //                       // ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SliverToBoxAdapter(
                        child: Material(
                          color: AppColors.darkBackground,
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: AppSizing.scaffoldHorizontalPadding,
                                  right: AppSizing.scaffoldHorizontalPadding,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      "Recommendations",
                                      variant: AppTextVariant.headline5,
                                      weight: AppTextWeight.bold,
                                      colorType: AppTextColorType.primary,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height *
                                    0.18, // Responsive height based on screen size
                                child: PageView(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  controller: pageViewController,
                                  onPageChanged: (pageNo) {
                                    setState(() {
                                      currentPage = pageNo;
                                    });
                                  },
                                  children: [
                                    ...List.generate(1, (index) {
                                      return Container(
                                        color:
                                            themeController.isDarkMode
                                                ? AppColors.darkCardBG
                                                : AppColors.lightBackground,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              AppSizing
                                                  .scaffoldHorizontalPadding,
                                          vertical:
                                              8, // Slightly reduced vertical padding
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex:
                                                  3, // Allocate more space to text content
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AppText(
                                                    "Save up to 3.2% annually",
                                                    variant:
                                                        AppTextVariant
                                                            .bodyMedium,
                                                    weight: AppTextWeight.bold,
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ), // Reduced spacing
                                                  AppText(
                                                    "Switching from regular to direct mutual fund can boost portfolio by saving ₹2.7L on commissions",
                                                    variant:
                                                        AppTextVariant.tiny,
                                                    weight:
                                                        AppTextWeight.semiBold,
                                                    colorType:
                                                        AppTextColorType
                                                            .secondary,
                                                    maxLines:
                                                        3, // Limit number of lines
                                                    overflow:
                                                        TextOverflow
                                                            .ellipsis, // Handle text overflow
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ), // Reduced spacing
                                                  InkWell(
                                                    onTap:
                                                        () => Get.to(
                                                          () =>
                                                              MutualFundSwitchScreen(),
                                                          transition:
                                                              Transition
                                                                  .rightToLeft,
                                                        ),
                                                    child: AppText(
                                                      "Switch Funds",
                                                      variant:
                                                          AppTextVariant
                                                              .bodySmall,
                                                      weight:
                                                          AppTextWeight
                                                              .semiBold,
                                                      colorType:
                                                          AppTextColorType.link,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ), // Add spacing between text and image
                                            Expanded(
                                              flex:
                                                  1, // Allocate less space to image
                                              child: SvgPicture.asset(
                                                "assets/svgs/dashboard/mf_banner.svg",
                                                fit:
                                                    BoxFit
                                                        .contain, // Ensure image fits within its container
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                height: 8,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(1, (index) {
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      width: currentPage == index ? 30 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color:
                                            currentPage == index
                                                ? themeController.isDarkMode
                                                    ? AppColors.darkPrimary
                                                    : AppColors.lightPrimary
                                                : themeController.isDarkMode
                                                ? AppColors.darkButtonBorder
                                                : AppColors.lightButtonBorder,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              SizedBox(height: 60),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      AppSizing.scaffoldHorizontalPadding,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "make your \nmoney grow.",
                                      style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white.withValues(
                                          alpha: 0.20,
                                        ),
                                        height: 1.0,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(height: 20),
                              // InkWell(
                              //   onTap: _showBottomSheet,
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              //     decoration: BoxDecoration(
                              //       color: AppColors.darkPrimary,
                              //       borderRadius: BorderRadius.circular(12),
                              //     ),
                              //     child: AppText(
                              //       "Open Dashboard Actions",
                              //       variant: AppTextVariant.bodyLarge,
                              //       weight: AppTextWeight.bold,
                              //       colorType: AppTextColorType.primary,
                              //     ),
                              //   ),
                              // ),
                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      AppSizing.scaffoldHorizontalPadding,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Made with ❤️ in India",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white.withValues(
                                          alpha: 0.20,
                                        ),
                                        height: 1.0,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });

                  // Navigate based on the selected index
                  if (index == 1) {
                    // Products tab
                    Get.to(
                      () => const MutualFundSwitchScreen(),
                      transition: Transition.rightToLeft,
                    )?.then((_) {
                      setState(() {
                        _selectedIndex = 0; // Reset to home tab when returning
                      });
                    });
                  } else if (index == 2) {
                    // Advisory tab
                    Get.to(
                      () => const AssetBankScreen(),
                      transition: Transition.rightToLeft,
                    )?.then((_) {
                      setState(() {
                        _selectedIndex = 0; // Reset to home tab when returning
                      });
                    });
                  } else if (index == 3) {
                    // Explore tab
                    Get.to(
                      () => const AssetInvestmentScreen(),
                      transition: Transition.rightToLeft,
                    )?.then((_) {
                      setState(() {
                        _selectedIndex = 0; // Reset to home tab when returning
                      });
                    });
                  }
                },
                selectedItemColor: AppColors.darkPrimary,
                unselectedItemColor: AppColors.darkTextGray,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category_rounded),
                    label: "Switch",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.smart_toy_rounded),
                    label: "Banks",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_rounded),
                    label: "Investments",
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
