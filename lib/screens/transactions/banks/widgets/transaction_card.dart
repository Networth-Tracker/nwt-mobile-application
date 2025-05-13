import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/screens/transactions/banks/details.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class BankTransactionCardWidget extends StatelessWidget {
  const BankTransactionCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const TransactionDetails(), transition: Transition.rightToLeft),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkCardBG,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.darkButtonBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.darkButtonBorder,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.arrow_upward,
                    size: 20,
                    color: AppColors.error,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      "Myntra",
                      variant: AppTextVariant.bodyLarge,
                      weight: AppTextWeight.semiBold,
                      colorType: AppTextColorType.primary,
                    ),
                    AppText(
                      "Today, 12:15 AM",
                      variant: AppTextVariant.bodySmall,
                      weight: AppTextWeight.regular,
                      colorType: AppTextColorType.secondary,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                AppText(
                  "₹10,500",
                  variant: AppTextVariant.bodyLarge,
                  weight: AppTextWeight.semiBold,
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
          ],
        ),
      ),
    );
  }
}
