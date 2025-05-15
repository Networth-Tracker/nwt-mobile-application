import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/services/network/connectivity_service.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

/// A widget that shows different content based on network connectivity status
class NetworkSensitive extends StatelessWidget {
  /// Widget to display when online
  final Widget child;
  
  /// Widget to display when offline (optional)
  final Widget? offlineChild;
  
  /// Whether to show a default offline message when offlineChild is not provided
  final bool showDefaultOfflineMessage;

  const NetworkSensitive({
    Key? key,
    required this.child,
    this.offlineChild,
    this.showDefaultOfflineMessage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final connectivityService = ConnectivityService.to;
      final isConnected = connectivityService.isConnected;

      if (isConnected) {
        return child;
      } else {
        return offlineChild ?? _buildDefaultOfflineWidget();
      }
    });
  }

  /// Builds the default offline message widget
  Widget _buildDefaultOfflineWidget() {
    if (!showDefaultOfflineMessage) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const AppText(
            "No Internet Connection",
            variant: AppTextVariant.headline4,
            weight: AppTextWeight.semiBold,
          ),
          const SizedBox(height: 8),
          const AppText(
            "Please check your network settings and try again",
            variant: AppTextVariant.bodyMedium,
            weight: AppTextWeight.regular,
            colorType: AppTextColorType.secondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await ConnectivityService.to.checkConnectivity();
            },
            icon: const Icon(Icons.refresh),
            label: const AppText(
              "Retry",
              variant: AppTextVariant.bodyMedium,
              weight: AppTextWeight.medium,
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget that shows a banner at the top of the screen when offline
class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final connectivityService = ConnectivityService.to;
      final isConnected = connectivityService.isConnected;

      if (isConnected) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        color: Colors.red.shade700,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: AppText(
                "No internet connection",
                variant: AppTextVariant.bodySmall,
                weight: AppTextWeight.medium,
                colorType: AppTextColorType.primary,
              ),
            ),
            TextButton(
              onPressed: () async {
                await ConnectivityService.to.checkConnectivity();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const AppText(
                "Retry",
                variant: AppTextVariant.bodySmall,
                weight: AppTextWeight.semiBold,
                colorType: AppTextColorType.primary,
              ),
            ),
          ],
        ),
      );
    });
  }
}
