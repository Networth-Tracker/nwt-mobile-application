import 'dart:convert';
import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/screens/dashboard/types/dashboard_networth.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/utils/network_api_helper.dart';

class TotalNetworthService {

  Future<DashboardNetworth?> getTotalNetworth({
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await NetworkAPIHelper().get(
        ApiURLs.GET_TOTAL_NETWORTH,
      );
      
      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info(
          'Get Total Networth Response: ${responseData.toString()}',
          tag: 'TotalNetworthService',
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          return DashboardNetworth.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      AppLogger.error('Get Total Networth Error', error: e, tag: 'TotalNetworthService');
      return null;
    } finally {
      onLoading(false);
    }
  }
}