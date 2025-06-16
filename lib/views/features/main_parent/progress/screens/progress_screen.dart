import 'package:baseball_ai/core/utils/theme/app_styles.dart';
import 'package:baseball_ai/views/features/main_parent/progress/controller/progress_controller.dart';
import 'package:baseball_ai/views/glob_widgets/glob_widget_helper.dart';
import 'package:baseball_ai/views/glob_widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProgressScreen extends StatelessWidget {
  ProgressScreen({super.key});

  // // Remove the controller declaration outside build if using Get.put inside build
  // final progressController = Get.find<ProgressController>();

  @override
  Widget build(BuildContext context) {
    // Use Get.put to create or find the controller instance
    final progressController = Get.put(ProgressController());

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,

      appBar: AppBar(
        backgroundColor: AppStyles.cardColor,
        leading: SizedBox.shrink(),
        title: Text(
          'Post Performance/Game Tracker',
          style: AppStyles.headingTitle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scale question and slider
              Text(
                'On a scale of 1 to 10, how did today go?',
                style: AppStyles.bodyMedium.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
              Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: Slider(
                        max: 10,
                        min: 0,

                        // Ensure the value is a double as required by Slider
                        value: progressController.todayScale.value.toDouble(),
                        activeColor: AppStyles.primaryColor,
                        inactiveColor: AppStyles.hintTextColor,
                        // Round the value to the nearest integer when changed
                        onChanged: (v) {
                          progressController.todayScale.value = v.round();
                        },
                      ),
                    ),
                    Text(
                      // Display the integer value
                      progressController.todayScale.value.toString(),
                      style: AppStyles.bodySmall,
                    ),
                  ],
                );
              }),
              SizedBox(height: 20.h), // Added spacing below slider
              // Workload environment question and radio buttons
              Text(
                '(Bullpen/Live at-bats) or in game, assuming that this feature is primarily for the pitchers since the hitting journal already has a space to record at bats as well as outcomes',
                style: AppStyles.bodySmall.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: 10.h), // Spacing above radio buttons
              Obx(() {
                // Use Obx to react to changes in workloadType
                return Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Optional: distributes space
                  children: [
                    // Radio button for Bullpen/Batting Practice
                    Row(
                      mainAxisSize: MainAxisSize.min, // Make row fit content
                      children: [
                        Radio<String>(
                          value: 'Bullpen/Live at-bats',
                          groupValue: progressController.workloadType.value,
                          activeColor: AppStyles.primaryColor,
                          onChanged: (value) {
                            if (value != null) {
                              progressController.workloadType.value = value;
                            }
                          },
                        ),
                        Text(
                          'Bullpen/Live at-bats',
                          style: AppStyles.bodySmall.copyWith(fontSize: 14.sp),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.w), // Space between radio options
                    // Radio button for In game
                    Row(
                      mainAxisSize: MainAxisSize.min, // Make row fit content
                      children: [
                        Radio<String>(
                          value: 'In game',
                          groupValue: progressController.workloadType.value,
                          activeColor: AppStyles.primaryColor,
                          onChanged: (value) {
                            if (value != null) {
                              progressController.workloadType.value = value;
                            }
                          },
                        ),
                        Text(
                          'In game',
                          style: AppStyles.bodySmall.copyWith(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 20.h), // Spacing below radio buttons
              // Pitched game results section
              Text(
                'If you pitched in game today, what were the results of the outing? Type ‘skip’ if you don’t want to submit results.',
                style: AppStyles.bodySmall.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: 10.h), // Spacing above text field
              TextFormField(
                style: AppStyles.bodySmall,
                // Set the text color for input
                cursorColor: AppStyles.primaryColor, // Set cursor color
                controller: progressController.resultsController,
                decoration: InputDecoration(
                  hintText: 'Today\'s results, stats, etc...', // Matches image
                  enabledBorder: OutlineInputBorder(
                    // Added for consistency
                    borderSide: BorderSide(
                      color: AppStyles.hintTextColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // Border when focused
                    borderSide: BorderSide(
                      color: AppStyles.primaryColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ), // Optional: adds slight curve
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ), // Adjust padding
                ),
              ),
              SizedBox(height: 20.h), // Spacing between text fields
              Text(
                // Primary takeaway section              Text(
                'What was your primary takeaway from today?',
                style: AppStyles.bodySmall.copyWith(fontSize: 14.sp),
              ),

              SizedBox(height: 8.h), // Spacing above text field
              TextFormField(
                style: AppStyles.bodySmall,
                // Set the text color for input
                cursorColor: AppStyles.primaryColor, // Set cursor color
                controller: progressController.takeawayController,
                maxLines: 4, // Allows multiple lines

                decoration: InputDecoration(
                  hintText:
                      'Describe the most important thing you can takeaway from today...', // Matches image

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyles.hintTextColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyles.primaryColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                ),
              ),

              // Removed the extra Form widget as it wasn't adding value without validation
              // Removed the Spacer() as it's often not effective in SingleChildScrollView
              // const Spacer(),

              // Submit Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.w,
                  vertical: 20.h,
                ), // Adjusted vertical padding
                child: Obx(
                  () => MyTextButton(
                    isOutline: false,
                    buttonText:
                        progressController.isSubmitting.value
                            ? 'Submitting...'
                            : 'Submit',
                    onTap:
                        progressController.isSubmitting.value
                            ? () {}
                            : () => progressController.submitProgress(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Note: The bottom navigation bar is not part of this screen's build method
      // and should be handled by a parent widget like a Scaffold with bottomNavigationBar
    );
  }
}
