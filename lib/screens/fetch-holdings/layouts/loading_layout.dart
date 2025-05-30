import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  Timer? _timeoutTimer;
  bool _isRedirecting = false;
  final bool _dataReceived = false;
  bool _showTimeout = false;

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

    // Set up a 7-second timer as a fallback
    _redirectTimer = Timer(const Duration(seconds: 7), () {
      if (mounted && !_isRedirecting && !_dataReceived) {
        AppLogger.info(
          '7 seconds passed, waiting for data to complete...',
          tag: 'LoadingLayout',
        );
      }
    });

    // Set up a 10-second timeout timer to show retry option
    _timeoutTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && !_isRedirecting && !_dataReceived) {
        setState(() {
          _showTimeout = true;
        });
        AppLogger.info(
          '10 seconds passed, showing timeout message',
          tag: 'LoadingLayout',
        );
      }
    });
  }

  @override
  void dispose() {
    _messageTimer.cancel();
    _redirectTimer?.cancel();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  // Method to restart the flow when retry is pressed
  void _retryFlow() {
    // Reset state
    setState(() {
      _showTimeout = false;
      _currentMessageIndex = 0;
      _isRedirecting = false;
    });

    // Cancel existing timers
    _messageTimer.cancel();
    _redirectTimer?.cancel();
    _timeoutTimer?.cancel();

    // Restart message timer
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

    // Restart timeout timer
    _timeoutTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && !_isRedirecting && !_dataReceived) {
        setState(() {
          _showTimeout = true;
        });
      }
    });

    // Call onPrevious to restart the flow
    widget.onPrevious();
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
