import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/dashboard/dashboard.dart';
import 'package:nwt_app/screens/explore/explore.dart';
import 'package:nwt_app/screens/products/products.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class AdvisoryScreen extends StatefulWidget {
  const AdvisoryScreen({super.key});

  @override
  State<AdvisoryScreen> createState() => _AdvisoryScreenState();
}

class _AdvisoryScreenState extends State<AdvisoryScreen> {
  int _selectedIndex = 2; // Advisory tab selected
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
              "Advisory",
              variant: AppTextVariant.headline6,
              weight: AppTextWeight.semiBold,
            ),
            const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.scaffoldHorizontalPadding,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: SvgPicture.asset(
                  "assets/svgs/advisory/ai.svg",
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.darkInputBorder,
                  ),
                ),
                child: Column(
                  children: [
                    AppText(
                      "The AI Advisory analyzes your complete investment portfolio in real-time, delivering intelligent recommendations tailored to your financial goals, risk tolerance, and market conditions. This will include advisory on Mutual funds, equity, insurance and other assets.",
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.primary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
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
          if (index == 0) { // Home tab
            Get.off(() => const Dashboard(), transition: Transition.leftToRight);
          } else if (index == 1) { // Products tab
            Get.off(() => const ProductsScreen(), transition: Transition.leftToRight);
          } else if (index == 3) { // Explore tab
            Get.off(() => const ExploreScreen(), transition: Transition.rightToLeft);
          }
        },
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkTextGray,
        type: BottomNavigationBarType.fixed,
        items: const [
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
  }
}