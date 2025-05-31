import 'package:baseball_ai/core/utils/theme/app_styles.dart'; // Assuming this path is correct
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/performance/controller/performance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // Assuming GetX is used for navigation
import 'package:radial_chart_package/widgets/radial_performance_chart.dart';
import 'package:radial_chart_package/widgets/segment_data.dart';

class PerformanceScreen extends StatelessWidget {
  final bool isWeeklyView;
  const PerformanceScreen({super.key, required this.isWeeklyView});

  @override
  Widget build(BuildContext context) {
    final performanceController = Get.put(PerformanceController());
    performanceController.loadPerformanceData(isWeeklyView);
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppStyles.cardColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
        title: Text(
          'Performance - ${isWeeklyView ? "Weekly" : "Monthly"}',
          style: AppStyles.bodyMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Center(
                  child: Obx(() {
                    return RadialPerformanceChart(
                      radius: 150,
                      segments: [
                        SegmentData(
                          percentage:
                              performanceController
                                  .insights
                                  .value
                                  .data
                                  ?.powerRatings
                                  .visualization
                                  .toDouble() ??
                              0.0,
                          color: Colors.lightGreen,
                          label: "Visualization",
                        ),
                        SegmentData(
                          percentage:
                              performanceController
                                  .insights
                                  .value
                                  .data
                                  ?.powerRatings
                                  .consistency
                                  .toDouble() ??
                              0.0,
                          color: Colors.deepPurple,
                          label: "Consistency",
                        ),
                        SegmentData(
                          percentage:
                              performanceController
                                  .insights
                                  .value
                                  .data
                                  ?.powerRatings
                                  .lifting
                                  .toDouble() ??
                              0.0,
                          color: Colors.red,
                          label: "Lifting",
                        ),
                        SegmentData(
                          percentage:
                              performanceController
                                  .insights
                                  .value
                                  .data
                                  ?.powerRatings
                                  .recovery
                                  .toDouble() ??
                              0.0,
                          color: Colors.blue,
                          label: "Recovery",
                        ),
                        SegmentData(
                          percentage:
                              performanceController
                                  .insights
                                  .value
                                  .data
                                  ?.powerRatings
                                  .wellness
                                  .toDouble() ??
                              0.0,
                          color: Colors.amber,
                          label: "Wellness",
                        ),
                      ],
                    );
                  }),
                ),
              ),

              SizedBox(height: 20.h), // Spacer
              Text('Power Ratings', style: AppStyles.bodyMedium),
              SizedBox(height: 10.h), // Spacer

              Obx(() {
                return _buildProgressWidget(
                  Colors.lightGreen,
                  performanceController
                          .insights
                          .value
                          .data
                          ?.powerRatings
                          .visualization
                          .toInt() ??
                      0,

                  performanceController
                          .insights
                          .value
                          .data
                          ?.powerRatings
                          .visualization
                          .toDouble() ??
                      0.0,
                  'Visualization',
                );
              }),
              SizedBox(height: 20.h),
              Obx(() {
                return _buildProgressWidget(
                  Colors.deepPurple,
                  performanceController
                          .insights
                          .value
                          .data
                          ?.powerRatings
                          .consistency
                          .toInt() ??
                      0,
                  performanceController
                          .insights
                          .value
                          .data
                          ?.powerRatings
                          .consistency
                          .toDouble() ??
                      0.0,
                  'Consistency',
                );
              }),
              SizedBox(height: 20.h),
              Obx(() {
                return _buildProgressWidget(
                  Colors.red,
                  performanceController
                          .insights
                          .value
                          .data
                          ?.powerRatings
                          .lifting
                          .toInt() ??
                      0,
                  performanceController
                          .insights
                          .value
                          .data
                          ?.powerRatings
                          .lifting
                          .toDouble() ??
                      0.0,
                  'Lifting',
                );
              }),
              SizedBox(height: 20.h),
              Obx(() {
                return _buildProgressWidget(
                  Colors.blue,
                  performanceController
                          .insights
                          .value
                          .data
                          ?.powerRatings
                          .recovery
                          .toInt() ??
                      0,
                  performanceController
                          .insights
                          .value
                          .data
                          ?.powerRatings
                          .recovery
                          .toDouble() ??
                      0.0,
                  'Recovery',
                );
              }),
              SizedBox(height: 20.h),
              Obx(() {
                return _buildProgressWidget(
                  Colors.amber,
                  performanceController
                          .insights
                          .value
                          .data
                          ?.powerRatings
                          .wellness
                          .toInt() ??
                      0,
                  performanceController
                          .insights
                          .value
                          .data
                          ?.powerRatings
                          .wellness
                          .toDouble() ??
                      0.0,
                  'Wellness',
                );
              }),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildProgressWidget(
    Color color,
    int labelInt,
    double value,
    String label,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$labelInt',
          style: AppStyles.headingLarge.copyWith(
            color: Colors.white,
            fontSize: 40.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.bodyMedium.copyWith(fontSize: 12.sp),
              ),
              SizedBox(height: 5.h),
              LinearProgressIndicator(
                minHeight: 10.h,

                value: value,
                backgroundColor: AppStyles.cardColor,
                borderRadius: BorderRadius.circular(10.r),
                color: color,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
