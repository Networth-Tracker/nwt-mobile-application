import 'package:get/get.dart';
import 'package:nwt_app/screens/assets/investments/types/holdings.dart';
import 'package:nwt_app/screens/assets/investments/types/portfolio.dart';
import 'package:nwt_app/services/assets/investments/investments.dart';

class InvestmentController extends GetxController {
  InvestmentPortfolio? portfolio;
  HoldingsData? holdings;
  InvestmentService investmentService = InvestmentService();

  Future<void> getPortfolio({
    required Function(bool isLoading) onLoading,
  }) async {
    try {
      final value = await investmentService.getPortfolio(
        onLoading: onLoading,
      );
      portfolio = value?.data;
      update();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getHoldings({
    required Function(bool isLoading) onLoading,
  }) async {
    try {
      final value = await investmentService.getHoldings(
        onLoading: onLoading,
      );
      holdings = value?.data;
      update();
    } catch (e) {
      rethrow;
    }
  }
}
