import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/common/button_widget.dart';
import 'package:nwt_app/common/input_decorator.dart';
import 'package:nwt_app/common/text_widget.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/screens/auth/user_pofile.dart';
import 'package:nwt_app/utils/validators.dart';

class PanCardVerification extends StatefulWidget {
  const PanCardVerification({super.key});

  @override
  State<PanCardVerification> createState() => _PanCardVerificationState();
}

class _PanCardVerificationState extends State<PanCardVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.chevron_left),
            ),
            AppText("PAN Verification", variant: AppTextVariant.headline6, weight: AppTextWeight.semiBold),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Lottie.asset('assets/lottie/lock.json'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      AppText(
                        "Enter your PAN number to verify",
                        variant: AppTextVariant.bodyLarge,
                        lineHeight: 1.3,
                        colorType: AppTextColorType.secondary,
                        weight: AppTextWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: AppValidators.validatePanCard,
                    // controller: _phoneController,
                    keyboardType: TextInputType.none,
                    style: TextStyle(
                      color: context.textThemeColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    forceErrorText: "Invalid Number",
                    decoration: primaryInputDecoration(
                      "Enter your PAN number",
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Verify',
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                      onPressed:
                          () => Get.to(() => const UserProfileScreen()),
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
