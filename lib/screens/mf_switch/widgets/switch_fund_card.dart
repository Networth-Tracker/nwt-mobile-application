import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/widgets/common/dot_indicator.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class SwitchFundCard extends StatelessWidget {
  final String fundName;
  final String fundType;
  final String commission;
  final double gainAmount;
  final String targetFundName;
  final String targetFundType;
  final String targetCommission;
  final String fundIconUrl;

  const SwitchFundCard({
    Key? key,
    required this.fundName,
    required this.fundType,
    required this.commission,
    required this.gainAmount,
    required this.targetFundName,
    required this.targetFundType,
    required this.targetCommission,
    required this.fundIconUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCardBG,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First column with avatar
          
          Column(
            mainAxisSize: MainAxisSize.min,
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
                    fundIconUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DotIndicator(
                dotCount: 16,
                direction: DotDirection.vertical,
                dotColor: AppColors.darkTextGray,
                dotSize: 3,
                dotSpacing: 6,
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Second column with fund details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: fundName,
                        style: TextStyle(
                          color: AppColors.darkTextPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: " ($commission)",
                        style: TextStyle(
                          color: AppColors.darkTextSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fundType,
                  style: TextStyle(color: AppColors.linkColor, fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/assets/mutual_funds/down_arrow.svg',
                      width: 24,
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: AppText(
                        "Gain ₹$gainAmount",
                        variant: AppTextVariant.bodySmall,
                        weight: AppTextWeight.medium,
                        colorType: AppTextColorType.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: targetFundName,
                        style: TextStyle(
                          color: AppColors.darkTextPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: " ($targetCommission)",
                        style: TextStyle(
                          color: AppColors.darkTextSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  targetFundType,
                  style: TextStyle(color: AppColors.linkColor, fontSize: 14),
                ),
              ],
            ),
          ),
          Checkbox(
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.darkPrimary,
          ),
        ],
      ),
    );
  }
}
