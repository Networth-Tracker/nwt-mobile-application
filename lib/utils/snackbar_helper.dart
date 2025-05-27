import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class SnackbarHelper {
  static void showSuccess({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeInCirc,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      shouldIconPulse: true,
      titleText: AppText(
        title,
        variant: AppTextVariant.headline6,
        weight: AppTextWeight.semiBold,
        colorType: AppTextColorType.primary,
        customColor: Colors.white,
      ),
      messageText: AppText(
        message,
        variant: AppTextVariant.bodyMedium,
        weight: AppTextWeight.regular,
        colorType: AppTextColorType.primary,
        customColor: Colors.white.withValues(alpha: 0.9),
      ),
      snackStyle: SnackStyle.FLOATING,
      overlayBlur: 0,
      overlayColor: Colors.black.withValues(alpha: 0.1),
      borderColor: const Color(0xFF4CAF50),
      borderWidth: 1,
    );
  }

  static void showError({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: const Color(0xFFC62828),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeInCirc,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      icon: const Icon(Icons.error_outline, color: Colors.white),
      shouldIconPulse: true,
      titleText: AppText(
        title,
        variant: AppTextVariant.headline6,
        weight: AppTextWeight.semiBold,
        colorType: AppTextColorType.primary,
        customColor: Colors.white,
      ),
      messageText: AppText(
        message,
        variant: AppTextVariant.bodyMedium,
        weight: AppTextWeight.regular,
        colorType: AppTextColorType.primary,
        customColor: Colors.white.withValues(alpha: 0.9),
      ),
      snackStyle: SnackStyle.FLOATING,
      overlayBlur: 0,
      overlayColor: Colors.black.withValues(alpha: 0.1),
      borderColor: const Color(0xFFE57373),
      borderWidth: 1,
    );
  }

  static void showInfo({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: AppColors.lightPrimary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeInCirc,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      icon: const Icon(Icons.info_outline, color: Colors.white),
      shouldIconPulse: true,
      titleText: AppText(
        title,
        variant: AppTextVariant.headline6,
        weight: AppTextWeight.semiBold,
        colorType: AppTextColorType.primary,
        customColor: Colors.white,
      ),
      messageText: AppText(
        message,
        variant: AppTextVariant.bodyMedium,
        weight: AppTextWeight.regular,
        colorType: AppTextColorType.primary,
        customColor: Colors.white.withValues(alpha: 0.9),
      ),
      snackStyle: SnackStyle.FLOATING,
      overlayBlur: 0,
      overlayColor: Colors.black.withValues(alpha: 0.1),
      borderColor: AppColors.lightButtonBorder,
      borderWidth: 1,
    );
  }

  static void showWarning({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: const Color(0xFFEF6C00),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeInCirc,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      icon: const Icon(Icons.warning_amber_outlined, color: Colors.white),
      shouldIconPulse: true,
      titleText: AppText(
        title,
        variant: AppTextVariant.headline6,
        weight: AppTextWeight.semiBold,
        colorType: AppTextColorType.primary,
        customColor: Colors.white,
      ),
      messageText: AppText(
        message,
        variant: AppTextVariant.bodyMedium,
        weight: AppTextWeight.regular,
        colorType: AppTextColorType.primary,
        customColor: Colors.white.withValues(alpha: 0.9),
      ),
      snackStyle: SnackStyle.FLOATING,
      overlayBlur: 0,
      overlayColor: Colors.black.withValues(alpha: 0.1),
      borderColor: const Color(0xFFFFB74D),
      borderWidth: 1,
    );
  }
}
