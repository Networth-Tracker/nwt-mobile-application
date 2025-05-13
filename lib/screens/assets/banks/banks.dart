import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/widgets/common/app_input_field.dart';
import 'package:nwt_app/screens/assets/banks/widgets/bank_card.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class AssetBankScreen extends StatefulWidget {
  const AssetBankScreen({super.key});

  @override
  State<AssetBankScreen> createState() => _AssetBankScreenState();
}

class _AssetBankScreenState extends State<AssetBankScreen> {
  TextEditingController _searchController = TextEditingController();
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
              "Banks",
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
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darkButtonBorder),
                  color: AppColors.darkCardBG,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "Total balance",
                              variant: AppTextVariant.headline4,
                              weight: AppTextWeight.bold,
                              colorType: AppTextColorType.primary,
                            ),
                            SizedBox(height: 3),
                            AppText(
                              "Last data fetched at 12:12pm",
                              variant: AppTextVariant.bodySmall,
                              weight: AppTextWeight.medium,
                              colorType: AppTextColorType.secondary,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.darkButtonBorder,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.refresh,
                            size: 22,
                            color: AppColors.darkTextMuted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          "₹62,00,320",
                          variant: AppTextVariant.display,
                          weight: AppTextWeight.bold,
                          colorType: AppTextColorType.primary,
                        ),
                        Icon(Icons.visibility_outlined),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        "+ 0.28 (0.20%)",
                        variant: AppTextVariant.bodySmall,
                        weight: AppTextWeight.medium,
                        colorType: AppTextColorType.success,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkCardBG,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.darkButtonBorder),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        spacing: 16,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/assets/banks/money-transfer.svg',
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Track your complete\n",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                TextSpan(
                                  text: "Transactions ",
                                  style: TextStyle(
                                    color: AppColors.info,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                TextSpan(
                                  text: "timeline!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.darkButtonBorder,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: AppColors.darkTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              AppInputField(
                controller: _searchController,
                prefix: Icon(
                  CupertinoIcons.search,
                  color: AppColors.darkTextMuted,
                ),
                hintText: "Search...",
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    spacing: 15,
                    children: [
                      const BankCard(
                        icon: Icons.account_balance,
                        bankName: "ICICI Bank",
                        accountNumber: "XXXX XXXX XXXX 2087",
                        balance: "₹10,500",
                        deltaValue: "0.28%",
                        isPositiveDelta: true,
                      ),
                      const BankCard(
                        icon: Icons.credit_card,
                        bankName: "HDFC Bank",
                        accountNumber: "XXXX XXXX XXXX 4321",
                        balance: "₹25,750",
                        deltaValue: "0.15%",
                        isPositiveDelta: false,
                      ),
                      const BankCard(
                        icon: Icons.account_balance,
                        bankName: "ICICI Bank",
                        accountNumber: "XXXX XXXX XXXX 2087",
                        balance: "₹10,500",
                        deltaValue: "0.28%",
                        isPositiveDelta: true,
                      ),
                      const BankCard(
                        icon: Icons.account_balance,
                        bankName: "ICICI Bank",
                        accountNumber: "XXXX XXXX XXXX 2087",
                        balance: "₹10,500",
                        deltaValue: "0.28%",
                        isPositiveDelta: true,
                      ),
                      const BankCard(
                        icon: Icons.credit_card,
                        bankName: "HDFC Bank",
                        accountNumber: "XXXX XXXX XXXX 4321",
                        balance: "₹25,750",
                        deltaValue: "0.15%",
                        isPositiveDelta: false,
                      ),
                      const BankCard(
                        icon: Icons.account_balance,
                        bankName: "ICICI Bank",
                        accountNumber: "XXXX XXXX XXXX 2087",
                        balance: "₹10,500",
                        deltaValue: "0.28%",
                        isPositiveDelta: true,
                      ),
                      const BankCard(
                        icon: Icons.account_balance,
                        bankName: "ICICI Bank",
                        accountNumber: "XXXX XXXX XXXX 2087",
                        balance: "₹10,500",
                        deltaValue: "0.28%",
                        isPositiveDelta: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Add Banks',
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                      isLoading: false,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
