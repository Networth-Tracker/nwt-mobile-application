import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({super.key});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
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
              "Transaction Details",
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
              SizedBox(height: 22),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.darkCardBG,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.darkButtonBorder),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    SizedBox(height: 18),
                    Column(
                      spacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.darkButtonBorder,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.arrow_upward,
                            size: 22,
                            color: AppColors.error,
                          ),
                        ),
                        AppText(
                          "₹10,500",
                          variant: AppTextVariant.headline2,
                          weight: AppTextWeight.bold,
                          colorType: AppTextColorType.primary,
                        ),
                        AppText(
                          "Shopping",
                          variant: AppTextVariant.bodySmall,
                          weight: AppTextWeight.medium,
                          colorType: AppTextColorType.secondary,
                        ),
                      ],
                    ),
                    SizedBox(height: 28),
                    Column(
                      spacing: 10,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              "Transaction ID:",
                              variant: AppTextVariant.headline6,
                              weight: AppTextWeight.regular,
                              colorType: AppTextColorType.primary,
                            ),
                            AppText(
                              "1234567890",
                              variant: AppTextVariant.bodySmall,
                              weight: AppTextWeight.medium,
                              colorType: AppTextColorType.primary,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              "To:",
                              variant: AppTextVariant.headline6,
                              weight: AppTextWeight.regular,
                              colorType: AppTextColorType.primary,
                            ),
                            AppText(
                              "Myntra@okpayaxis",
                              variant: AppTextVariant.bodySmall,
                              weight: AppTextWeight.medium,
                              colorType: AppTextColorType.primary,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              "Method:",
                              variant: AppTextVariant.headline6,
                              weight: AppTextWeight.regular,
                              colorType: AppTextColorType.primary,
                            ),
                            AppText(
                              "Visa Card   0976",
                              variant: AppTextVariant.bodySmall,
                              weight: AppTextWeight.medium,
                              colorType: AppTextColorType.primary,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              "Status:",
                              variant: AppTextVariant.headline6,
                              weight: AppTextWeight.regular,
                              colorType: AppTextColorType.primary,
                            ),
                            Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                AppText(
                                  "Completed",
                                  variant: AppTextVariant.bodySmall,
                                  weight: AppTextWeight.medium,
                                  colorType: AppTextColorType.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              "Date & Time:",
                              variant: AppTextVariant.headline6,
                              weight: AppTextWeight.regular,
                              colorType: AppTextColorType.primary,
                            ),
                            AppText(
                              "May 12, 12:15 AM",
                              variant: AppTextVariant.bodySmall,
                              weight: AppTextWeight.medium,
                              colorType: AppTextColorType.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        // color: AppColors.darkButtonBorder,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.darkButtonBorder),
                      ),
                      child: Column(
                        children: [
                         Icon(Icons.upload, color: AppColors.darkPrimary),
                         SizedBox(height: 18),
                         AppText(
                           "Upload Document",
                           variant: AppTextVariant.bodyMedium,
                           weight: AppTextWeight.regular,
                           colorType: AppTextColorType.primary,
                         ),
                         SizedBox(height: 4),
                         AppText(
                           "(pdf, png, jpg, jpeg, xls, xlsx, csv)",
                           variant: AppTextVariant.bodySmall,
                           weight: AppTextWeight.regular,
                           colorType: AppTextColorType.secondary,
                         ),
                        ],
                      ),
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
