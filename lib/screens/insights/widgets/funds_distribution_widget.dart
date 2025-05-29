import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/custom_accordion.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class FundsDistributionWidget extends StatefulWidget {
  const FundsDistributionWidget({super.key});

  @override
  State<FundsDistributionWidget> createState() =>
      _FundsDistributionWidgetState();
}

class _FundsDistributionWidgetState extends State<FundsDistributionWidget> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Equity', 'Debt & Cash'];

  @override
  Widget build(BuildContext context) {
    return CustomAccordion(
      title: 'Funds Distribution',
      initiallyExpanded: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs for Equity and Debt & Cash
            _buildTabs(),
            const SizedBox(height: 24),

            // Show different content based on selected tab
            if (_selectedTabIndex == 0) ...[
            // Size Breakup section for Equity
            _buildSizeBreakup(),
            const SizedBox(height: 24),

            // Size categories with percentages for Equity
            _buildSizeCategories(),
          ] else ...[
            // Credit Rating Breakup for Debt & Cash
            _buildCreditRatingBreakup(),
            const SizedBox(height: 24),

            // Credit Rating categories for Debt & Cash
            _buildCreditRatingCategories(),
          ],
          const SizedBox(height: 16),
        ],
      ),
    ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(
          _tabs.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == index
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: AppText(
                  _tabs[index],
                  variant: AppTextVariant.bodySmall,
                  weight: AppTextWeight.bold,
                  colorType: _selectedTabIndex == index
                      ? AppTextColorType.primary
                      : AppTextColorType.secondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSizeBreakup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              'Size Breakup',
              variant: AppTextVariant.bodyMedium,
              weight: AppTextWeight.semiBold,
              colorType: AppTextColorType.secondary,
            ),
            AppText(
              '100%',
              variant: AppTextVariant.bodyMedium,
              weight: AppTextWeight.semiBold,
              colorType: AppTextColorType.primary,
              customColor: const Color(0xFF3ABFF8), // Light blue color
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Single stacked progress bar
        SizedBox(
          height: 8,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                // Background
                Container(
                  width: double.infinity,
                  color: const Color(0xFF2A2A2A),
                ),
                // Mid Cap (Light blue) - 48.2%
                FractionallySizedBox(
                  widthFactor: 0.482 + 0.405 + 0.113, // Total width
                  child: Row(
                    children: [
                      // Mid Cap - 48.2%
                      Expanded(
                        flex: 482, // 48.2%
                        child: Container(color: const Color(0xFF3ABFF8)),
                      ),
                      // Large Cap - 40.5%
                      Expanded(
                        flex: 405, // 40.5%
                        child: Container(color: const Color(0xFFD926AA)),
                      ),
                      // Small Cap - 11.3%
                      Expanded(
                        flex: 113, // 11.3%
                        child: Container(color: const Color(0xFFFBBD23)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeCategories() {
    return Column(
      children: [
        _buildSizeCategory('Mid Cap', '48.2%', const Color(0xFF3ABFF8)),
        const SizedBox(height: 16),
        _buildSizeCategory('Large Cap', '40.5%', const Color(0xFFD926AA)),
        const SizedBox(height: 16),
        _buildSizeCategory('Small Cap', '11.3%', const Color(0xFFFBBD23)),
      ],
    );
  }

  Widget _buildSizeCategory(String name, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        AppText(
          name,
          variant: AppTextVariant.bodyMedium,
          weight: AppTextWeight.medium,
          colorType: AppTextColorType.primary,
        ),
        const Spacer(),
        AppText(
          percentage,
          variant: AppTextVariant.bodyMedium,
          weight: AppTextWeight.semiBold,
          colorType: AppTextColorType.primary,
        ),
      ],
    );
  }

  // Credit Rating Breakup for Debt & Cash tab
  Widget _buildCreditRatingBreakup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              'Credit Rating Breakup',
              variant: AppTextVariant.bodyMedium,
              weight: AppTextWeight.semiBold,
              colorType: AppTextColorType.secondary,
            ),
            AppText(
              '2.1%',
              variant: AppTextVariant.bodyMedium,
              weight: AppTextWeight.semiBold,
              colorType: AppTextColorType.primary,
              customColor: const Color(0xFF3ABFF8),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Single progress bar for AAA rating (100%)
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: const LinearProgressIndicator(
            value: 1.0, // 100%
            backgroundColor: Color(0xFF2A2A2A),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3ABFF8)),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  // Credit Rating Categories for Debt & Cash tab
  Widget _buildCreditRatingCategories() {
    return Row(
      children: [
        Container(
          width: 16,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFF3ABFF8),
          ),
        ),
        const SizedBox(width: 12),
        AppText(
          'AAA',
          variant: AppTextVariant.bodyMedium,
          weight: AppTextWeight.semiBold,
          colorType: AppTextColorType.primary,
        ),
        const Spacer(),
        AppText(
          '100%',
          variant: AppTextVariant.bodyMedium,
          weight: AppTextWeight.semiBold,
          colorType: AppTextColorType.primary,
        ),
      ],
    );
  }
}
