import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/custom_accordion.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class SipDetailsWidget extends StatelessWidget {
  final String minimumSip;
  final String maximumSip;
  final String frequency;
  final String lockInPeriod;

  const SipDetailsWidget({
    super.key,
    required this.minimumSip,
    required this.maximumSip,
    required this.frequency,
    required this.lockInPeriod,
  });

  @override
  Widget build(BuildContext context) {
    // final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final Color textColor =
    //     isDarkMode ? AppColors.darkInputBorder : AppColors.lightTextSecondary;
    // final Color valueColor =
    //     isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return CustomAccordion(
      title: 'Your SIP Details',
      initiallyExpanded: true,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 2.5,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // SIP Amount
          _buildGridItem(label: 'Minimum SIP ', value: minimumSip),

          // SIP Dates
          _buildGridItem(label: 'Maximum SIP ', value: maximumSip),

          // Frequency
          _buildGridItem(label: 'Frequency', value: frequency),

          // Lock-in-Period
          _buildGridItem(label: 'Lock-in-Period', value: lockInPeriod),
        ],
      ),
    );
  }

  Widget _buildGridItem({
    required String label,
    required String value,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            AppText(
              label,
              variant: AppTextVariant.bodyMedium,
              colorType: AppTextColorType.secondary,
            ),
            if (suffix != null) ...[const SizedBox(width: 4), suffix],
          ],
        ),
        const SizedBox(height: 4),
        AppText(
          value,
          variant: AppTextVariant.bodyMedium,
          weight: AppTextWeight.semiBold,
          colorType: AppTextColorType.primary,
        ),
      ],
    );
  }
}
