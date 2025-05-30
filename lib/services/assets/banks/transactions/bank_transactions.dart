import 'dart:convert';

import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/screens/transactions/banks/types/transaction.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/utils/network_api_helper.dart';

class BankTransactionService {
  Future<BankTransactionResponse> getBankTransactions({
    required String bankGUID,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await NetworkAPIHelper().get(
        "${ApiURLs.GET_BANK_TRANSACTION}/$bankGUID",
      );
      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info(
          'Get Bank Transactions Response: ${responseData.toString()}',
          tag: 'BankTransactionService',
        );
        final parsedResponse = BankTransactionResponse.fromJson(responseData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          return parsedResponse;
        } else {
          return BankTransactionResponse(
            status: response.statusCode,
            message: responseData['message'] ?? 'Unknown error',
            data: null,
          );
        }
      }
      return BankTransactionResponse(
        status: 0,
        message: 'Unknown error',
        data: null,
      );
    } catch (e) {
      AppLogger.error(
        'Get Bank Transactions Error',
        error: e,
        tag: 'BankTransactionService',
      );
      return BankTransactionResponse(
        status: 0,
        message: 'An unexpected error occurred',
        data: null,
      );
    } finally {
      onLoading(false);
    }
  }
}
