import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/screens/dashboard/dashboard.dart';
import 'package:nwt_app/widgets/common/app_input_field.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/utils/validators.dart';

class PanCardVerification extends StatefulWidget {
  const PanCardVerification({super.key});

  @override
  State<PanCardVerification> createState() => _PanCardVerificationState();
}

class _PanCardVerificationState extends State<PanCardVerification> {
  final TextEditingController _panController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  TextInputType _currentKeyboardType = TextInputType.text;

  @override
  void initState() {
    super.initState();
    _panController.addListener(() {
      final text = _panController.text;
      final newType =
          (text.length >= 5 && text.length < 9)
              ? TextInputType.number
              : TextInputType.text;

      if (_currentKeyboardType != newType) {
        setState(() {
          _currentKeyboardType = newType;
        });

        _focusNode.unfocus();
        Future.delayed(const Duration(milliseconds: 50), () {
          _focusNode.requestFocus();
        });
      }
    });
  }

  @override
  void dispose() {
    _panController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
              "PAN Verification",
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
              Expanded(
                child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                  child: Column(
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
                      AppInputField(
                        controller: _panController,
                        focusNode: _focusNode,
                        hintText: "Enter your PAN number",

                        keyboardType: _currentKeyboardType,
                        textCapitalization: TextCapitalization.characters,
                        validator: AppValidators.validatePanCard,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.deny(
                            RegExp(r'[^A-Z0-9]'),
                          ),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            if (newValue.text.isEmpty) return newValue;
                            if (newValue.text.length > 10) return oldValue;


                            if (newValue.text.length < oldValue.text.length) {
                              return newValue;
                            }

                            final text = newValue.text;
                            final position = text.length;


                            if (position <= 5) {

                              if (!RegExp(r'^[A-Z]{1,5}$').hasMatch(text)) {
                                return oldValue;
                              }
                            } else if (position <= 9) {

                              if (!RegExp(
                                r'^[A-Z]{5}[0-9]{1,4}$',
                              ).hasMatch(text)) {
                                return oldValue;
                              }
                            } else {

                              if (!RegExp(
                                r'^[A-Z]{5}[0-9]{4}[A-Z]$',
                              ).hasMatch(text)) {
                                return oldValue;
                              }
                            }
                            return newValue;
                          }),
                        ],
                        size: AppInputFieldSize.large,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Verify',
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                      onPressed:
                          () => Get.to(const Dashboard(), transition: Transition.rightToLeft),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
