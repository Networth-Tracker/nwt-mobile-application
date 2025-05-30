import 'dart:convert';

import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/screens/dashboard/types/mf_top_performers.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/utils/network_api_helper.dart';

class MFTopPerformerService {
  Future<MutualFundTopPerformersRespose?> getTopPerformers({
    required Function(bool isLoading) onLoading,
    String? params,
  }) async {
    onLoading(true);
    try {
      // Construct the URL with dynamic parameters if provided
      String url = ApiURLs.GET_MF_TOP_PERFORMERS;
      if (params != null && params.isNotEmpty) {
        url = "$url?$params";
      }

      final response = await NetworkAPIHelper().get(url);
      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info(
          'Get MF Top Performers Response: ${responseData.toString()}',
          tag: 'MFTopPerformerService',
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          return MutualFundTopPerformersRespose.fromJson(responseData);
        } else {
          return MutualFundTopPerformersRespose(
            status: response.statusCode,
            message: responseData['message'] ?? 'Unknown error',
            data: null,
          );
        }
      }
      return MutualFundTopPerformersRespose(
        status: response?.statusCode ?? 0,
        message: 'Unknown error',
        data: null,
      );
    } catch (e) {
      AppLogger.error(
        'Get MF Top Performers Error',
        error: e,
        tag: 'MFTopPerformerService',
      );
      return MutualFundTopPerformersRespose(
        status: 0,
        message: e.toString(),
        data: null,
      );
    } finally {
      onLoading(false);
    }
  }
}
