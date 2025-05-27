import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class MfFetchingErrorLayout extends StatelessWidget {
  final bool isAnimating;
  final String? errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onSkip;

  const MfFetchingErrorLayout({
    super.key,
    required this.isAnimating,
    required this.errorMessage,
    required this.onRetry,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return isAnimating
        ? FadeOutUp(
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 400),
          child: _buildContent(context),
        )
        : FadeInUp(
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 400),
          child: _buildContent(context),
        );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizing.scaffoldHorizontalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Lottie.asset("assets/lottie/failure.json")],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Unable to Connect",
                    variant: AppTextVariant.headline3,
                    weight: AppTextWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AppText(
                  "We're having trouble connecting to our servers. Please check your internet connection and try again.",
                  variant: AppTextVariant.bodyLarge,
                  weight: AppTextWeight.regular,
                  textAlign: TextAlign.center,
                  colorType: AppTextColorType.muted,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            child: FadeInUp(
              delay: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Retry',
                          variant: AppButtonVariant.primary,
                          size: AppButtonSize.large,
                          onPressed: onRetry,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          text: 'Skip',
                          variant: AppButtonVariant.secondary,
                          size: AppButtonSize.large,
                          onPressed: onSkip,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
