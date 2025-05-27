import 'dart:convert';

import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/screens/assets/banks/types/banks.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/utils/network_api_helper.dart';

class BankService {
  Future<BankSummaryResponse?> getBankSummary({
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await NetworkAPIHelper().get(ApiURLs.GET_BANK_SUMMARY);
      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info(
          'Get Bank Summary Response: ${responseData.toString()}',
          tag: 'BankService',
        );
        return BankSummaryResponse.fromJson(responseData);
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Get Bank Summary Error',
        error: e,
        stackTrace: stackTrace,
        tag: 'BankService',
      );
      return BankSummaryResponse(
        status: 0,
        message: 'An unexpected error occurred',
        data: null,
      );
    } finally {
      onLoading(false);
    }
  }
}
