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
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Baseball Card Style Container
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppStyles.cardColor,
                      AppStyles.cardColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    // Profile Section
                    Row(
                      children: [
                        // Rectangle Profile Image
                        Container(
                          width: 120.w,
                          height: 160.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.amber, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Obx(
                              () => Image.network(
                                ImageUtils.getProfileImageUrl(
                                  profileController
                                      .authController
                                      .currentUser
                                      .value
                                      ?.image,
                                ),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[800],
                                    child: Icon(
                                      Icons.person,
                                      size: 60.sp,
                                      color: Colors.white54,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 20.w),

                        // Player Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12.h),
                              // Player Name
                              Obx(
                                () => Wrap(
                                  children: [
                                    Text(
                                      (profileController
                                                  .authController
                                                  .currentUser
                                                  .value
                                                  ?.name ??
                                              'PLAYER NAME')
                                          .toUpperCase(),
                                      style: AppStyles.bodyMedium.copyWith(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // Overall Rating Badge
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      child: Text(
                                        profileController
                                                .authController
                                                .currentUser
                                                .value
                                                ?.status
                                                .toUpperCase() ??
                                            'N/A',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // Stats Grid
                              _buildStatsGrid(profileController),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30.h),

                    // Performance Title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'PERFORMANCE METRICS',
                        style: AppStyles.bodyMedium.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Vertical Bar Chart
                    Container(
                      height: 300.h,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppStyles.backgroundColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Obx(() {
                        return Column(
                          children: [
                            // Radial Chart
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Obx(() {
                                return RadialPerformanceChart(
                                  radius: 50,
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
                            Row(
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
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
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
    const double maxHeight = 160.0;
    final double barHeight = (percentage / 100) * maxHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Value label on top
        Text(
          '$value',
          style: AppStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),

        // Vertical bar
        Container(
          width: 32.w,
          height: maxHeight,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              width: 32.w,
              height: barHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 8.h),

        // Label at bottom
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: Colors.white70,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(ProfileController profileController) {
    return Column(
      children: [
        // First row of stats
        Row(
          children: [
            Expanded(child: _buildStatItem('OVERALL', 'N/A', Colors.amber)),
            SizedBox(width: 20.w),
            Expanded(
              child: _buildStatItem(
                'TYPE',
                profileController.authController.currentUser.value?.playerType
                        .toString() ??
                    'N/A',
                Colors.blue,
              ),
            ),
          ],
        ),

        SizedBox(height: 42.h),

        // // Second row of stats
        // Row(
        //   children: [
        //     Expanded(child: _buildStatItem('HEIGHT', '6\'3"', Colors.blue)),
        //     SizedBox(width: 20.w),
        //     Expanded(child: _buildStatItem('AGE', '26', Colors.blue)),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
