import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/controllers/dashboard/mf_top_performers_controller.dart';
import 'package:nwt_app/screens/insights/insights.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class MFTopPerformersWidget extends StatelessWidget {
  final MFTopPerformersController controller;

  const MFTopPerformersWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizing.scaffoldHorizontalPadding,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'MF Top 10 Performers',
            variant: AppTextVariant.headline5,
            weight: AppTextWeight.bold,
            colorType: AppTextColorType.primary,
            decoration: TextDecoration.none,
          ),
          const SizedBox(height: 20),
          Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState();
            } else if (controller.topPerformers.value == null ||
                controller.topPerformers.value!.isEmpty) {
              return _buildEmptyState();
            } else {
              return _buildTopPerformersList();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(children: List.generate(5, (index) => _buildShimmerItem()));
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.grey[800]),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: const AppText(
        'No top performers available',
        variant: AppTextVariant.bodyMedium,
        weight: AppTextWeight.medium,
        colorType: AppTextColorType.secondary,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _buildTopPerformersList() {
    return Column(
      children: List.generate(controller.topPerformers.value!.length, (index) {
        final performer = controller.topPerformers.value![index];
        return InkWell(
          onTap: () => Get.to(
            () => InsightsScreen(fundId: performer.guid),
            transition: Transition.rightToLeft,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  child: const Icon(
                    Icons.corporate_fare,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    performer.fundname,
                    variant: AppTextVariant.bodyMedium,
                    weight: AppTextWeight.medium,
                    colorType: AppTextColorType.primary,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
