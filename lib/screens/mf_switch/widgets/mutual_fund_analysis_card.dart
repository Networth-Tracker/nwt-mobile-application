import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class MutualFundAnalysisCard extends StatelessWidget {
  final String logoUrl;
  final String schemeName;
  final String fundType;
  final String investedAmount;

  const MutualFundAnalysisCard({
    super.key,
    required this.logoUrl,
    required this.schemeName,
    required this.fundType,
    required this.investedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkInputBorder,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkButtonBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkCardBG,
            ),
            child: ClipOval(
              child: SvgPicture.network(
                logoUrl,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  schemeName,
                  variant: AppTextVariant.headline6,
                  weight: AppTextWeight.semiBold,
                  colorType: AppTextColorType.primary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                AppText(
                  fundType,
                  variant: AppTextVariant.bodySmall,
                  weight: AppTextWeight.semiBold,
                  colorType: AppTextColorType.link,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                "Invested",
                variant: AppTextVariant.caption,
                weight: AppTextWeight.semiBold,
                colorType: AppTextColorType.secondary,
              ),
              const SizedBox(height: 4),
              AppText(
                investedAmount,
                variant: AppTextVariant.bodyLarge,
                weight: AppTextWeight.semiBold,
                colorType: AppTextColorType.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
