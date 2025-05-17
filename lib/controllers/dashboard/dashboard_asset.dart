import 'package:get/get.dart';
import 'package:nwt_app/screens/dashboard/types/dashboard_assets.dart';
import 'package:nwt_app/services/dashboard/dashboard_assets.dart';

class DashboardAssetController extends GetxController {
  DashboardAssetsResponse? dashboardAssets;
  DashboardAssetsService dashboardAssetsService = DashboardAssetsService();

  void getDashboardAssets({
    required Function(bool isLoading) onLoading,
  }) {
    dashboardAssetsService.getDashboardAssets(onLoading: (isLoading) {
      onLoading(isLoading);
    }).then((value) {
      dashboardAssets = value;
      update();
    });
  }
}
