import 'package:get/get.dart';
import 'package:nwt_app/screens/assets/investments/types/portfolio.dart';

class InvestmentController extends GetxController {
  InvestmentPortfolio? portfolio;

  void updatePortfolio(InvestmentPortfolio portfolio) {
    this.portfolio = portfolio;
    update();
  }
}
