import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/controllers/assets/banks.dart';
import 'package:nwt_app/screens/assets/banks/widgets/bank_card.dart';
import 'package:nwt_app/utils/currency_formatter.dart';
import 'package:nwt_app/widgets/common/animated_amount.dart';
import 'package:nwt_app/widgets/common/app_input_field.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class AssetBankScreen extends StatefulWidget {
  const AssetBankScreen({super.key});

  @override
  State<AssetBankScreen> createState() => _AssetBankScreenState();
}

class _AssetBankScreenState extends State<AssetBankScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final AnimationController _refreshController;
  final bankController = Get.put(BankController());
  bool isBankSummaryLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    fetchBankSummary();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> fetchBankSummary() async {
    bankController.getBankSummary(
      onLoading: (isLoading) {
        if (mounted) {
          setState(() {
            isBankSummaryLoading = isLoading;
          });
          if (isLoading) {
            _refreshController.repeat();
          } else {
            _refreshController.stop();
            _refreshController.reset();
          }
        }
      },
    );
  }

  bool _isAmountVisible = true;

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
          padding: EdgeInsets.only(
            left: AppSizing.scaffoldHorizontalPadding,
            right: AppSizing.scaffoldHorizontalPadding,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.darkCardBG, Color(0xFF727272)],
                    end: Alignment.topLeft,
                    begin: Alignment.bottomRight,
                  ).withOpacity(0.3),
                  border: Border.all(color: AppColors.darkButtonBorder),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<BankController>(
                      builder: (controller) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      "Total balance",
                                      variant: AppTextVariant.bodyMedium,
                                      weight: AppTextWeight.bold,
                                      colorType: AppTextColorType.secondary,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AnimatedAmount(
                                          isAmountVisible: _isAmountVisible,
                                          amount: CurrencyFormatter.formatRupee(
                                            controller
                                                    .bankSummary
                                                    ?.data
                                                    ?.totalbalance ??
                                                0,
                                          ),
                                          style: TextStyle(
                                            fontSize: 36.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.darkPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AppText(
                                      controller
                                                  .bankSummary
                                                  ?.data
                                                  ?.lastdatafetchtime !=
                                              null
                                          ? "Last data fetched at ${controller.bankSummary!.data!.lastdatafetchtime}"
                                          : "No data fetched yet",
                                      variant: AppTextVariant.tiny,
                                      weight: AppTextWeight.semiBold,
                                      colorType: AppTextColorType.secondary,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isAmountVisible = !_isAmountVisible;
                                    });
                                  },
                                  child: Icon(
                                    Icons.visibility_outlined,
                                    color:
                                        _isAmountVisible
                                            ? AppColors.darkPrimary
                                            : AppColors.darkTextMuted,
                                    size: 22.sp,
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () => fetchBankSummary(),
                                //   child: RotationTransition(
                                //     turns: _refreshController,
                                //     child: Container(
                                //       padding: const EdgeInsets.all(4),
                                //       decoration: BoxDecoration(
                                //         color: AppColors.darkButtonBorder,
                                //         borderRadius: BorderRadius.circular(15),
                                //       ),
                                //       child: const Icon(
                                //         Icons.refresh,
                                //         size: 22,
                                //         color: AppColors.darkTextMuted,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),

                            SizedBox(height: 8),
                            if (controller.bankSummary?.data?.deltavalue !=
                                null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          controller
                                                      .bankSummary!
                                                      .data!
                                                      .deltavalue >=
                                                  0
                                              ? AppColors.success.withValues(
                                                alpha: 0.1,
                                              )
                                              : AppColors.error.withValues(
                                                alpha: 0.1,
                                              ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: AppText(
                                      "${controller.bankSummary!.data!.deltavalue >= 0 ? '+' : ''}"
                                      "${controller.bankSummary!.data!.deltavalue} "
                                      "(${controller.bankSummary!.data!.deltapercentage}%)",
                                      variant: AppTextVariant.bodySmall,
                                      weight: AppTextWeight.semiBold,
                                      colorType:
                                          controller
                                                      .bankSummary!
                                                      .data!
                                                      .deltavalue >=
                                                  0
                                              ? AppTextColorType.success
                                              : AppTextColorType.error,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkCardBG,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.darkButtonBorder),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        spacing: 16.w,
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
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                TextSpan(
                                  text: "Transactions ",
                                  style: TextStyle(
                                    color: AppColors.info,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                TextSpan(
                                  text: "timeline!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat',
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
                        child: Icon(
                          Icons.arrow_forward,
                          size: 16.sp,
                          color: AppColors.darkTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              AppInputField(
                controller: _searchController,
                prefix: Icon(
                  CupertinoIcons.search,
                  color: AppColors.darkTextMuted,
                ),
                hintText: "Search...",
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    spacing: 15,
                    children: [
                      GetBuilder<BankController>(
                        builder: (controller) {
                          if (controller.bankSummary?.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return Column(
                            spacing: 12,
                            children:
                                controller.bankSummary!.data!.banks.map((bank) {
                                  final Widget bankCard = BankCard(
                                    bankGUID: bank.guid,
                                    icon: Icons.account_balance,
                                    bankName: bank.finame,
                                    accountNumber: bank.maskedaccnumber,
                                    balance: CurrencyFormatter.formatRupee(
                                      bank.currentbalance,
                                    ),
                                    deltaValue: "${bank.deltapercentage}%",
                                    isPositiveDelta: bank.deltavalue >= 0,
                                  );

                                  if (bank.isprimary) {
                                    return bankCard;
                                  }

                                  return bankCard;
                                }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizing.scaffoldHorizontalPadding,
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Row(
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
      ),
    );
  }
}
