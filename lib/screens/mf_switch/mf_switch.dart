import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class MutualFundSwitchScreen extends StatefulWidget {
  const MutualFundSwitchScreen({super.key});

  @override
  State<MutualFundSwitchScreen> createState() => _MutualFundSwitchScreenState();
}

class _MutualFundSwitchScreenState extends State<MutualFundSwitchScreen> {
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
              "Switch Plan",
              variant: AppTextVariant.headline6,
              weight: AppTextWeight.semiBold,
            ),
            const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSizing.scaffoldHorizontalPadding,
              right: AppSizing.scaffoldHorizontalPadding,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.darkCardBG,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkButtonBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Past Performance",
                        variant: AppTextVariant.bodyLarge,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.primary,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkInputBorder,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.darkButtonBorder),
                        ),
                        child: Column(
                          spacing: 6,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Invested",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                                AppText(
                                  "₹10,00,000",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.bold,
                                  colorType: AppTextColorType.primary,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Held For",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                                AppText(
                                  "1 Year",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.bold,
                                  colorType: AppTextColorType.primary,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Regular Plan value",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                                AppText(
                                  "₹10,88,500",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.bold,
                                  colorType: AppTextColorType.primary,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Direct Plan value",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.primary,
                                ),
                                AppText(
                                  "₹10,88,500",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.bold,
                                  colorType: AppTextColorType.primary,
                                ),
                              ],
                            ),
                            const Divider(color: AppColors.darkTextSecondary),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Commission Paid",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.semiBold,
                                  colorType: AppTextColorType.error,
                                ),
                                AppText(
                                  "₹11,500",
                                  variant: AppTextVariant.bodyMedium,
                                  weight: AppTextWeight.bold,
                                  colorType: AppTextColorType.error,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.darkCardBG,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkButtonBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Switch Regular to DIrect Plans",
                        variant: AppTextVariant.headline6,
                        weight: AppTextWeight.bold,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
