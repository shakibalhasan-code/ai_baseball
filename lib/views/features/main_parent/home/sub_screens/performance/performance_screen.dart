import 'package:baseball_ai/core/utils/image_utils.dart';
import 'package:baseball_ai/core/utils/theme/app_styles.dart'; // Assuming this path is correct
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/performance/controller/performance_controller.dart';
import 'package:baseball_ai/views/features/main_parent/profile/controller/profile_controller.dart';
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
    final profileController = Get.find<ProfileController>();
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
              // User Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundImage: NetworkImage(
                      ImageUtils.getProfileImageUrl(
                        profileController
                            .authController
                            .currentUser
                            .value
                            ?.image,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileController
                                .authController
                                .currentUser
                                .value
                                ?.name ??
                            'User',
                        style: AppStyles.bodyMedium.copyWith(fontSize: 18.sp),
                      ),
                      Text(
                        profileController
                                .authController
                                .currentUser
                                .value
                                ?.email ??
                            '',
                        style: AppStyles.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 120,
                width: 120,
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
              SizedBox(height: 20.h), // Spacer
              // Vertical Bar Chart
              Container(
                height: 250.h,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppStyles.cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildVerticalBar(
                        'VIS',
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
                        Colors.lightGreen,
                      ),
                      _buildVerticalBar(
                        'CON',
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
                        Colors.deepPurple,
                      ),
                      _buildVerticalBar(
                        'LIFT',
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
                        Colors.red,
                      ),
                      _buildVerticalBar(
                        'REC',
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
                        Colors.blue,
                      ),
                      _buildVerticalBar(
                        'WELL',
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
                        Colors.amber,
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalBar(
    String label,
    int value,
    double percentage,
    Color color,
  ) {
    const double maxHeight = 200.0;
    final double barHeight = (percentage / 100) * maxHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Value label on top
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            '$value',
            style: AppStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8.h),

        // Vertical bar
        Container(
          width: 40.w,
          height: maxHeight,
          decoration: BoxDecoration(
            color: AppStyles.backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 800),
              width: 40.w,
              height: barHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // Label at bottom
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: Colors.white70,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
