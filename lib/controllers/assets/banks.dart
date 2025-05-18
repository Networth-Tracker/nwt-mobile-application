import 'package:get/get.dart';
import 'package:nwt_app/screens/assets/banks/types/banks.dart';
import 'package:nwt_app/services/assets/banks/banks.dart';

class BankController extends GetxController {
  BankSummaryResponse? bankSummary;
  BankService bankService = BankService();

  void getBankSummary({
    required Function(bool isLoading) onLoading,
  }) {
    onLoading(true);
    bankService.getBankSummary(onLoading: (isLoading) {
      onLoading(isLoading);
    }).then((value) {
      if (value != null) {
        print('Bank Summary Response: ${value.toJson()}');
        if (value.data != null) {
          print('Bank Summary Data: ${value.data!.toJson()}');
        }
      }
      bankSummary = value;
      update();
    });
  }
}