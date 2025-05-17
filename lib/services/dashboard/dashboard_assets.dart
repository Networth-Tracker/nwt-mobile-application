import 'dart:convert';
import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/screens/dashboard/types/dashboard_assets.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/utils/network_api_helper.dart';

class DashboardAssetsService {
  Future<DashboardAssetsResponse?> getDashboardAssets({
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await NetworkAPIHelper().get(ApiURLs.USER_DASHBOARD_ASSETS);
      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info('Get Dashboard Assets Response: ${responseData.toString()}', tag: 'DashboardAssetsService');

        if (response.statusCode == 200 || response.statusCode == 201) {
          return DashboardAssetsResponse.fromJson(responseData);
        }
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Get Dashboard Assets Error', error: e, stackTrace: stackTrace, tag: 'DashboardAssetsService');
      return null;
    } finally {
      onLoading(false);
    }
  }
}