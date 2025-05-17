import 'package:get/get.dart';
import 'package:nwt_app/screens/assets/investments/types/portfolio.dart';
import 'package:nwt_app/services/assets/investments/investments.dart';

class InvestmentController extends GetxController {
  InvestmentPortfolio? portfolio;
  InvestmentService investmentService = InvestmentService();

  void getPortfolio({
    required Function(bool isLoading) onLoading,
  }) {
    investmentService.getPortfolio(onLoading: (isLoading) {
      onLoading(isLoading);
    }).then((value) {
      portfolio = value?.data;
      update();
    });
  }
}
