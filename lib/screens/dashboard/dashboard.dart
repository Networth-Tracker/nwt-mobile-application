import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/controllers/user_controller.dart';
import 'package:nwt_app/controllers/dashboard/dashboard_asset.dart';
import 'package:nwt_app/screens/assets/banks/banks.dart';
import 'package:nwt_app/screens/assets/investments/investments.dart';
import 'package:nwt_app/screens/connections/connections.dart';
import 'package:nwt_app/screens/notifications/notification_list.dart';
import 'package:nwt_app/services/auth/auth_flow.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/widgets/common/animated_amount.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:nwt_app/widgets/avatar.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/screens/dashboard/widgets/asset_card.dart';
import 'package:nwt_app/screens/dashboard/widgets/networth_chart.dart';
import 'package:nwt_app/utils/currency_formatter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  final dashboardAssetController = Get.put(DashboardAssetController());
  late AnimationController _refreshController;
  bool isAssetsLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    fetchDashboardAssets();
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

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good morning!";
    } else if (hour < 17) {
      return "Good afternoon!";
    } else if (hour < 21) {
      return "Good evening!";
    } else {
      return "Good night!";
    }
  }
  bool _isAmountVisible = true;

  PageController pageViewController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<UserController>(
          builder: (userController) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                actionsPadding: EdgeInsets.zero,
                automaticallyImplyLeading: false,
                title: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizing.scaffoldHorizontalPadding - 15,
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
                                  // Show confirmation dialog before logout
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const AppText(
                                          "Logout",
                                          variant: AppTextVariant.headline4,
                                          weight: AppTextWeight.semiBold,
                                        ),
                                        content: const AppText(
                                          "Are you sure you want to logout?",
                                          variant: AppTextVariant.bodyMedium,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const AppText(
                                              "Cancel",
                                              variant:
                                                  AppTextVariant.bodyMedium,
                                              colorType:
                                                  AppTextColorType.secondary,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              // Create AuthFlow instance and logout
                                              try {
                                                final authFlow = AuthFlow();
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
                                                  AppTextVariant.bodyMedium,
                                              colorType: AppTextColorType.error,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Avatar(
                                  path:
                                      'https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by-1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    "Hi, ${userController.userData?.firstname != null ? userController.userData!.firstname : 'User'}",
                                    variant: AppTextVariant.headline4,
                                    weight: AppTextWeight.bold,
                                  ),
                                  AppText(
                                    _getGreetingMessage(),
                                    variant: AppTextVariant.bodySmall,
                                    weight: AppTextWeight.semiBold,
                                    colorType: AppTextColorType.gray,
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
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizing.scaffoldHorizontalPadding,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkCardBG,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.darkButtonBorder,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    "Your Networth",
                                    variant: AppTextVariant.headline4,
                                    weight: AppTextWeight.bold,
                                    colorType: AppTextColorType.tertiary,
                                  ),
                                  AppText(
                                    "Last data fetched at 11:00pm",
                                    variant: AppTextVariant.tiny,
                                    weight: AppTextWeight.semiBold,
                                    colorType: AppTextColorType.gray,
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AnimatedAmount(
                                    amount: "₹76,171,095",
                                    isAmountVisible: _isAmountVisible,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isAmountVisible = !_isAmountVisible;
                                      });
                                    },
                                    child: Icon(
                                      _isAmountVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color:
                                          AppColors.darkButtonPrimaryBackground,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              const NetworthChart(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppSizing.scaffoldHorizontalPadding,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: AppSizing.scaffoldHorizontalPadding,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      "Assets",
                                      variant: AppTextVariant.headline5,
                                      weight: AppTextWeight.bold,
                                      colorType: AppTextColorType.tertiary,
                                    ),
                                    AppText(
                                      "See All",
                                      variant: AppTextVariant.bodyMedium,
                                      weight: AppTextWeight.medium,
                                      colorType: AppTextColorType.tertiary,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  right: AppSizing.scaffoldHorizontalPadding,
                                ),
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  spacing: 15,
                                  children: [
                                    InkWell(
                                      onTap:
                                          () => Get.to(
                                            const ConnectionsScreen(),
                                            transition: Transition.rightToLeft,
                                          ),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight:
                                              120, // Set a minimum height to match AssetCard
                                        ),
                                        child: Container(
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: AppColors.darkCardBG,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: AppColors.darkButtonBorder,
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
                                        if (controller.dashboardAssets?.data != null) {
                                          return Row(
                                            children: controller.dashboardAssets!.data!.assetdata.map((asset) => Padding(
                                              padding: const EdgeInsets.only(right: 15),
                                              child: InkWell(
                                                onTap: () => Get.to(
                                                  asset.name == "Banks" ? const AssetBankScreen() : const AssetInvestmentScreen(),
                                                  transition: Transition.rightToLeft,
                                                ),
                                                child: AssetCard(
                                                  title: asset.name,
                                                  amount: CurrencyFormatter.formatRupee(asset.value),
                                                  delta: "${asset.deltapercentage}%",
                                                  deltaType: asset.deltavalue >= 0 ? DeltaType.positive : DeltaType.negative,
                                                  icon: Icons.account_balance_outlined,
                                                ),
                                              ),
                                            )).toList(),
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
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizing.scaffoldHorizontalPadding,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: RadialGradient(
                              center: Alignment.topCenter,
                              radius: 2,
                              colors: [
                                Color.fromRGBO(165, 108, 236, 0.8),
                                Color.fromRGBO(41, 9, 81, 1),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          "Connect with Zerodha",
                                          variant: AppTextVariant.headline4,
                                          weight: AppTextWeight.bold,
                                          colorType: AppTextColorType.primary,
                                        ),
                                        AppText(
                                          "Log in to Kite to link out all your investments and keep a track on them!",
                                          variant: AppTextVariant.bodySmall,
                                          weight: AppTextWeight.regular,
                                          colorType: AppTextColorType.primary,
                                        ),
                                        SizedBox(height: 18),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors
                                                    .darkButtonPrimaryBackground,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: AppText(
                                            "Connect",
                                            variant: AppTextVariant.bodySmall,
                                            weight: AppTextWeight.bold,
                                            colorType:
                                                AppTextColorType.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SvgPicture.asset(
                                    "assets/svgs/dashboard/zerodha_banner.svg",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: 2.7,
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
                              ...List.generate(5, (index) {
                                return Container(
                                  color:
                                      themeController.isDarkMode
                                          ? AppColors.darkCardBG
                                          : AppColors.lightBackground,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizing.scaffoldHorizontalPadding,
                                    vertical: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              "Save up to 3.2% annually",
                                              variant:
                                                  AppTextVariant.bodyMedium,
                                              weight: AppTextWeight.semiBold,
                                            ),
                                            SizedBox(height: 6),
                                            AppText(
                                              "Switching from regular to direct mutual fund can boost portfolio by saving ₹2.7L on commissions",
                                              variant: AppTextVariant.tiny,
                                              weight: AppTextWeight.semiBold,
                                              colorType:
                                                  AppTextColorType.secondary,
                                            ),
                                            SizedBox(height: 18),
                                            AppText(
                                              "Switch Funds",
                                              variant:
                                                  AppTextVariant.bodyMedium,
                                              weight: AppTextWeight.semiBold,
                                              colorType: AppTextColorType.link,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        "assets/svgs/dashboard/mf_banner.svg",
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              width: currentPage == index ? 24 : 8,
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
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
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
                    label: "Products",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.smart_toy_rounded),
                    label: "Advisory",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_rounded),
                    label: "Explore",
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
