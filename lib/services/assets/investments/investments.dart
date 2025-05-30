import 'dart:convert';

import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/screens/assets/investments/types/holdings.dart';
import 'package:nwt_app/screens/assets/investments/types/portfolio.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/utils/network_api_helper.dart';

class InvestmentService {
  Future<InvestmentPortfolioResponse?> getPortfolio({
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await NetworkAPIHelper().get(
        ApiURLs.GET_USER_INVESTMENTS,
      );
      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info(
          'Get Portfolio Response: ${responseData.toString()}',
          tag: 'AuthService',
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          return InvestmentPortfolioResponse.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      AppLogger.error('Get Portfolio Error', error: e, tag: 'AuthService');
      return null;
    } finally {
      onLoading(false);
    }
  }

  Future<InvestmentHoldingsResponse> getHoldings({
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await NetworkAPIHelper().get(ApiURLs.GET_USER_HOLDINGS);
      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info(
          'Get Holdings Response: ${responseData.toString()}',
          tag: 'AuthService',
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          return InvestmentHoldingsResponse.fromJson(responseData);
        } else {
          return InvestmentHoldingsResponse(
            status: response.statusCode,
            message: responseData['message'] ?? 'Unknown error',
            data: null,
          );
        }
      }
      return InvestmentHoldingsResponse(
        status: 0,
        message: 'Unknown error',
        data: null,
      );
    } catch (e) {
      AppLogger.error('Get Holdings Error', error: e, tag: 'AuthService');
      return InvestmentHoldingsResponse(
        status: 0,
        message: 'An unexpected error occurred',
        data: null,
      );
    } finally {
      onLoading(false);
    }
  }
}
