import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class NpsPage extends StatefulWidget {
  const NpsPage({super.key});

  @override
  State<NpsPage> createState() => _NpsPageState();
}

class _NpsPageState extends State<NpsPage> {
  String _selectedTab = 'Tier 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const AppText(
          'NPS',
          variant: AppTextVariant.headline6,
          weight: AppTextWeight.bold,
          colorType: AppTextColorType.primary,
        ),
        centerTitle: true,
                actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Handle info button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Holdings Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Your Holdings',
                        variant: AppTextVariant.headline4,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.primary,
                      ),
                      SizedBox(height: 5),
                      AppText(
                        '₹ 10,00,000',
                        variant: AppTextVariant.headline1,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.primary,
                      ),
                    ],
                  ),
                  const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 28),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tier Tabs
            Row(
              children: [
                Expanded(
                  child: _buildTab('Tier 1', 'Moderate', '₹5,00,000'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTab('Tier 2', 'Aggressive', '₹5,00,000'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pension Fund Cards
            _pensionCard('SBI Pension Fund', '200', '₹1,50,000', '+1.2%', Colors.green),
            _pensionCard('LIC Pension Fund', '200', '₹1,00,000', '+0.3%', Colors.green),
            _pensionCard('Axis Pension Fund', '200', '₹2,50,000', '-2.01%',Colors.red.shade600,),

            const Spacer(),

            // Track NPS Button
            SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              debugPrint('Track NPS button pressed!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFCFCFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: const AppText(
              'Track NPS',
              variant: AppTextVariant.bodyLarge,
              weight: AppTextWeight.bold,
              colorType: AppTextColorType.tertiary,
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }

 Widget _buildTab(String title, String subtitle, String amount) {
  bool isSelected = (_selectedTab == title);
  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedTab = title;
      });
    },
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFfcfcfc) : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and subtitle in a single row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                title,
                variant: AppTextVariant.bodyLarge,
                weight: isSelected ? AppTextWeight.bold : AppTextWeight.semiBold,
                colorType: isSelected ? AppTextColorType.tertiary : AppTextColorType.primary,
              ),
              AppText(
                subtitle,
                variant: AppTextVariant.bodySmall,
                weight: isSelected ? AppTextWeight.bold : AppTextWeight.semiBold,
                colorType: isSelected ? AppTextColorType.tertiary : AppTextColorType.primary,
              ),
            ],
          ),
          const SizedBox(height: 4),
          AppText(
            amount,
            variant: AppTextVariant.headline3,
            weight: isSelected ? AppTextWeight.bold : AppTextWeight.semiBold,
            colorType: isSelected ? AppTextColorType.tertiary : AppTextColorType.primary,
          ),
        ],
      ),
    ),
  );
}


Widget _pensionCard(String title, String units, String value, String change, Color changeColor) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: const Color(0xFF1E1E1E), // Outer box color for title
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          variant: AppTextVariant.bodyMedium,
          weight: AppTextWeight.semiBold,
          colorType: AppTextColorType.primary,
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF202224), // Inner box background (darker)
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText('Units: $units',
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.regular,
                      colorType: AppTextColorType.primary),
                  AppText('NAV: 24.80',
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.regular,
                      colorType: AppTextColorType.primary),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [

                  AppText('Value: $value',
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.regular,
                      colorType: AppTextColorType.primary),
                      const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: changeColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: AppText(
                      change,
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.bold,
                      colorType: AppTextColorType.primary,
                    ),
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
}
