import 'package:baseball_ai/core/models/insights_model.dart';
import 'package:baseball_ai/core/services/api_service.dart';
import 'package:get/get.dart';

import '../../../../../auth/controller/auth_controller.dart';

class PerformanceController extends GetxController {
  Rx<InsightsResponse> insights = InsightsResponse(success: false, message: 'No data available', data: null).obs;
    


  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial performance data
    // loadPerformanceData();
  }

  // Simulate loading performance data
  void loadPerformanceData(bool isWeeklyView) async {
    isLoading.value = true;
    final authController = Get.find<AuthController>();
    final token = authController.accessToken.value;
    final userId = authController.currentUser.value?.id ?? '';
    try {
      final response = await ApiService.getInsightsData(token: token, userId: userId, startDate: DateTime.now().subtract(Duration(days: 50)).toIso8601String(), endDate: DateTime.now().toIso8601String());
      print(response.message.toString());
      if (response.success) {
        insights.value = InsightsResponse(
          success: true,
          message: 'Performance data loaded successfully',
          data: response.data,
        );
      } else {
        insights.value = InsightsResponse(
          success: false,
          message: response.message ?? 'Failed to load performance data',
          data: null,
        );
      }
    } catch (e) {
      insights.value = InsightsResponse(
        success: false,
        message: 'Failed to load performance data',
        data: null,
      );
    }

    isLoading.value = false;
  }
}