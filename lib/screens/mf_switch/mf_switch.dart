import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/widgets/common/custom_checkbox.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class MutualFundSwitchScreen extends StatefulWidget {
  const MutualFundSwitchScreen({super.key});

  @override
  State<MutualFundSwitchScreen> createState() => _MutualFundSwitchScreenState();
}

class _MutualFundSwitchScreenState extends State<MutualFundSwitchScreen> {
  final bool _selectAllFunds = false;
  bool _selectedFund = true;
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
          physics: const BouncingScrollPhysics(),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            const Divider(
                              color: AppColors.darkTextSecondary,
                              thickness: 1,
                            ),
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
                const SizedBox(height: 12),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  "Switch Regular to Direct Plans",
                                  variant: AppTextVariant.headline6,
                                  weight: AppTextWeight.bold,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "Long term funds held over 12 months are selected.",
                                        style: TextStyle(
                                          color: AppColors.darkTextSecondary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      TextSpan(
                                        text: " Why?",
                                        style: TextStyle(
                                          color: AppColors.linkColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomCheckbox(
                            value: _selectedFund,
                            onChanged: (value) {
                              setState(() {
                                _selectedFund = value ?? false;
                              });
                            },
                            size: 14,
                            activeColor: AppColors.darkPrimary,
                            checkColor: AppColors.darkBackground,
                            borderWidth: 1,
                            borderColor: AppColors.darkInputText,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Column(
                        spacing: 12,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.darkInputBorder,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.darkButtonBorder,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 14,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        color: AppColors.darkButtonBorder,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.info,
                                        color: AppColors.darkTextSecondary,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "Franklin India Opportunities Fund",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.darkPrimary,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " (1.10% expense ratio) ",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors
                                                            .darkTextSecondary,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          AppText(
                                            "Regular Fund",
                                            variant: AppTextVariant.bodyMedium,
                                            weight: AppTextWeight.medium,
                                            colorType: AppTextColorType.link,
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/svgs/assets/mutual_funds/down_arrow.svg",
                                              ),
                                              const SizedBox(width: 6),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                spacing: 4,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.success
                                                          .withValues(
                                                            alpha: 0.15,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    child: const AppText(
                                                      "Gain 1.10%",
                                                      variant:
                                                          AppTextVariant
                                                              .bodySmall,
                                                      weight:
                                                          AppTextWeight.bold,
                                                      colorType:
                                                          AppTextColorType
                                                              .success,
                                                    ),
                                                  ),
                                                  AppText(
                                                    "LTCG Tax Payable ₹12,812",
                                                    variant:
                                                        AppTextVariant
                                                            .bodySmall,
                                                    weight:
                                                        AppTextWeight.medium,
                                                    colorType:
                                                        AppTextColorType
                                                            .primary,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    CustomCheckbox(
                                      value: _selectedFund,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFund = value ?? false;
                                        });
                                      },
                                      size: 14,
                                      activeColor: AppColors.darkPrimary,
                                      checkColor: AppColors.darkBackground,
                                      borderWidth: 1,
                                      borderColor: AppColors.darkInputText,
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        color: AppColors.darkButtonBorder,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.info,
                                        color: AppColors.darkTextSecondary,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "Franklin India Opportunities Fund",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.darkPrimary,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " (1.10% expense ratio) ",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors
                                                            .darkTextSecondary,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          AppText(
                                            "Direct Fund",
                                            variant: AppTextVariant.bodyMedium,
                                            weight: AppTextWeight.medium,
                                            colorType: AppTextColorType.link,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.darkInputBorder,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.darkButtonBorder,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 14,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        color: AppColors.darkButtonBorder,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.info,
                                        color: AppColors.darkTextSecondary,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "Franklin India Opportunities Fund",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.darkPrimary,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " (1.10% expense ratio) ",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors
                                                            .darkTextSecondary,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          AppText(
                                            "Regular Fund",
                                            variant: AppTextVariant.bodyMedium,
                                            weight: AppTextWeight.medium,
                                            colorType: AppTextColorType.link,
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/svgs/assets/mutual_funds/down_arrow.svg",
                                              ),
                                              const SizedBox(width: 6),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                spacing: 4,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.success
                                                          .withValues(
                                                            alpha: 0.15,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    child: const AppText(
                                                      "Gain 1.10%",
                                                      variant:
                                                          AppTextVariant
                                                              .bodySmall,
                                                      weight:
                                                          AppTextWeight.bold,
                                                      colorType:
                                                          AppTextColorType
                                                              .success,
                                                    ),
                                                  ),
                                                  AppText(
                                                    "LTCG Tax Payable ₹12,812",
                                                    variant:
                                                        AppTextVariant
                                                            .bodySmall,
                                                    weight:
                                                        AppTextWeight.medium,
                                                    colorType:
                                                        AppTextColorType
                                                            .primary,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    CustomCheckbox(
                                      value: _selectedFund,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFund = value ?? false;
                                        });
                                      },
                                      size: 14,
                                      activeColor: AppColors.darkPrimary,
                                      checkColor: AppColors.darkBackground,
                                      borderWidth: 1,
                                      borderColor: AppColors.darkInputText,
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        color: AppColors.darkButtonBorder,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.info,
                                        color: AppColors.darkTextSecondary,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "Franklin India Opportunities Fund",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.darkPrimary,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " (1.10% expense ratio) ",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors
                                                            .darkTextSecondary,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          AppText(
                                            "Direct Fund",
                                            variant: AppTextVariant.bodyMedium,
                                            weight: AppTextWeight.medium,
                                            colorType: AppTextColorType.link,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
