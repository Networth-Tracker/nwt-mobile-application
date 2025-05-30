import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/advisory/advisory.dart';
import 'package:nwt_app/screens/dashboard/dashboard.dart';
import 'package:nwt_app/screens/products/products.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedIndex = 3; // Explore tab selected
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color iconBackgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCardBG,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkButtonBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.darkTextSecondary, size: 28),
          ),
          const SizedBox(height: 16),
          AppText(
            title,
            variant: AppTextVariant.headline6,
            weight: AppTextWeight.semiBold,
            colorType: AppTextColorType.primary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

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
              "Explore",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: AppText(
                  "Explore the features of Pivot.Money",
                  variant: AppTextVariant.headline6,
                  weight: AppTextWeight.semiBold,
                  colorType: AppTextColorType.link,
                ),
              ),
              const SizedBox(height: 30),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    icon: Icons.family_restroom,
                    title: "Family Finance",
                    iconBackgroundColor: AppColors.darkButtonBorder,
                  ),
                  _buildFeatureCard(
                    icon: Icons.description,
                    title: "Estate Planning",
                    iconBackgroundColor: AppColors.darkButtonBorder,
                  ),
                  _buildFeatureCard(
                    icon: Icons.calendar_today,
                    title: "Financial Calendar",
                    iconBackgroundColor: AppColors.darkButtonBorder,
                  ),
                  _buildFeatureCard(
                    icon: Icons.auto_awesome,
                    title: "Finance GPT",
                    iconBackgroundColor: AppColors.darkButtonBorder,
                  ),
                ],
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
          if (index == 0) {
            // Home tab
            Get.off(
              () => const Dashboard(),
              transition: Transition.leftToRight,
            );
          } else if (index == 1) {
            // Products tab
            Get.off(
              () => const ProductsScreen(),
              transition: Transition.leftToRight,
            );
          } else if (index == 2) {
            // Advisory tab
            Get.off(
              () => const AdvisoryScreen(),
              transition: Transition.leftToRight,
            );
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
