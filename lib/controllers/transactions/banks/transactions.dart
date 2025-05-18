import 'package:get/get.dart';
import 'package:nwt_app/screens/transactions/banks/types/transaction.dart';
import 'package:nwt_app/services/assets/banks/transactions/bank_transactions.dart';

class BankTransactionController extends GetxController {
  TransactionData? transactionData;
  BankTransactionService bankTransactionService = BankTransactionService();

  void getBankTransactions({
    required String bankGUID,
    required Function(bool isLoading) onLoading,
  }) {
    bankTransactionService.getBankTransactions(
      bankGUID: bankGUID,
      onLoading: (isLoading) {
        onLoading(isLoading);
      },
    ).then((value) {
      transactionData = value?.data;
      update();
    });
  }
}
