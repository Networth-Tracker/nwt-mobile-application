import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/screens/dashboard/dashboard.dart';
import 'package:nwt_app/services/assets/investments/investments.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class LoadingLayout extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback? onComplete;
  final String? token;

  const LoadingLayout({
    super.key,
    required this.onPrevious,
    this.onComplete,
    this.token,
  });

  @override
  State<LoadingLayout> createState() => _LoadingLayoutState();
}

class _LoadingLayoutState extends State<LoadingLayout> {
  int _currentMessageIndex = 0;
  late Timer _messageTimer;
  Timer? _redirectTimer;
  bool _isRedirecting = false;
  bool _dataReceived = false;
  final InvestmentService _investmentService = InvestmentService();

  final List<String> _loadingMessages = [
    "Fetching your\nMutual Fund details",
    "Analyzing your\nMutual Fund portfolio",
    "Building your financial\npersona & advisory",
  ];

  @override
  void initState() {
    super.initState();

    // Start timer to cycle through messages every 2 seconds
    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          if (_currentMessageIndex < _loadingMessages.length - 1) {
            _currentMessageIndex++;
          } else {
            // Stop the timer when we reach the last message
            timer.cancel();
          }
        });
      }
    });

    // Start fetching data immediately
    _fetchHoldingsData();

    // Set up a 7-second timer as a fallback
    _redirectTimer = Timer(const Duration(seconds: 7), () {
      if (mounted && !_isRedirecting && !_dataReceived) {
        // If data hasn't been received after 7 seconds,
        // we'll continue waiting for the data to complete
        AppLogger.info(
          '7 seconds passed, waiting for data to complete...',
          tag: 'LoadingLayout',
        );
      }
    });
  }

  // Fetch holdings data
  Future<void> _fetchHoldingsData() async {
    try {
      await _investmentService.getHoldings(
        onLoading: (isLoading) {
          if (mounted) {
            // Update loading state in UI if needed
            AppLogger.info(
              'Holdings data loading state: $isLoading',
              tag: 'LoadingLayout',
            );
          }
        },
      );

      // Data has been received successfully
      if (mounted) {
        setState(() {
          _dataReceived = true;
        });

        // Navigate to dashboard immediately since data is received
        _redirectToDestination();
      }
    } catch (e) {
      AppLogger.error(
        'Exception while fetching holdings data: $e',
        tag: 'LoadingLayout',
      );
      // If there's an exception, we should still redirect after some time
      _redirectAfterDelay();
    }
  }

  // Redirect after a short delay (used for error cases)
  void _redirectAfterDelay() {
    if (mounted && !_isRedirecting) {
      Future.delayed(const Duration(seconds: 2), () {
        _redirectToDestination();
      });
    }
  }

  // Navigate to dashboard screen
  void _redirectToDestination() {
    if (mounted && !_isRedirecting) {
      setState(() {
        _isRedirecting = true;
      });

      // Call the onComplete callback to navigate to dashboard
      if (widget.onComplete != null) {
        widget.onComplete!();
      } else {
        // Default navigation to dashboard if no callback provided
        Get.offAll(() => const Dashboard());
      }
    }
  }

  @override
  void dispose() {
    _messageTimer.cancel();
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 800),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20), // Top spacer
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animated loading indicator
              SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  'assets/lottie/pan.json',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 500),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.5),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: AppText(
                        key: ValueKey<int>(_currentMessageIndex),
                        _loadingMessages[_currentMessageIndex],
                        variant: AppTextVariant.headline4,
                        weight: AppTextWeight.bold,
                        textAlign: TextAlign.center,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 500),
                    child: AppText(
                      "This may take a few moments",
                      variant: AppTextVariant.bodyLarge,
                      colorType: AppTextColorType.muted,
                      textAlign: TextAlign.center,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
