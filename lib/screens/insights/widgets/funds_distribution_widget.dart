import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/custom_accordion.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class FundsDistributionWidget extends StatefulWidget {
  final Map<String, dynamic> equityDistribution;
  final Map<String, dynamic> debtCashDistribution;

  const FundsDistributionWidget({
    super.key,
    required this.equityDistribution,
    required this.debtCashDistribution,
  });

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
                  color:
                      _selectedTabIndex == index
                          ? Colors.white
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: AppText(
                  _tabs[index],
                  variant: AppTextVariant.bodySmall,
                  weight: AppTextWeight.bold,
                  colorType:
                      _selectedTabIndex == index
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
    // Get values from the equity distribution data
    final midcap = widget.equityDistribution['midcap'] ?? 0.0;
    final largecap = widget.equityDistribution['largecap'] ?? 0.0;
    final smallcap = widget.equityDistribution['smallcap'] ?? 0.0;

    // Calculate total for percentage display
    final total = midcap + largecap + smallcap;

    // Convert to integer flex values for the progress bar
    final midcapFlex = (midcap * 10).round();
    final largecapFlex = (largecap * 10).round();
    final smallcapFlex = (smallcap * 10).round();

    // Calculate the total width factor (should be 1.0 if all data is present)
    final widthFactor = (midcap + largecap + smallcap) / 100;

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
              '${total.toStringAsFixed(1)}%',
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
                // Stacked progress bars
                FractionallySizedBox(
                  widthFactor: widthFactor, // Total width based on actual data
                  child: Row(
                    children: [
                      // Mid Cap
                      Expanded(
                        flex: midcapFlex,
                        child: Container(color: const Color(0xFF3ABFF8)),
                      ),
                      // Large Cap
                      Expanded(
                        flex: largecapFlex,
                        child: Container(color: const Color(0xFFD926AA)),
                      ),
                      // Small Cap
                      Expanded(
                        flex: smallcapFlex,
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
    // Get values from the equity distribution data
    final midcap = widget.equityDistribution['midcap'] ?? 0.0;
    final largecap = widget.equityDistribution['largecap'] ?? 0.0;
    final smallcap = widget.equityDistribution['smallcap'] ?? 0.0;

    return Column(
      children: [
        _buildSizeCategory(
          'Mid Cap',
          '${midcap.toStringAsFixed(1)}%',
          const Color(0xFF3ABFF8),
        ),
        const SizedBox(height: 16),
        _buildSizeCategory(
          'Large Cap',
          '${largecap.toStringAsFixed(1)}%',
          const Color(0xFFD926AA),
        ),
        const SizedBox(height: 16),
        _buildSizeCategory(
          'Small Cap',
          '${smallcap.toStringAsFixed(1)}%',
          const Color(0xFFFBBD23),
        ),
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
    // Get AAA value from the debt cash distribution data
    final aaa = widget.debtCashDistribution['aaa'] ?? 0.0;

    // Calculate progress value (0.0 to 1.0)
    final progressValue = aaa / 100;

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
              '${aaa.toStringAsFixed(1)}%',
              variant: AppTextVariant.bodyMedium,
              weight: AppTextWeight.semiBold,
              colorType: AppTextColorType.primary,
              customColor: const Color(0xFF3ABFF8),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Single progress bar for AAA rating
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: const Color(0xFF2A2A2A),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3ABFF8)),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  // Credit Rating Categories for Debt & Cash tab
  Widget _buildCreditRatingCategories() {
    // Get AAA value from the debt cash distribution data
    final aaa = widget.debtCashDistribution['aaa'] ?? 0.0;

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
          '${aaa.toStringAsFixed(1)}%',
          variant: AppTextVariant.bodyMedium,
          weight: AppTextWeight.semiBold,
          colorType: AppTextColorType.primary,
        ),
      ],
    );
  }
}
