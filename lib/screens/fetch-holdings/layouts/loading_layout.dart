import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class LoadingLayout extends StatelessWidget {
  final VoidCallback onPrevious;
  
  const LoadingLayout({
    super.key,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 800),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20), // Top spacer
          Column(
            children: [
              // Animated loading indicator
              Pulse(
                infinite: true,
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 500),
                child: AppText(
                  "Fetching your\nMutual Fund Holdings",
                  variant: AppTextVariant.headline4,
                  weight: AppTextWeight.bold,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 500),
                child: AppText(
                  "This may take a few moments",
                  variant: AppTextVariant.bodyLarge,
                  colorType: AppTextColorType.muted,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          // Navigation button
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            child: FadeInUp(
              delay: const Duration(milliseconds: 1000),
              duration: const Duration(milliseconds: 500),
              child: TextButton.icon(
                onPressed: onPrevious,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
