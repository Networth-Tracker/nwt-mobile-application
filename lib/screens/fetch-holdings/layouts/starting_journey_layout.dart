import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/fetch-holdings/layouts/error_layout.dart';
import 'package:nwt_app/screens/fetch-holdings/types/mf_fetching.dart';
import 'package:nwt_app/services/mf_onboarding/mf_onboarding_service.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class StartingJourneyLayout extends StatefulWidget {
  final bool isAnimating;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final Function(DecryptedCASDetails?, String)? onCasDetailsReceived;

  const StartingJourneyLayout({
    super.key,
    required this.isAnimating,
    required this.onNext,
    this.onSkip,
    this.onCasDetailsReceived,
  });

  @override
  State<StartingJourneyLayout> createState() => _StartingJourneyLayoutState();
}

class _StartingJourneyLayoutState extends State<StartingJourneyLayout>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  String? _errorMessage;
  bool _showRetryOptions = false;
  bool _showStartingScreen = true;
  DecryptedCASDetails? _casDetails;
  final MFOnboardingService _mfOnboardingService = MFOnboardingService();

  late List<AnimationController> _dotControllers;
  static const int _minStartingScreenTime = 5000;

  @override
  void initState() {
    super.initState();
    _dotControllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
    for (int i = 0; i < _dotControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted && _dotControllers[i].isAnimating == false) {
          _dotControllers[i].repeat(reverse: true);
        }
      });
    }

    _sendOTP();
    Future.delayed(Duration(milliseconds: _minStartingScreenTime), () {
      if (mounted) {
        setState(() {
          _showStartingScreen = false;
        });
      }
    });
  }

  Future<void> _sendOTP() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _showRetryOptions = false;
      });
    }

    final result = await _mfOnboardingService.sendOTP(
      onLoading: (isLoading) {
        if (mounted) {
          setState(() {
            _isLoading = isLoading;
          });
        }
      },
      onError: (message) {
        if (mounted) {
          setState(() {
            _errorMessage = message;
            _showRetryOptions = true;
            _isLoading = false;
          });
        }
      },
    );

    if (mounted) {
      setState(() {
        _casDetails = result.data?.decryptedcasdetails;
      });
    }

    if (_casDetails != null) {
      if (widget.onCasDetailsReceived != null && mounted) {
        widget.onCasDetailsReceived!(_casDetails, result.data?.token ?? '');
      }

      if (!_showStartingScreen) {
        widget.onNext();
      } else {
        // If we're still in the minimum time window, wait until it completes
        // before moving to the next step
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _dotControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showStartingScreen) {
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

    if (_showRetryOptions && _errorMessage != null) {
      return MfFetchingErrorLayout(
        isAnimating: widget.isAnimating,
        errorMessage: _errorMessage,
        onRetry: _sendOTP,
        onSkip: widget.onSkip ?? widget.onNext,
      );
    }

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

  Widget _buildBottomContent() {
    if (_isLoading) {
      return const CircularProgressIndicator();
    } else {
      return const SizedBox.shrink();
    }
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
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            child: FadeInUp(
              delay: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  AppText(
                    "Processing your request",
                    variant: AppTextVariant.bodyLarge,
                    weight: AppTextWeight.medium,
                    colorType: AppTextColorType.primary,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 30,
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 3; i++)
                          _buildAnimatedDot(context, i),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildBottomContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDot(BuildContext context, int index) {
    return AnimatedBuilder(
      animation: _dotControllers[index],
      builder: (context, child) {
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(
              alpha: 0.6 + (_dotControllers[index].value * 0.4),
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(
                  alpha: 0.3 * _dotControllers[index].value,
                ),
                blurRadius: 8 * _dotControllers[index].value,
                spreadRadius: 2 * _dotControllers[index].value,
              ),
            ],
          ),
        );
      },
    );
  }
}
