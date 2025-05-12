import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:nwt_app/widgets/avatar.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/screens/dashboard/widgets/asset_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      const Avatar(
                        path:
                            'https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by-1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppText(
                            "Hi, Darshan",
                            variant: AppTextVariant.headline4,
                            weight: AppTextWeight.bold,
                          ),
                          const SizedBox(height: 6),
                          const AppText(
                            "Good Morning!",
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
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    border: Border.all(color: AppColors.darkButtonBorder),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight:
                                      120, // Set a minimum height to match AssetCard
                                ),
                                child: Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(38, 40, 44, 0.6),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.darkButtonBorder,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add_rounded, size: 26),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: AssetCard(
                                title: "Banks",
                                amount: "₹1,00,000",
                                delta: "-10%",
                                deltaType: DeltaType.negative,
                                icon: Icons.account_balance_outlined,
                              ),
                            ),
                            AssetCard(
                              title: "Banks",
                              amount: "₹1,00,000",
                              delta: "10%",
                              deltaType: DeltaType.positive,
                              icon: Icons.account_balance_outlined,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
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
                      children: [
                        AppText(
                          "₹1,00,000",
                          variant: AppTextVariant.display,
                          weight: AppTextWeight.bold,
                          colorType: AppTextColorType.primary,
                        ),
                        SvgPicture.asset(
                          "assets/svgs/dashboard/zerodha_banner.svg",
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
    );
  }
}
