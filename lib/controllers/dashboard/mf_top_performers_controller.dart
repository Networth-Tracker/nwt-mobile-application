import 'package:get/get.dart';
import 'package:nwt_app/screens/dashboard/types/mf_top_performers.dart';
import 'package:nwt_app/services/dashboard/mf_top_performer.dart';

class MFTopPerformersController extends GetxController {
  final _mfTopPerformerService = MFTopPerformerService();
  
  final isLoading = false.obs;
  final topPerformers = Rx<List<MFPerformers>?>([]);
  
  @override
  void onInit() {
    super.onInit();
    fetchTopPerformers();
  }
  
  Future<void> fetchTopPerformers() async {
    final response = await _mfTopPerformerService.getTopPerformers(
      onLoading: (loading) => isLoading.value = loading,
      params: "limit=10", // Fetch top 10 performers
    );
    
    if (response != null && response.data != null) {
      topPerformers.value = response.data;
    }
  }
}
