import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/fetch-holdings/types/mf_fetching.dart';
import 'package:nwt_app/services/mf_onboarding/mf_onboarding_service.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class StartingJourneyLayout extends StatefulWidget {
  final bool isAnimating;
  final VoidCallback onNext;
  final Function(DecryptedCASDetails?, String)? onCasDetailsReceived;

  const StartingJourneyLayout({
    super.key,
    required this.isAnimating,
    required this.onNext,
    this.onCasDetailsReceived,
  });

  @override
  State<StartingJourneyLayout> createState() => _StartingJourneyLayoutState();
}

class _StartingJourneyLayoutState extends State<StartingJourneyLayout> {
  bool _isLoading = false;
  DecryptedCASDetails? _casDetails;
  final MFOnboardingService _mfOnboardingService = MFOnboardingService();

  @override
  void initState() {
    super.initState();
    // Call sendOTP when the layout is loaded
    _sendOTP();
  }

  Future<void> _sendOTP() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _mfOnboardingService.sendOTP(
      onLoading: (isLoading) {
        setState(() {
          _isLoading = isLoading;
        });
      },
      onError: (message) {
        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      },
    );

    setState(() {
      _casDetails = result?.data.decryptedcasdetails;
    });

    // Automatically proceed to next step when CAS details are received
    if (_casDetails != null) {
      // Pass the CAS details to the parent if callback exists
      if (widget.onCasDetailsReceived != null) {
        widget.onCasDetailsReceived!(_casDetails, result?.data.token ?? '');
      }

      // Move to the next step
      Future.delayed(const Duration(milliseconds: 5000), () {
        widget.onNext();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isAnimating
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
          const SizedBox(height: 20), // Spacer at top
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svgs/mf_switch/starting_journey.svg",
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Starting your\nMutual Fund Journey!",
                    variant: AppTextVariant.headline3,
                    weight: AppTextWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          // Loading indicator at bottom
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            child: FadeInUp(
              delay: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 500),
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
