import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

/// A custom bottom sheet for the dashboard that shows mutual fund data is ready
class MutualFundBottomSheet extends StatelessWidget {
  const MutualFundBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCardBG,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Handle bar at the top
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.darkButtonBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Your ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkTextPrimary,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  TextSpan(
                    text: "Mutual Fund",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.linkColor,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  TextSpan(
                    text: " data is ready!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkTextPrimary,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Lottie.asset('assets/lottie/mf_loading.json'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Switch to ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkTextPrimary,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  TextSpan(
                    text: "potentially save ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkTextPrimary,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  TextSpan(
                    text: "₹2,05,854",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.success,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            AppText(
              "Check out our expert analysis & advisory",
              variant: AppTextVariant.bodyMedium,
              colorType: AppTextColorType.secondary,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Check Now', 
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}